class V1::StepsController < ApplicationController
  LANGUAGES = {
    "en" => {
      language: 'english',
      name: 'en-US-Studio-M',
      language_code: 'en-US'
    },
    "ua" => {
      language: 'українська',
      name: 'uk-UA-Standard-A',
      language_code: 'uk-UA'
    },
    "es" => {
      language: 'Spanish',
      name: 'es-ES-Wavenet-B',
      language_code: 'es-ES'
    }
  }

  def show
    return render json: "No content provided", status: :unprocessable_entity unless content_params

    response = client.chat(
      parameters: {
        model: ENV.fetch("OPENAI_MODEL"),
        messages: messages(content_params.first(4000), language_short_name_params),
        temperature: 0.2
      }
    )
    choices = response.dig("choices")

    if choices
      language = LANGUAGES.dig(language_short_name_params)
      result = GoogleCloud::TextToSpeech.new(
        content: choices.dig(0, "message", "content"),
        name: language[:name],
        language_code: language[:language_code]
      )

      return render json: result.error unless result.success?

      filename = SecureRandom.hex(10)

      GoogleCloud::Storage.upload_file(filename: "#{filename}.mp3", content: result.audio_content)

      render json: { src: "https://storage.googleapis.com/hackaton-trainual/#{filename}.mp3" }, status: :ok
    else
      render json: response.dig("error", "message"), status: :unprocessable_entity unless choices
    end
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def messages(content, language_short_name)
    [
      {
        "role": "system",
        content: [
          'You are a helpful AI writing assistant',
          "The user will provide you content. Translate it into language: #{LANGUAGES.dig(language_short_name, :language)}"
        ].join('. ')
      },
      {
        "role": "assistant",
        "content": "Please provide content"
      },
      {
        "role": "user",
        "content": content
      }
    ]
  end

  def content_params
    params.dig(:content)
  end

  def language_short_name_params
    params.dig(:language_short_name) || LANGUAGES.keys.first
  end
end
