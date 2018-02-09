require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid user can't sign up" do
    get signup_path
    assert_select 'form[action="/signup"]', true 
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                        email: "",
                                        password: "",
                                        password_confirmation: "" } }
    end
    assert_template 'users/new'
    assert_select '#error_explanation > ul > li:nth-child(1)', "Name can't be blank"
    assert_select '#error_explanation > ul > li:nth-child(2)', "Email can't be blank"
    assert_select '#error_explanation > ul > li:nth-child(3)', "Email is invalid"
    assert_select '#error_explanation > ul > li:nth-child(4)', "Password can't be blank"
    assert_select '#error_explanation > ul > li:nth-child(5)', "Password can't be blank"
    assert_select '#error_explanation > ul > li:nth-child(6)', "Password is too short (minimum is 6 characters)"
  end

  test "valid user can sign up" do
    get signup_path
    assert_select 'form[action="/signup"]', true
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "Test Name",
                                          email: "test@test.com",
                                          password: "aaaaaa",
                                          password_confirmation: "aaaaaa" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'body > div > div.alert.alert-success', "Welcome to the Sample App!"
  end
end
