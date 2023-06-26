require "rails_helper"

RSpec.describe User, type: :model do
  it "can be created successfully with valid data" do
    user = User.create(username: "test_user", 
      password: "sup3r-secret", 
      first_name: "John", 
      last_name: "Doe", 
      email: "johndoe@gmail.com")
    expect(user).to be_valid
  end

  it "has one account" do
    user = User.reflect_on_association(:account)
    expect(user.macro).to eq(:has_one)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    
    it { is_expected.to validate_uniqueness_of(:username) }
  end

  describe "authenticate" do
    it "returns the user if credentials match" do
      user = User.create(username: "test_user", 
        password: "sup3r-secret", 
        first_name: "John", 
        last_name: "Doe", 
        email: "johndoe@gmail.com")
      expect(user.authenticate("sup3r-secret")).to eq(user)
    end

    it "returns false if credentials don't match" do
      user = User.create(username: "test_user", 
        password: "sup3r-secret", 
        first_name: "John", 
        last_name: "Doe", 
        email: "johndoe@gmail.com")
      expect(user.authenticate("nope")).to be(false)
    end
  end
end