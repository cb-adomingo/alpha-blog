require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
    test "get new user form and create user" do
        get signup_path
        assert_template 'users/new'
        assert_difference 'User.count', 1 do
            post users_path, params: { user: {username: "john", email: "john@example.com", password: "password"} }
            follow_redirect!
        end
        assert_template 'users/show'
        assert_match "Welcome to Alpha Blog", response.body
    end

    test "empty form submission results in failure" do
        get signup_path
        assert_template 'users/new'
        assert_no_difference 'User.count' do
            post users_path, params: { user: {username: " ", email: " ", password: ""} }
        end
        assert_template 'users/new'
        assert_select 'div.alert-danger'
        assert_match '5 errors occurred', response.body
    end
end
