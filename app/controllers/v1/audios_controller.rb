class V1::AudiosController < ApplicationController
  def index
    return render json: Audio.all if folder_id == "all"

    render json: Audio.where(folder_id: folder_id)
  end

  def create
    return render json: "No link provided", status: :unprocessable_entity unless link

    sanitized_content = Nokogiri::WebsiteScraper.parse(link:)

    response = client.chat(
      parameters: {
        model: ENV.fetch("OPENAI_MODEL"),
        messages: messages(sanitized_content),
        temperature: 0.5
      }
    )
    choices = response.dig("choices")

    if choices
      choices_json = JSON.parse(choices.dig(0, "message", "content"))
      result = GoogleCloud::TextToSpeech.new(content: choices_json.dig("content"))

      return render json: result.error unless result.success?

      filename = choices_json.dig("title").parameterize(separator: '_')

      GoogleCloud::Storage.upload_file(filename: "#{filename}.mp3", content: result.audio_content)

      audio = Audio.new(
        folder_id: params[:folder_id],
        title: choices_json.dig("title"),
        link: link,
        src: "https://storage.googleapis.com/hackaton-trainual/#{filename}.mp3"
      )

      if audio.save
        render json: audio, status: :ok
      else
        render json: audio.errors
      end
    else
      render json: response.dig("error", "message"), status: :unprocessable_entity unless choices
    end
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def messages(website_content)
    [
      {
        "role": "system",
        content: [
          'You are a helpful AI writing assistant',
          'Follow these instructions:',
          'Step 1 - The user will provide you with sanitized content. Respond with structured data as shown in the example',
          'Example: title: "...", content: "..."',
          'Step 2 - Analyze the provided website content and provide short title - 4 words maximum and a content summary - 200 words maximum',
          'Step 3 - Your response should be a JSON with no newline characters or anything else',
        ].join('. ')
      },
      {
        "role": "assistant",
        "content": "Please provide website content"
      },
      {
        "role": "user",
        "content": website_content
      }
    ]
  end

  def folder_id
    params[:folder_id] || "all"
  end

  def link
    params.dig(:link)
  end
end
