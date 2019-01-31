require 'sinatra'
require 'net/http'
require 'google/protobuf/well_known_types'
require './protos/broker_message_pb'
require './protos/generate_pdf_pb'

set :bind, '0.0.0.0'
set :port, '8069'

  post '/generate-pdfs' do
    encoded_message = request.body.read

    broker_message = decode_broker_message(encoded_message)
    pdf_message = decode_pdf_message(broker_message)

    puts "PDF SERVICE - Stating to process the following:"
    puts broker_message.to_hash
    puts pdf_message.to_hash
    puts "***** END *****"

    status 201
  end

def decode_broker_message(message)
  broker_message = BrokerMessage.decode(message)
end

def decode_pdf_message(broker_message)
  klass = Object.const_get(broker_message.message_class)
  any = broker_message.payload
  unpacked_payload = any.unpack(klass)
  unpacked_payload
end