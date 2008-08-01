BASE_PATH = File.join(File.dirname(__FILE__), "..")

$LOAD_PATH.unshift "#{BASE_PATH}/lib/"
require 'onix'

filename = File.join(BASE_PATH,"data","9780194351898.xml")
reader = ONIX::Reader.new(filename)

puts "From Company: #{reader.header.from_company}"
puts "From Person: #{reader.header.from_person}"

reader.each do |prod|
  puts
  puts prod.notification_type
  puts prod.isbn10
  puts prod.isbn13
  puts prod.product_form
end

puts
