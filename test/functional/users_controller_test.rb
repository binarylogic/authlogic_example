require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => { :login => "ben", :password => "benrocks", :password_confirmation => "benrocks", :email => "myemail@email.com" }
    end
    
    assert_redirected_to account_path
  end
  
  test "should show user" do
    set_session_for(users(:ben))
    get :show
    assert_response :success
  end

  test "should get edit" do
    set_session_for(users(:ben))
    get :edit, :id => users(:ben).id
    assert_response :success
  end

  test "should update user" do
    set_session_for(users(:ben))
    put :update, :id => users(:ben).id, :user => { }
    assert_redirected_to account_path
  end
end
