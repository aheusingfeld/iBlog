Iblog::Application.routes.draw do

  resources :blogs do
    resources :entries do
      resources :comments
    end
  end

  resources :comments
  post '/comments' => 'comments#create', :as => 'create_comment'
  put '/comments/:id' => 'comments#update', :as => 'update_comment'

  resources :entries do
    resources :comments
  end

  get '/index-all(.:format)' => 'entries#full', :as => 'all_entries'

  root :to => 'blogs#index'

  scope '/entries' do
    get '/tags/:tag(.:format)' => 'entries#by_tag', :as => 'tag'
    get '/home/:author(.:format)' => 'entries#user_home', :as => 'blog_entries_by_author'
    get '/home' => 'entries#home', :as => 'home'
  end

  scope '/admin' do
    get '/' => 'admin#index'
    get '/log' => 'admin#log'
    get '/env' => 'admin#env'
  end

  get '/blogs/by/:owner(.:format)' => 'blogs#index', :as => 'blogs_by_owner'
end
