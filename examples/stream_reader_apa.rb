$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'onix'

reader = ONIX::Reader.new(File.join(File.dirname(__FILE__),"..","data","Bookwise_July_2008.xml"))
#reader = ONIX::StreamReader.new(File.join(File.dirname(__FILE__),"..","data","Ashgate Other.xml"), ::ONIX::APAProduct)
#reader = ONIX::StreamReader.new(File.join(File.dirname(__FILE__),"..","data","9780194351898.xml"), ::ONIX::APAProduct)
#reader = ONIX::StreamReader.new(File.join(File.dirname(__FILE__),"..","data","jul.xml"), ::ONIX::APAProduct)
#reader = ONIX::StreamReader.new(File.join(File.dirname(__FILE__),"..","data","rba_FANT.xml"))
counter = 0

reader.each do |item|
  puts item.record_reference
  puts item.id(:ean)
  puts item.title
  puts
  counter += 1
end

puts "total of ##{counter} products"
