# Objective

Have one server sending HTTP requests to two services, using protocol buffers as the exchanged messages.

This also serves as a proof of concept as we can achieve polymorphic types with protobuf.

# INDEX
  * [How it works](#How-it-works)
  * [How to use this](#How-to-use-this)
  * [Requirements](#Requirements)
  * [Install](#Install)

## How it works

* `v2_requests_router.rb` receives a `GET` request.
* Based on this request, a message is sent to **either** `PDF service` or `Finalize service`

### About the message generated
  * Generated with a protocol buffer
  * This message has a field named `payload`
  * This is a polymorphic field of type either `FinalizeInvoice` or `GeneratePDF`

### PDF Service and Finalize Service
  * Both are listening for a `POST`
  * Both decode the message, encoded as a protocol buffer
  * Both display the message received on the console using `puts`

# Requirements

* Protobuf. [check installation guide](https://github.com/protocolbuffers/protobuf)
* Ruby (this was tested with version 2.4)
* Bundler

# Install

`bundle install`

## How to generate ruby classes from .proto files

* Move to protos folder `cd protos`
* Generate classes `protoc --ruby_out=./ *.proto`
  * this command compiles all the files named `*.proto` as ruby files, and saves the ruby files in the `--ruby_out` path

## How to use this

* open 3 consoles
* `ruby v2_requests_router.rb`
* `ruby pdf_service.rb`
* `ruby finalize_service.rb`
* Example of request to finalize invoices
  * `curl -X GET 'http://localhost:4567/finalize-invoices?invoice_ids[]=124124,62322'`
* Example of request to generate PDF
  * `curl -X GET 'http://localhost:4567/generate-pdfs?invoice_ids[]=234335,222222'`
