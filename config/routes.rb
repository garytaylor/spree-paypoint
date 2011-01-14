Rails.application.routes.draw do |map|
  map.resources :orders do |order|
    order.resource :checkout, :controller=>"checkout", :member => {:paypoint_checkout => :any, :paypoint_payment => :any, :paypoint_confirm => :any, :paypoint_finish => :any}
  end

  map.paypoint_notify "/paypoint_notify", :controller => 'spree/paypoint_callbacks', :action => :notify

  map.namespace :admin do |admin|
    admin.resources :orders do |order|
      order.resources :paypoint_payments, :member => {:capture => :get, :refund => :any}, :has_many => [:txns]
    end
  end
end
