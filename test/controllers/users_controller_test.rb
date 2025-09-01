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
    assert_response :success, "Admin should be able to access users index"
  end

  test "should not get index as non admin" do
    get users_url
    assert_response :unauthorized, "Non-logged-in user should not access users index"
    login_user
    assert_redirected_to backend_root_url, "Non-admin user should be redirected from users index"
  end

  test "should get arbitrary user as admin" do
    login_admin
    get user_url(@admin)
    assert_response :success, "Admin should be able to view own profile"
    get user_url(@admin2)
    assert_response :success, "Admin should be able to view another admin's profile"
    get user_url(@user)
    assert_response :success, "Admin should be able to view a regular user's profile"
  end

  test "should only get self as non admin user" do
    get user_url(@admin)
    assert_response :unauthorized, "Non-logged-in user should not access admin profile"
    get user_url(@user)
    assert_response :unauthorized, "Non-logged-in user should not access own profile"

    login_user
    get user_url(@admin)
    assert_response :unauthorized, "Non-admin user should not access admin profile"
    get user_url(@user)
    assert_response :success, "User should be able to access own profile"
    get user_url(@user2)
    assert_response :unauthorized, "User should not access another user's profile"
  end

  test "should get new only as admin" do
    get new_user_url
    assert_response :unauthorized, "Non-logged-in user should not access new user form"
    login_user
    get new_user_url
    assert_response :unauthorized, "Non-admin user should not access new user form"
    login_admin
    get new_user_url
    assert_response :success, "Admin should access new user form"
  end

  test "should get edit for arbitrary user as admin" do
    login_admin
    get edit_user_url(@user)
    assert_response :success, "Admin should edit regular user"
    get edit_user_url(@user2)
    assert_response :success, "Admin should edit another regular user"
    get edit_user_url(@admin)
    assert_response :success, "Admin should edit self"
    get edit_user_url(@admin2)
    assert_response :success, "Admin should edit another admin"
  end

  test "should only get edit for self as non admin" do
    get edit_user_url(@user)
    assert_response :unauthorized, "Non-logged-in user should not edit own profile"
    get edit_user_url(@admin)
    assert_response :unauthorized, "Non-logged-in user should not edit admin profile"

    login_user
    get edit_user_url(@user)
    assert_response :success, "User should edit own profile"
    get edit_user_url(@user2)
    assert_response :unauthorized, "User should not edit another user's profile"
    get edit_user_url(@admin)
    assert_response :unauthorized, "User should not edit admin profile"
  end

  test "should only create as admin" do
    post users_url, params: { user: @new_user }
    assert_response :unauthorized, "Non-logged-in user should not create user"
    login_user
    post users_url, params: { user: @new_user }
    assert_response :unauthorized, "Non-admin user should not create user"
    login_admin
    assert_difference("User.count", 1, "Admin should be able to create user") do
      post users_url, params: { user: @new_user }
      assert_response :found, "Admin should be redirected after creating user"
    end
  end

  test "should update all as admin" do
    login_admin
    patch user_url(@admin), params: { user: { username: @admin.username, email_address: @admin.email_address, is_admin: @admin.is_admin } }
    assert_redirected_to users_url, "Admin should be redirected after updating self"
    patch user_url(@admin2), params: { user: { username: @admin2.username, email_address: @admin2.email_address, is_admin: @admin2.is_admin } }
    assert_redirected_to users_url, "Admin should be redirected after updating another admin"
    patch user_url(@user), params: { user: { username: @user.username, email_address: @user.email_address, is_admin: @user.is_admin } }
    assert_redirected_to users_url, "Admin should be redirected after updating regular user"
  end

  test "should only update own username as non admin" do
    patch user_url(@admin), params: { user: { username: @admin.username } }
    assert_response :unauthorized, "Non-logged-in user should not update admin"
    patch user_url(@user), params: { user: { username: @user.username } }
    assert_response :unauthorized, "Non-logged-in user should not update self"

    login_user
    patch user_url(@user), params: { user: { username: @user.username } }
    assert_redirected_to edit_user_url(@user), "User should be redirected after updating own username"
    patch user_url(@user), params: { user: { username: @user.username, email_address: @user.email_address } }
    assert_response :unauthorized, "User should not update own email"
    patch user_url(@user), params: { user: { username: @user.username, is_admin: true } }
    assert_response :unauthorized, "User should not update own admin status"
    patch user_url(@user2), params: { user: { username: @user2.username } }
    assert_response :unauthorized, "User should not update another user"
    patch user_url(@admin), params: { user: { username: @admin.username } }
    assert_response :unauthorized, "User should not update admin"
  end

  test "should destroy any user as admin" do
    login_admin
    delete user_url(@user)
    assert_redirected_to users_url, "Admin should be redirected after destroying user"
    delete user_url(@admin2)
    assert_redirected_to users_url, "Admin should be redirected after destroying another admin"
    delete user_url(@admin)
    assert_redirected_to root_url, "Admin should be redirected to root after destroying self"
  end

  test "should only destroy self as non andmin" do
    delete user_url(@user)
    assert_response :unauthorized, "Non-logged-in user should not destroy self"
    delete user_url(@admin)
    assert_response :unauthorized, "Non-logged-in user should not destroy admin"

    login_user
    delete user_url(@admin)
    assert_response :unauthorized, "User should not destroy admin"
    delete user_url(@user2)
    assert_response :unauthorized, "User should not destroy another user"
    delete user_url(@user)
    assert_redirected_to root_url, "User should be redirected to root after destroying self"
  end

  test "should get forgot password" do
    get forgot_password_url
    assert_response :success, "Anyone should access forgot password page"
    login_user
    get forgot_password_url
    assert_response :success, "Logged-in user should access forgot password page"
    login_admin
    get forgot_password_url
    assert_response :success, "Admin should access forgot password page"
  end

  test "should generate forgot password code if email address exists" do
    assert_difference("ResetPasswordCode.count", 0, "No code should be generated for unknown email") do
      post forgot_password_url, params: { email_address: "doesnt@exist.lol" }
      assert_redirected_to forgot_password_url, "Should redirect after failed forgot password"
    end
    assert_difference("ResetPasswordCode.count", 1, "Should generate code for valid email") do
      post forgot_password_url, params: { email_address: @user.email_address }
      assert_redirected_to forgot_password_url, "Should redirect after generating code"
    end
    assert_difference("ResetPasswordCode.count", 0, "Should not generate duplicate code for same user") do
      post forgot_password_url, params: { email_address: @user.email_address }
      assert_redirected_to forgot_password_url, "Should redirect after duplicate request"
    end
  end

  test "should send forgot password email if email address exists" do
    assert_emails 0 do
      post forgot_password_url, params: { email_address: "doesnt@exist.lol" }
    end
    assert_emails 1 do
      post forgot_password_url, params: { email_address: @user.email_address }
    end
    assert_emails 1 do
      post forgot_password_url, params: { email_address: @user.email_address }
    end
  end

  test "should generate reset code only for self as non admin" do
    assert_difference("ResetPasswordCode.count", 0, "Non-logged-in user should not generate reset code") do
      put reset_password_request_url(@user)
      assert_response :unauthorized, "Should be unauthorized"
    end

    login_user
    assert_difference("ResetPasswordCode.count", 1, "User should generate reset code for self") do
      put reset_password_request_url(@user)
      assert_redirected_to edit_user_url(@user), "Should redirect after generating code"
    end
    assert_difference("ResetPasswordCode.count", 0, "User should not generate reset code for another user") do
      put reset_password_request_url(@user2)
      assert_response :unauthorized, "Should be unauthorized"
    end
  end

  test "should send reset code email only for self as non admin" do
    assert_emails 0 do
      put reset_password_request_url(@user)
    end

    login_user
    assert_emails 1 do
      put reset_password_request_url(@user)
    end
    assert_emails 0 do
      put reset_password_request_url(@user2)
    end
  end

  test "should generate reset codes for any user as admin" do
    login_admin
    assert_difference("ResetPasswordCode.count", 1, "Admin should generate reset code for self") do
      put reset_password_request_url(@admin)
      assert_redirected_to edit_user_url(@admin), "Should redirect after generating code"
    end
    assert_difference("ResetPasswordCode.count", 1, "Admin should generate reset code for another admin") do
      put reset_password_request_url(@admin2)
      assert_redirected_to edit_user_url(@admin2), "Should redirect after generating code"
    end
    assert_difference("ResetPasswordCode.count", 1, "Admin should generate reset code for regular user") do
      put reset_password_request_url(@user)
      assert_redirected_to edit_user_url(@user), "Should redirect after generating code"
    end
  end

  test "should send reset code emails for any user as admin" do
    login_admin
    assert_emails 1 do
      put reset_password_request_url(@admin)
    end
    assert_emails 1 do
      put reset_password_request_url(@admin2)
    end
    assert_emails 1 do
      put reset_password_request_url(@user)
    end
  end

  test "should cleanly regenerate reset codes" do
    assert_difference("ResetPasswordCode.count", 1, "Should generate code for user") do
      post forgot_password_url, params: { email_address: @user.email_address }
    end
    old_code = ResetPasswordCode.find_by(user: @user).code

    assert_difference("ResetPasswordCode.count", 0, "Should replace code, not create new one") do
      post forgot_password_url, params: { email_address: @user.email_address }
      assert_not_equal old_code, ResetPasswordCode.find_by(user: @user).code, "Reset code should change"
    end
    old_code = ResetPasswordCode.find_by(user: @user).code

    login_user
    assert_difference("ResetPasswordCode.count", 0, "Should replace code for self, not create new one") do
      put reset_password_request_url(@user)
      assert_not_equal old_code, ResetPasswordCode.find_by(user: @user).code, "Reset code should change"
    end
  end

  test "should get reset password" do
    ResetPasswordCode.new(user: @user, code: SecureRandom.alphanumeric(32)).save!
    get reset_password_url(ResetPasswordCode.find_by(user: @user).code)
    assert_response :success, "Should access reset password form with valid code"
  end

  test "should submit reset password" do
    code = SecureRandom.alphanumeric(32)
    ResetPasswordCode.new(user: @user, code: code).save!
    assert_difference("ResetPasswordCode.count", -1, "Reset code should be deleted after successful reset") do
      patch reset_password_url(code), params: { user: { username: "newusername", password: "newpassword", password_confirmation: "newpassword" } }
    end
    post login_url, params: { username: "newusername", password: "newpassword" }
    assert_redirected_to backend_root_url, "Should log in with new credentials"
  end

  test "should handle invalid reset keys" do
    expired_code = SecureRandom.alphanumeric(32)
    ResetPasswordCode.new(
        user: @user,
        code: expired_code,
        is_activation_code: true, created_at: ENV.fetch("ACCOUNT_ACTIVATION_CODE_VALIDITY_DAYS", 14).to_i.days.ago - 1.day
      ).save!

    assert_difference("ResetPasswordCode.count", 0, "No code should be deleted for random invalid code") do
      get reset_password_url(SecureRandom.alphanumeric(32))
      assert_redirected_to forgot_password_url, "Should redirect for invalid code"
    end

    assert_difference("ResetPasswordCode.count", 0, "No code should be deleted for random invalid code on patch") do
      patch reset_password_url(SecureRandom.alphanumeric(32))
      assert_redirected_to forgot_password_url, "Should redirect for invalid code"
    end

    assert_difference("ResetPasswordCode.count", -1, "Expired code should be deleted after use") do
      patch reset_password_url(expired_code), params: { user: { username: "newusername" } }
      assert_redirected_to forgot_password_url, "Should redirect for expired code"
      @user.reload
      assert_not_equal "newusername", @user.username, "Username should not change on invalid/expired reset"
    end
  end
end
