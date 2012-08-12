Dummy::Application.routes.draw do
  resources :products, except: :destroy, path_names: { new: :make } do
    get :commit, on: :collection
    has_wizardry
  end
end
