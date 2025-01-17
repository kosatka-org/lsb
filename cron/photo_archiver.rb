require 'date'
require './db_connect.rb'
require './models.rb'
require 'net/http'
require 'net/ftp'
require 'sequel'
require 'celluloid/autostart'

class MyWorker
  include Celluloid
  finalizer :finalizer

  def initialize
    super
    @ftp = Net::FTP.new(ENV['FTP_HOST'])
    @ftp.login(ENV['FTP_USER'], ENV['FTP_PASSWORD'])
    ftp_mkdir('luxury_photo')
  end

  def ftp_mkdir(dir_name)
    unless @ftp.nlst.include?(dir_name)
      @ftp.mkdir(dir_name) rescue nil
    end
    @ftp.chdir(dir_name)
  end

  def process_prod(files, brand, sku)
    ftp_mkdir(brand)
    ftp_mkdir(sku)
    Dir.chdir('/files/products/') do
      files.each do |file|
        filename = file[:name]
        @ftp.putbinaryfile(filename)
        File.delete(filename)
      end
    end
    @ftp.chdir("../..")
  end

  def finalizer
    @ftp.close
  end

end

supervisor = Celluloid::SupervisionGroup.run!
supervisor.pool(MyWorker, as: :work, size: 6)

date_scope = (Date.today<<6).strftime("%Y-%m")
products = Product.where(sold_date: /#{date_scope}/).exclude(large_image: '')

products.each do |product|

  files = [product.large_image]
  unless product.small_image.empty?
    files.push(product.small_image)
  end
  files.push( *product.all_images_dataset.map(:filename) ).uniq!
  sku = product[:sku]
  brand = product.brand.name
  supervisor[:work].async.process_prod(files, brand, sku)

end
