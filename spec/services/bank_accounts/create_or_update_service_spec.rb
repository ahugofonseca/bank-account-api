# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankAccounts::UseCases::CreateOrUpdateService do
  let!(:client) { create(:client, :bank_account_pending) }

  describe 'when it runs successfully ' do
    context 'when update all data' do
      let(:bank_account) { build(:bank_account, cpf: client.cpf) }
      let(:service) { bank_account.open_or_update_account }

      it '#satisfied_all return true' do
        expect(service.satisfied_all?).to be_truthy
      end

      it 'update client table with data' do
        service.call && client.reload
        expect(client.bank_account.as_json).to eq(bank_account.as_json)
      end

      it 'update status to complete' do
        service.call && client.reload
        expect(client.complete?).to be_truthy
      end

      it 'generate uniq referral_code' do
        service.call && client.reload
        expect(client.referral_code.present?).to be_truthy
      end

      it '#response return message' do
        service.call && client.reload
        expect(service.response.key?(:message)).to be_truthy
      end

      it '#response return referral_code' do
        service.call && client.reload
        expect(service.response.key?(:referral_code)).to be_truthy
      end

      it '#response return bank_account' do
        service.call && client.reload
        expect(service.response.key?(:bank_account)).to be_truthy
      end
    end

    context 'when partially update data' do
      let(:bank_account) { build(:bank_account, :account_pending, cpf: client.cpf) }
      let(:service) { bank_account.open_or_update_account }

      it '#satisfied_all return true' do
        expect(service.satisfied_all?).to be_truthy
      end

      it 'update client table with data' do
        service.call && client.reload
        expect(client.bank_account.as_json).to eq(bank_account.as_json)
      end

      it 'update status to pending' do
        service.call && client.reload
        expect(client.pending?).to be_truthy
      end

      it '#response return message' do
        service.call && client.reload
        expect(service.response.key?(:message)).to be_truthy
      end

      it '#response return bank_account' do
        service.call && client.reload
        expect(service.response.key?(:bank_account)).to be_truthy
      end
    end
  end

  describe 'when it runs faulty' do
    context 'when dont passed instance of Bank Account' do
      let(:bank_account) { 'string instance' }

      it 'return service contract exception' do
        expect do
          BankAccounts::UseCases::CreateOrUpdateService.new(bank_account)
        end.to raise_error(ServiceContractError)
      end
    end

    context 'when passed invalid instance of Bank Account' do
      let(:bank_account) { build(:bank_account, :with_invalid_email, cpf: client.cpf) }
      let(:service) { bank_account.open_or_update_account }

      it '#satisfied_all return validation exception' do
        expect do
          service.satisfied_all?
        end.to raise_error(ActiveModel::ValidationError)
      end

      it '#call return validation exception' do
        expect do
          service.satisfied_all?
        end.to raise_error(ActiveModel::ValidationError)
      end
    end
  end
end
