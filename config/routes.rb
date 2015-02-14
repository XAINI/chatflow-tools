Rails.application.routes.draw do
  root 'produce#index'

  resources :produce do
    collection do
      post :convert
    end
  end

end
