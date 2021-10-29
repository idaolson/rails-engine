class MostSalesSerializer
  include JSONAPI::Serializer

  attributes :name, :count
end
