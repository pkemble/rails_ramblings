require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:frick)
	end
	 
	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post_via_redirect users_path, user: { username: "testes testes",
																						email: "test@test.com",
																						password:	"paswrd",
																						password_confirmation: "paswrd" }
		end
		assert_template 'users/show'
		assert is_logged_in?
	end

	test "login logout" do
		get login_path
		post login_path, session: { email: @user.email, password: 'password' }
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
		delete logout_path
		assert_not is_logged_in?
		assert_redirected_to root_url
		delete logout_path #simulate 2nd browser window
		follow_redirect!
		assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
	end
	
	test "login with remembering" do
		log_in_as(@user, remember_me: '1')
		assert_not_nil cookies['remember_token']
	end
	
	test "login without remembering" do
		log_in_as(@user, remember_me: '0')
		assert_nil cookies['remember_token']
	end
	
end
