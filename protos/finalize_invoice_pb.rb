# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: finalize_invoice.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "FinalizeInvoice" do
    repeated :invoice_ids, :string, 1
  end
end

FinalizeInvoice = Google::Protobuf::DescriptorPool.generated_pool.lookup("FinalizeInvoice").msgclass