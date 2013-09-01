EmoticodeRails::Application.routes.draw do
  root 'home#index' 

  controller :sitemaps do
    get 'sitemap_index'          => :index,     as: :sitemap_index
    get 'sitemap_snippets-:page' => :snippets,  as: :sitemap_snippets, constraints: { page: Patterns::ID_PATTERN }
    get 'sitemap_languages'      => :languages, as: :sitemap_languages
  end

  controller :sessions do
    get    'sign_in'  => :new,     as: :sign_in
    post   'sign_in'  => :create
    delete 'sign_out' => :destroy, as: :sign_out
  end

  controller :user do
    get  'sign_up'        => :new,     as: :sign_up
    post 'sign_up'        => :create
    get  'confirm/:token' => :confirm, as: :confirm, constraints: { token: Patterns::CONFIRMATION_TOKEN_PATTERN } 
  end

  get '/auth/:provider/callback' => 'sessions#create'

  controller :favorite do
    post 'fav/:id'   => :make,    as: :favorite,   constraints: { id: Patterns::ID_PATTERN }
    post 'unfav/:id' => :destroy, as: :unfavorite, constraints: { id: Patterns::ID_PATTERN }
  end

  controller :profile do
    get   'profile/edit'           => :edit, as: :user_settings
    patch 'profile/update'         => :update
    get   'profile/:username'      => :show, as: :user_profile, constraints: { username: Patterns::ROUTE_PATTERN }
  end

  controller :search do
    get 'search(/:what)' => :search, as: :search
  end

  resource :comments
  resource :votes

  resource :passwords, :only => [:new, :create]
  controller :passwords do
    get  'recovery/:token' => :edit, as: :recovery, constraints: { token: Patterns::CONFIRMATION_TOKEN_PATTERN } 
    post 'recovery/:token' => :update, constraints: { token: Patterns::CONFIRMATION_TOKEN_PATTERN } 
  end

  controller :feeds do
    get 'feed'                   => :feed,     as: :feed
    get 'feed/:language'         => :language, as: :language_feed, constraints: { language: Patterns::ROUTE_PATTERN }
    get 'profile/:username/feed' => :user,     as: :user_feed, constraints: { username: Patterns::ROUTE_PATTERN }
    get 'randomfeed'             => :random,   as: :random_feed
  end

  controller :page do 
    get ':page.html' => :show, as: :page_show
  end
  
  controller :language do
    get ':name/',    to: :archive, as: :language_archive, constraints: { name: Patterns::ROUTE_PATTERN }
  end

  controller :source do
    get   'source/new'         => :new,     as: :source_new
    post  'source/create'      => :create,  as: :source_create
    get   'source/edit/:id'    => :edit,    as: :source_edit,   constraints: { id: Patterns::ID_PATTERN }
    get   'source/destroy/:id' => :destroy, as: :source_delete, constraints: { id: Patterns::ID_PATTERN }
    patch 'source/update/:id'  => :update,  as: :source_update, constraints: { id: Patterns::ID_PATTERN }

    get ':language_name/:source_name.html' => :show,    as: :source_with_language, constraints: { language_name: Patterns::ROUTE_PATTERN, source_name: Patterns::ROUTE_PATTERN }
    get ':language_name/:source_name.txt'  => :raw,     as: :raw_with_language,    constraints: { language_name: Patterns::ROUTE_PATTERN, source_name: Patterns::ROUTE_PATTERN }
    get ':language_name/:source_name.js'   => :embed,   as: :embed_with_language,  constraints: { language_name: Patterns::ROUTE_PATTERN, source_name: Patterns::ROUTE_PATTERN }
  end
  
end
