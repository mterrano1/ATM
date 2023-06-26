require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  let!(:user) { User.create(username: "test_user", password: "sup3r-secret", first_name: "John", last_name: "Doe", email: "johndoe@gmail.com") }
  # let!(:account) { Account.create(balance: 1000000, user: user) }

  describe 'GET #show' do

    before do
      Account.create(balance: 1000000, user: user)
    end

    context "with a logged in user" do
      before do
        post "/login", params: { username: user.username, password: user.password }
        get account_path
      end

      it "returns the account associated with the user" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is authenticated and does not have an account' do
      before do
        post "/login", params: { username: user.username, password: user.password }
        get account_path
      end

      it 'creates a new account' do
        expect {
          post account_path
        }.to change(Account, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end
  end
end