require 'sinatra'
require 'net/http'
require 'google/protobuf/well_known_types'
require './finalize_pb'
require './protos/broker_message_pb'
require './protos/finalize_invoice_pb'
require './protos/generate_pdf_pb'
require 'securerandom'

set :bind, '0.0.0.0'

PDF_SERVICE_PORT = 8069
PDF_SERVICE_HOST = 'localhost'
PDF_SERVICE_URI = "http://#{PDF_SERVICE_HOST}/generate-pdfs"

FINALIZE_SERVICE_PORT = 8070
FINALIZE_SERVICE_HOST = 'localhost'
FINALIZE_SERVICE_URI = "http://#{PDF_SERVICE_HOST}/finalize"

  get '/generate-pdfs' do
    ids = params["invoice_ids"]

    pdf_message = GeneratePDF.new(
      pdf_ids: ids
    )

    broker_message = BrokerMessage.new(
      uuid: SecureRandom.uuid,
      origin: "IXV2",
      message_class: pdf_message.class.to_s,
      payload: pack_message(pdf_message)
    )

    broker_message_encoded = BrokerMessage.encode(broker_message)

    http_post(PDF_SERVICE_URI, PDF_SERVICE_PORT, broker_message_encoded)
    
    status 200
  end

  get '/finalize-invoices' do
    ids = params["invoice_ids"]

    finalize_message = FinalizeInvoice.new(
      invoice_ids: ids
    )

    broker_message = BrokerMessage.new(
      uuid: SecureRandom.uuid,
      origin: "IXV2",
      message_class: finalize_message.class.to_s,
      payload: pack_message(finalize_message)
    )

    broker_message_encoded = BrokerMessage.encode(broker_message)

    http_post(FINALIZE_SERVICE_URI, FINALIZE_SERVICE_PORT, broker_message_encoded)
    
    status 200
  end


def encode_message(id, message)
  message = FinalizeRequest.new(
    id: id.to_i,
    message: message
  )
  serialized = FinalizeRequest.encode(message)
end

def pack_message(message)
  any = Google::Protobuf::Any.new
  any.pack message
  any
end

def http_post(uri, port, message)
  uri = URI(uri)
  req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/protobuf')
  req.body = message

  Net::HTTP.start(uri.hostname, port) do |http|
    http.request(req)
  end
end