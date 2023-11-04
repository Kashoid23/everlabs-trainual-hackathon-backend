class GoogleCloud::TextToSpeech
  attr_reader :error
  attr_reader :audio_content

  def initialize(content:)
    @error  = nil
    @audio_content = nil
    @success = convert(content:)
  end

  def convert(content:)
    response = client.synthesize_speech(
      input: { text: content },
      voice: { name: 'en-US-Studio-M', language_code: 'en-US' },
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
