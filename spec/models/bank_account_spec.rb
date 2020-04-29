# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  context 'methods and attributes' do
    it { is_expected.to respond_to(:cpf) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:birth_date) }
    it { is_expected.to respond_to(:gender) }
    it { is_expected.to respond_to(:city) }
    it { is_expected.to respond_to(:state) }
    it { is_expected.to respond_to(:country) }
    it { is_expected.to respond_to(:referral_code) }
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

    context 'name attribute' do
      it 'encrypt value should different then value' do
        expect(@client.name).not_to eq(@raw_data['name'])
      end

      it 'database value should equal encrypt value' do
        expect(
          SymmetricEncryption.encrypt(@client.name, random_iv: false)
        ).to eq(@raw_data['name'])
      end
    end

    context 'email attribute' do
      it 'encrypt value should different then value' do
        expect(@client.email).not_to eq(@raw_data['email'])
      end

      it 'database value should equal encrypt value' do
        expect(
          SymmetricEncryption.encrypt(@client.email, random_iv: false)
        ).to eq(@raw_data['email'])
      end
    end

    context 'birth_date attribute' do
      it 'encrypt value should different then value' do
        expect(@client.birth_date).not_to eq(@raw_data['birth_date'])
      end

      it 'database value should equal encrypt value' do
        expect(SymmetricEncryption.encrypt(
                 @client.birth_date, random_iv: false, type: :date
               )).to eq(@raw_data['birth_date'])
      end

      it 'return value in Date type' do
        expect(@client.birth_date.is_a?(Date)).to eq(true)
      end
    end
  end
end
