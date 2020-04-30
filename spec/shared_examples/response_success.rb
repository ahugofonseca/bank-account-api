# frozen_string_literal: true

RSpec.shared_examples 'attr in success response' do |attr1, attr2 = nil|
  it "should return success #{attr2} in #{attr1}" do
    body = JSON.parse(response.body).dig('data', attr1)
    body = attr2.present? ? body.dig(attr2) : body

    expect(body.present?).to be_truthy
  end
end
