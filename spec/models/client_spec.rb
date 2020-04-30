# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  context 'methods and attributes' do
    it { is_expected.to respond_to(:cpf) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:bank_account) }
  end

  context 'validations and DB indexes' do
    # Presence validations
    it { is_expected.to validate_presence_of(:cpf) }

    # Uniqueness validations
    it { is_expected.to validate_uniqueness_of(:cpf) }

    # DB Indexes
    it { is_expected.to have_db_index(:cpf).unique }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:referral_code).unique }

    # Custom validations
    it 'CPF should be valid' do
      client = build_stubbed(:client)
      expect(CPF.valid?(client.cpf)).to be(true)
    end
  end

  context 'when create a client with invalid CPF' do
    let!(:client_with_invalid_cpf) do
      build_stubbed(:client, :with_invalid_cpf)
    end

    it 'should be consider invalid client' do
      expect(client_with_invalid_cpf.valid?).to be_falsy
    end

    it 'should return error message' do
      client_with_invalid_cpf.valid?
      expect(client_with_invalid_cpf.errors.full_messages.present?).to eq(true)
    end
  end

  context 'when storage encrypt data' do
    before(:all) do
      @client = create(:client)
      @raw_data = Client.connection
                        .select_all('select * from clients limit 1;').first
    end

    context 'cpf attribute' do
      it 'encrypt value should different then value' do
        expect(@client.cpf).not_to eq(@raw_data['cpf'])
      end

      it 'database value should equal encrypt value' do
        expect(
          SymmetricEncryption.encrypt(@client.cpf, random_iv: false)
        ).to eq(@raw_data['cpf'])
      end
    end
  end
end
