# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:client) { FactoryBot.create(:client) }

  # Respond_to validations
  it { is_expected.to respond_to(:cpf) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }

  # Presence validations
  it { is_expected.to validate_presence_of(:cpf) }

  # Uniqueness validations
  it { expect(client).to validate_uniqueness_of(:cpf).ignoring_case_sensitivity }

  it 'CPF should saved without special caracters' do
    expect(client.cpf.scan(/\D/)).to be_empty
  end

  context 'when create a client with invalid CPF' do
    let(:client_with_invalid_cpf) do
      FactoryBot.build_stubbed(:client, :with_invalid_cpf)
    end

    it 'should be consider invalid client' do
      expect(client_with_invalid_cpf.valid?).to be_falsy
    end

    it 'should return error message' do
      client_with_invalid_cpf.valid?
      expect(client_with_invalid_cpf.errors.full_messages.present?).to eq(true)
    end
  end
end
