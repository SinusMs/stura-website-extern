require "test_helper"
require "json"

class UserTest < ActiveSupport::TestCase
  test "create with valid userdata" do
    user = User.new(username: valid_username, password: valid_password, is_admin: false)
    if !user.validate
      user.errors.each do |error|
        puts error.full_message
      end
    end
    assert user.validate
  end

  test "create with invalid userdata" do
    assert_raise(Exception) { User.create!(username: valid_username, password: "", is_admin: false) }
    assert_raise(Exception) { User.create!(username: valid_username, password: "1", is_admin: false) }
    assert_raise(Exception) { User.create!(username: valid_username, password: "12", is_admin: false) }
    assert_raise(Exception) { User.create!(username: "", password: valid_password, is_admin: false) }
    assert_raise(Exception) { User.create!(username: "1", password: valid_password, is_admin: false) }
    assert_raise(Exception) { User.create!(username: "12", password: valid_password, is_admin: false) }
    assert_raise(Exception) { User.create!(username: users(:admin).username, password: valid_password, is_admin: false) }
    assert_raise(Exception) { User.create!(username: "*admin", password: valid_password, is_admin: false) }
    assert_raise(Exception) { User.create!(username: "%admin", password: valid_password, is_admin: false) }
    assert_raise(Exception) { User.create!(username: "%admin", is_admin: false) }
  end

  test "valid updates" do
    users(:admin).update!(password: "12345", password_confirmation: "12345")
    users(:admin).update!(username: "different_admin")
    assert true
  end

  test "invalid updates" do
    assert_raise(Exception) { users(:admin).update!(password: "12345", password_confirmation: "1234") }
    assert_raise(Exception) { users(:admin).update!(username: users(:user).username) }
  end

  private

  def valid_username
    "test_user"
  end

  def valid_password
    "123"
  end
end
