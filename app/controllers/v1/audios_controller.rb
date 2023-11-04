class V1::AudiosController < ApplicationController
  def index
    render json: Audio.where(folder_id: folder_id_param)
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
      result = GoogleCloud::TextToSpeech.new(content: choices.dig(0, "message", "content"))

      return render json: { error: result.error } unless result.success?

      GoogleCloud::Storage.upload_file(filename:, content: result.audio_content)

      audio = Audio.new(folder_id: params[:folder_id], title: filename.humanize, link: link, src: "https://storage.googleapis.com/hackaton-trainual/#{filename}.mp3")

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
          'Analyze the provided website content and provide a short text summary - 200 words maximum',
          'This should sound like an introduction to the article'
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

  def folder_id_param
    params[:folder_id] || Folder.first.id
  end

  def filename
    url_object = URI.parse(link)
    url_path = url_object.path
    "#{url_path.split("/").last}"
  end

  def link
    params.dig(:link)
  end
end
