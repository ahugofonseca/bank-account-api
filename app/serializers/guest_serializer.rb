# frozen_string_literal: true

# Serializer to Client Model
class GuestSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name
end
