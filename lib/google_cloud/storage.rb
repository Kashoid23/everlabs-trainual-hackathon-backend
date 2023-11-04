require "google/cloud/storage"

class GoogleCloud::Storage
  class << self
    def upload_file(filename:, content:)
      bucket = client.bucket ENV["GOOGLE_CLOUD_BUCKET"]

      file = bucket.create_file(StringIO.new(content), filename)
      file.download
    end

    def client
      @client ||= Google::Cloud::Storage.new
    end
  end
end
