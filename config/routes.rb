Rails.application.routes.draw do
  root "documents#new"

  resources :documents, only: [:new, :create, :show] do
    post :analyze, on: :member
    get  :export,  on: :member
    post :salesforce_export, on: :member
  end

  resources :findings, only: [:update]
end
