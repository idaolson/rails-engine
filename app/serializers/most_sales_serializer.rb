class MerchantItemsSoldSerializer
  include JSONAPI::Serializer

  attributes :name, :count
end
