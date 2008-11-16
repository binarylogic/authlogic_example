ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users", :collection => {:forgot_password => :get, :request_password_reset => :post, :edit_password => :get, :update_password => :put}
  map.resources :users
  map.resource :user_session
  map.default "/", :controller => "user_sessions", :action => "new"
end
