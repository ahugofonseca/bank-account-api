# frozen_string_literal: true

# Authorization policies to Client Model
class ClientPolicy < ApplicationPolicy
  def my_indications?
    record.complete?
  end
end
