# frozen_string_literal: true

RSpec.shared_examples 'attr in error response' do |attr, jwt, skip_request = false|
  it "should return error #{attr}" do
    unless skip_request
      request.headers['Authorization'] = jwt

      get :private_action, format: :json
    end

    expect(
      JSON.parse(response.body).dig('error', attr).present?
    ).to eq(true)
  end
end
