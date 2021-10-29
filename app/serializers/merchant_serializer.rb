class MerchantSerializer
  include JSONAPI::Serializer

  attributes :name

  def self.empty
    { data:
      { "id": nil,
        "type": 'merchant',
        "attributes":
         { "name": nil }
      }
    }
  end 
end
