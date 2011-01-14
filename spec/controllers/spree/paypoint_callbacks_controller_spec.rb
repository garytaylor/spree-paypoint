require File.join(File.dirname(__FILE__),'..','..','spec_helper')

def test_params
  {"test_status"      =>"true",
          "trans_id"         =>"R848780870",
          "code"             =>"A",
          "hash"             =>"e1755be1fbb2e5828ea5bfa6cef58666",
          "method"           =>"post",
          "amount"           =>"10.00",
          "backcallback"     =>"http://dev.rubysystems.co.uk/shop/checkout",
          "valid"            =>"true",
          "ip"               =>"86.17.185.190",
          "auth_code"        =>"9999",
          "cv2avs"           =>"DATA NOT CHECKED",
          "return_url"       =>"dev.rubysystems.co.uk/shop/orders/R417803157",
          "payment_method_id"=>"957960602"

  }

end

describe Spree::PaypointCallbacksController do
  render_views
  it "Should handle a positive response from paypoint" do
    PaymentMethod.stub! :find_by_id do
      mock_model PaymentMethod, :preferred_password=>'my secret password'
    end
    Order.stub! :find_by_number do
      @_order=mock_model Order, :amount=>10.0
    end
    ActiveMerchant::Billing::Integrations::Paypoint::Notification.public_instance_methods.should include('hash')
    params = test_params
    @_order.should_receive(:status=).with('completed')

    get :notify, params
    response.body.should =~ /dev.rubysystems.co.uk\/shop\/orders\/R417803157/
    ActiveMerchant::Billing::Integrations::Paypoint::Notification.public_instance_methods.should include('hash')

  end

  it "Should behave the same when called twice" do
    PaymentMethod.stub! :find_by_id do
      mock_model PaymentMethod, :preferred_password=>'my secret password'
    end
    Order.stub! :find_by_number do
      @_order=mock_model Order, :amount=>10.0
    end
    ActiveMerchant::Billing::Integrations::Paypoint::Notification.public_instance_methods.should include('hash')
    params = test_params
    @_order.should_receive(:status=).with('completed')

    get :notify, params
    response.body.should =~ /dev.rubysystems.co.uk\/shop\/orders\/R417803157/
    ActiveMerchant::Billing::Integrations::Paypoint::Notification.public_instance_methods.should include('hash')

    get :notify, params
    response.body.should =~ /dev.rubysystems.co.uk\/shop\/orders\/R417803157/
    ActiveMerchant::Billing::Integrations::Paypoint::Notification.public_instance_methods.should include('hash')
    
  end

end