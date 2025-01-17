require './product_import.rb'

class ProductImportJob
  include Sidekiq::Worker

  def perform(args = {'csv' => "exchange/export.csv"})
    ProductImport.new(args['csv']).run!
  end
end
