require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @admin2 = users(:admin2)
    @user = users(:user)
    @user2 = users(:user2)
    @new_user = { username: "user3", email_address: "user3@address.com", is_admin: false }
  end

  test "should get index as admin" do
    login_admin
    get users_url
    assert_response :success
  end

  test "should not get index as non admin" do
    get users_url
    assert_response :unauthorized
    login_user
    assert_redirected_to backend_root_url
  end

  test "should get arbitrary user as admin" do
    login_admin
    get user_url(@admin)
    assert_response :success
    get user_url(@admin2)
    assert_response :success
    get user_url(@user)
    assert_response :success
  end

  test "should only get self as non admin user" do
    get user_url(@admin)
    assert_response :unauthorized
    get user_url(@user)
    assert_response :unauthorized

    login_user
    get user_url(@admin)
    assert_response :unauthorized
    get user_url(@user)
    assert_response :success
    get user_url(@user2)
    assert_response :unauthorized
  end

  test "should get new only as admin" do
    get new_user_url
    assert_response :unauthorized
    login_user
    get new_user_url
    assert_response :unauthorized
    login_admin
    get new_user_url
    assert_response :success
  end

  test "should get edit for arbitrary user as admin" do
    login_admin
    get edit_user_url(@user)
    assert_response :success
    get edit_user_url(@user2)
    assert_response :success
    get edit_user_url(@admin)
    assert_response :success
    get edit_user_url(@admin2)
    assert_response :success
  end

  test "should only get edit for self as non admin" do
    get edit_user_url(@user)
    assert_response :unauthorized
    get edit_user_url(@admin)
    assert_response :unauthorized

    login_user
    get edit_user_url(@user)
    assert_response :success
    get edit_user_url(@user2)
    assert_response :unauthorized
    get edit_user_url(@admin)
    assert_response :unauthorized
  end

  test "should only create as admin" do
    post users_url, params: { user: @new_user }
    assert_response :unauthorized
    login_user
    post users_url, params: { user: @new_user }
    assert_response :unauthorized
    login_admin
    assert_difference("User.count") do
      post users_url, params: { user: @new_user }
      assert_response :found
    end
  end

  test "should update all as admin" do
    login_admin
    patch user_url(@admin), params: { user: { username: @admin.username, email_address: @admin.email_address, is_admin: @admin.is_admin } }
    assert_redirected_to users_url
    patch user_url(@admin2), params: { user: { username: @admin2.username, email_address: @admin2.email_address, is_admin: @admin2.is_admin } }
    assert_redirected_to users_url
    patch user_url(@user), params: { user: { username: @user.username, email_address: @user.email_address, is_admin: @user.is_admin } }
    assert_redirected_to users_url
  end

  test "should only update own username as non admin" do
    patch user_url(@admin), params: { user: { username: @admin.username } }
    assert_response :unauthorized
    patch user_url(@user), params: { user: { username: @user.username } }
    assert_response :unauthorized

    login_user
    patch user_url(@user), params: { user: { username: @user.username } }
    assert_redirected_to edit_user_url(@user)
    patch user_url(@user), params: { user: { username: @user.username, email_address: @user.email_address } }
    assert_response :unauthorized
    patch user_url(@user), params: { user: { username: @user.username, is_admin: true } }
    assert_response :unauthorized
    patch user_url(@user2), params: { user: { username: @user2.username } }
    assert_response :unauthorized
    patch user_url(@admin), params: { user: { username: @admin.username } }
    assert_response :unauthorized
  end

  test "should destroy any user as admin" do
    login_admin
    delete user_url(@user)
    assert_redirected_to users_url
    delete user_url(@admin2)
    assert_redirected_to users_url
    delete user_url(@admin)
    assert_redirected_to root_url
  end

  test "should only destroy self as non andmin" do
    delete user_url(@user)
    assert_response :unauthorized
    delete user_url(@admin)
    assert_response :unauthorized

    login_user
    delete user_url(@admin)
    assert_response :unauthorized
    delete user_url(@user2)
    assert_response :unauthorized
    delete user_url(@user)
    assert_redirected_to root_url
  end

  test "should get forgot password" do
    get forgot_password_url
    assert_response :success
    login_user
    get forgot_password_url
    assert_response :success
    login_admin
    get forgot_password_url
    assert_response :success
  end

  test "should generate forgot password code if email address exists" do
    assert_difference("ResetPasswordCode.count", 0) do
      post forgot_password_url, params: { email_address: "doesnt@exist.lol" }
      assert_redirected_to forgot_password_url
    end
    assert_difference("ResetPasswordCode.count", 1) do
      post forgot_password_url, params: { email_address: @user.email_address }
      assert_redirected_to forgot_password_url
    end
    assert_difference("ResetPasswordCode.count", 0) do
      post forgot_password_url, params: { email_address: @user.email_address }
      assert_redirected_to forgot_password_url
    end
  end

  test "should generate reset code only for self as non admin" do
    assert_difference("ResetPasswordCode.count", 0) do
      put reset_password_request_url(@user)
      assert_response :unauthorized
    end

    login_user
    assert_difference("ResetPasswordCode.count", 1) do
      put reset_password_request_url(@user)
      assert_redirected_to edit_user_url(@user)
    end
    assert_difference("ResetPasswordCode.count", 0) do
      put reset_password_request_url(@user2)
      assert_response :unauthorized
    end
  end

  test "should generate reset codes for any user as admin" do
    login_admin
    assert_difference("ResetPasswordCode.count", 1) do
      put reset_password_request_url(@admin)
      assert_redirected_to edit_user_url(@admin)
    end
    assert_difference("ResetPasswordCode.count", 1) do
      put reset_password_request_url(@admin2)
      assert_redirected_to edit_user_url(@admin2)
    end
    assert_difference("ResetPasswordCode.count", 1) do
      put reset_password_request_url(@user)
      assert_redirected_to edit_user_url(@user)
    end
  end

  test "should cleanly regenerate reset codes" do
    assert_difference("ResetPasswordCode.count", 1) do
      post forgot_password_url, params: { email_address: @user.email_address }
    end
    old_code = ResetPasswordCode.find_by(user: @user).code

    assert_difference("ResetPasswordCode.count", 0) do
      post forgot_password_url, params: { email_address: @user.email_address }
      assert_not_equal old_code, ResetPasswordCode.find_by(user: @user).code
    end
    old_code = ResetPasswordCode.find_by(user: @user).code

    login_user
    assert_difference("ResetPasswordCode.count", 0) do
      put reset_password_request_url(@user)
      assert_not_equal old_code, ResetPasswordCode.find_by(user: @user).code
    end
  end

  test "should get reset password" do
    ResetPasswordCode.new(user: @user, code: SecureRandom.alphanumeric(32)).save!
    get reset_password_url(ResetPasswordCode.find_by(user: @user).code)
    assert_response :success
  end

  test "should submit reset password" do
    code = SecureRandom.alphanumeric(32)
    ResetPasswordCode.new(user: @user, code: code).save!
    assert_difference("ResetPasswordCode.count", -1) do
      patch reset_password_url(code), params: { user: { username: "newusername", password: "newpassword", password_confirmation: "newpassword" } }
    end
    post login_url, params: { username: "newusername", password: "newpassword" }
    assert_redirected_to backend_root_url
  end

  test "should handle invalid reset keys" do
    expired_code = SecureRandom.alphanumeric(32)
    ResetPasswordCode.new(
        user: @user,
        code: expired_code,
        is_activation_code: true, created_at: ENV.fetch("ACCOUNT_ACTIVATION_CODE_VALIDITY_DAYS", 14).to_i.days.ago - 1.day
      ).save!

    assert_difference("ResetPasswordCode.count", 0) do
      get reset_password_url(SecureRandom.alphanumeric(32))
      assert_redirected_to forgot_password_url
    end

    assert_difference("ResetPasswordCode.count", 0) do
      patch reset_password_url(SecureRandom.alphanumeric(32))
      assert_redirected_to forgot_password_url
    end

    assert_difference("ResetPasswordCode.count", -1) do
      patch reset_password_url(expired_code), params: { user: { username: "newusername" } }
      assert_redirected_to forgot_password_url
      @user.reload
      assert_not_equal @user.username, "newusername"
    end
  end
end
