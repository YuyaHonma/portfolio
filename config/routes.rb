Rails.application.routes.draw do
  # 飼い主用
  # URL /public/owners/sign_in ...
  devise_for :owners, skip: [:passwords], controllers: {
    registrations: "public/owner/registrations",
    sessions: 'public/owner/sessions'
  }
  
  devise_scope :owner do
    # ゲストログインのルート
    post 'owner_guest_login', to: 'public/owner/sessions#guest_login'
  end

  # トレーナー用
  # URL /admin/sign_in ...
  devise_for :trainers, controllers: {
    registrations: "public/trainer/registrations",
    sessions: 'public/trainer/sessions'
  }
    
  devise_scope :trainer do
    post 'trainer_guest_login', to: 'public/trainer/sessions#guest_login'
  end
  
  
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  
  scope module: :public do
    namespace :owner do
    #トップページ
    root to: "homes#top", as: :owner_root
    #アバウトページ
    get "homes/about"=>"homes#about"
    #飼い主
    get 'owners/my_page'=>'owners#show', as: 'my_page'
    # get '/owners/:id'=>'owners#show'
    get '/owners/information/edit'=>'owners#edit', as: 'edit_information'
    patch '/owners/information'=>'owners#update', as: 'update_information'
    get '/owners/unsubscribe' => 'owners#unsubscribe', as: 'unsubscribe'
    patch '/owners/withdraw' => 'owners#withdraw', as: 'withdraw'
    #ペット
    resources :pets, only: [:new, :create, :show, :edit, :update, :destroy]
    #投稿
    resources :posts do
    resource :favorites, only: [:create, :destroy]
    end
    #トレーナー
    resources :trainers, only: [:index, :show]
    #カテゴリ
    resources :categorys, only: [:index, :show]
    # カテゴリ検索
    get 'owner/owners/:id/search' => 'searches#search_category'
    
    resources :trainers, only: [:index, :show]
    end
  end
  
    scope module: :public do
      namespace :trainer do
    # トップページ
    root to: "homes#top", as: :trainer_root
    # トレーナー
    resources :trainers, only: [:index, :show, :edit, :update]
    # カテゴリー
    resources :categorys, only: [:index, :create, :edit, :update, :destroy]
    # 投稿
    resources :posts, only: [:index, :show] do
    resource :favorites, only: [:create, :destroy]
    resources :advices, only: [:create, :destroy]
      end
    end
  end
  
   namespace :admin do
     
     root to: "homes#top"
     
     resources :owners, only: [:show, :edit, :update]
     
     resources :trainers, only: [:show, :edit, :update]
   end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
