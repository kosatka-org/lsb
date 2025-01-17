require './models'

class ImageFixJob
  include Sidekiq::Worker

  def perform
    Product.where(large_image: '', images: Image.where(cover_photo: true)).each do |p|
      ims = p.images_dataset.where(cover_photo: true).map(:filename)
      p.update(large_image: ims[0], small_image: ims[1])
    end
  end
end
