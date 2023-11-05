class GoogleCloud::TextToSpeech
  attr_reader :error
  attr_reader :audio_content

  def initialize(content:, name: 'en-US-Standard-B', language_code: 'en-US')
    @error  = nil
    @audio_content = nil
    @success = convert(content:, name:, language_code:)
  end

  def convert(content:, name:, language_code:)
    response = client.synthesize_speech(
      input: { text: content },
      voice: { name:, language_code: },
      audio_config: { audio_encoding: 'MP3' }
    )

    @audio_content = response.audio_content

    true
  rescue Google::Cloud::InvalidArgumentError => e
    @error = e.message

    false
  end

  def client
    @client ||= Google::Cloud::TextToSpeech.text_to_speech
  end

  def success?
    @success
  end
end
