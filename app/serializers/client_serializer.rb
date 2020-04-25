# frozen_string_literal: true

# Serializer to Client Model
class ClientSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :cpf, :created_at
end
