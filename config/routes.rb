Rails.application.routes.draw do
  root 'home#index'
  post 'crawl' => 'home#crawl'
  get  'show'  => 'home#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
