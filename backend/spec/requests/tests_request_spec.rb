require 'rails_helper'

RSpec.describe "Create Tests", type: :request do

  it 'returns created status after creating a new test' do
    headers = { 'ACCEPT' => 'application/json' }
    post '/api/v1/tests', :params => { :test => { cat_name: 'Ziggy', legs: 3 }}, :headers => headers
    expect(response).to have_http_status(200)
  end
end