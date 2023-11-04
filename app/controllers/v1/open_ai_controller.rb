class V1::OpenAiController < ApplicationController
  def show
    return render json: { error: "No link provided" }, status: :unprocessable_entity unless link

    sanitized_content = Nokogiri::WebsiteScraper.parse(link:)

    # gpt-3.5-turbo - $0.0015 / 1K tokens  | $0.002 / 1K tokens
    # gpt-3.5-turbo-16k - $0.003 / 1K tokens | $0.004 / 1K tokens
    # gpt-4 - $0.03 / 1K tokens	$0.06 / 1K tokens
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo-16k",
        messages: messages(sanitized_content),
        temperature: 0.5
      }
    )
    choices = response.dig("choices")

    if choices
      render json: { data: choices.dig(0, "message", "content") }, status: :ok
    else
      render json: { error: response.dig("error", "message") }, status: :unprocessable_entity unless choices
    end
  end

  private

  def messages(website_content)
    [
      {
        "role": "system",
        content: [
          'You are a helpful AI writing assistant',
          'Analyze the provided website content and provide a short text summary - 300 words maximum',
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

  def client
    @client ||= OpenAI::Client.new
  end

  def link
    params.dig(:link)
  end
end
