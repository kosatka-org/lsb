require 'aws-sdk-s3'

class S3Wrapper
  def initialize
    @service = Aws::S3::Resource.new

    @bucket = @service.bucket(ENV['S3_BUCKET_NAME'])
    @lm_list = parse_last_modified_file
  end

  attr_reader   :service
  attr_accessor :bucket

  def put(filename)
    # bucket.object(filename).upload_file(filename)
    `cp #{filename} exchange/`
  end

  def get(filename)
    # bucket.object(filename).get.body.read.force_encoding("utf-8")
    File.read("exchange/#{filename}").force_encoding("utf-8")
  end

  def last_modified(filename)
    # bucket.object(filename).last_modified
    File.mtime("exchange/#{filename}")
  end

  def get_all_with_prefix(prefix)
    bucket.objects(prefix: prefix)
  end

  # Ensure method returns empty hash if file can not be read
  def parse_last_modified_file
    filename = "last_modified.json"
    contents = File.exist?(filename) ? File.read(filename) : '{}'
    JSON.parse contents
  rescue JSON::ParserError => e
    {}
  end

  def updated?(scriptname, filename)
    last_modified = last_modified(filename).to_i
    if last_modified > @lm_list[scriptname].to_i
      @lm_list[scriptname] = last_modified
      return true
    else
      return false
    end
  end

  def save_last_modified
    File.write("last_modified.json", @lm_list.to_json)
  end
end
