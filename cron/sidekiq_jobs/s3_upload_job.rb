require 'aws-sdk-s3'

class S3UploadJob
  include Sidekiq::Worker
  SERVICE = Aws::S3::Resource.new(access_key_id: ENV['SCALEWAY_ACCESS_KEY'], secret_access_key: ENV['SCALEWAY_SECRET_KEY'], region: 'nl-ams', endpoint: 'https://s3.nl-ams.scw.cloud')

  def perform(args)
    bucket = SERVICE.bucket(args['bucket'] || 'lsboutique-img')
    obj = bucket.object(args['remote_path'])
    obj.upload_file(args['local_path'])
    obj.acl.put({acl: "public-read"})
  end
end
