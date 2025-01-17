module Helpers
  def self.process_size(size)
    if size =~ /.+\((.+)\)/ || size =~ /(.+)\// || size =~ /(\d{2}) \d{2}/
      size = $1
    end
    size.gsub!('2XL', 'XXL')
    if size =~ /(X+)XXL/
      size = "#{$1.length+2}XL"
    end
    size.gsub(/^[е]/,"").gsub(/(\d+)\.(\d+)/, '\1,\2')
  end
end
