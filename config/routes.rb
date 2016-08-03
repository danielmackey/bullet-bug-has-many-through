Rails.application.routes.draw do
  resources :groups, only: [:index, :show] do
    resources :memberships, only: [:show]
  end
  root to: 'groups#index'
end
