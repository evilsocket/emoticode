EmoticodeRails::Application.routes.draw do
  root 'home#index' 

  controller :sessions do
    get    'sign_in'  => :new,     as: :sign_in
    post   'sign_in'  => :create
    get    'sign_up'  => :new,     as: :sign_up
    post   'sign_up'  => :create
    delete 'sign_out' => :destroy, as: :sign_out
  end

  get '/auth/:provider/callback' => 'sessions#facebook_connect'

  controller :favorite do
    post 'fav/:id'   => :make,    as: :favorite,   constraints: { id: Patterns::ID_PATTERN }
    post 'unfav/:id' => :destroy, as: :unfavorite, constraints: { id: Patterns::ID_PATTERN }
  end

  controller :page do 
    get ':page.html' => :show, as: :page_show
  end
  
  controller :language do
    get ':name/',    to: :archive, as: :language_archive, constraints: { name: Patterns::ROUTE_PATTERN }
  end

  controller :source do
    get 'source/new'                       => :new,   as: :source_new
    get ':language_name/:source_name.html' => :show,  as: :source_with_language, constraints: { language_name: Patterns::ROUTE_PATTERN, source_name: Patterns::ROUTE_PATTERN }
    get ':language_name/:source_name.txt'  => :raw,   as: :raw_with_language,    constraints: { language_name: Patterns::ROUTE_PATTERN, source_name: Patterns::ROUTE_PATTERN }
    get ':language_name/:source_name.js'   => :embed, as: :embed_with_language,  constraints: { language_name: Patterns::ROUTE_PATTERN, source_name: Patterns::ROUTE_PATTERN }
  end

  controller :profile do
    get 'profile/:username' => :show, as: :user_profile, constraints: { username: Patterns::ROUTE_PATTERN }
  end

  controller :search do
    # TODO
    get 'search/:what' => :search, as: :search, constraints: { what: Patterns::ROUTE_PATTERN }
  end

  resource :comments
end
