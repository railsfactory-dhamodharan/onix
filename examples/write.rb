BASE_PATH = File.join(File.dirname(__FILE__), "..")

$LOAD_PATH.unshift "#{BASE_PATH}/lib/"
require 'onix'
require 'stringio'

header = ONIX::Header.new
header.from_person  = "James"
header.from_company = "Rainbow"

output = StringIO.new
writer = ONIX::Writer.new(output, header)

prod = ONIX::Product.new
prod.notification_type = 3
prod.record_reference = "1234567890"

writer << prod

writer.finish

puts output.string
