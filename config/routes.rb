ActionController::Routing::Routes.draw do |map|
  map.resources :blogs do |blog|
    blog.resources :entries
  end

#  map.resources :entries
  map.root :controller => 'blogs'   
  map.with_options :controller => 'entries' do |entries|
    entries.tag '/tags/:tag.:format', :action => 'index'
    entries.user_home '/home/:author.:format', :action => 'user_home'
    entries.home '/home', :action => 'home'
  end
  map.with_options :controller => 'admin' do |admin|
    admin.index '/admin',     :action => 'index'
    admin.log   '/admin/log', :action => 'log'
    admin.env   '/admin/env', :action => 'env'
  end
end
