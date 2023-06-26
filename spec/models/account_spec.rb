require 'rails_helper'

RSpec.describe Account, type: :model do
  context 'when creating a new account' do
    it 'creates a new account with the correct user and starting balance' do
      user = User.create(username: "test_user", password: "sup3r-secret", first_name: "John", last_name: "Doe", email: "johndoe@gmail.com")
      account = Account.new(user_id: user.id, balance: 1000000)

      expect(account).to be_valid
    end
  end
end