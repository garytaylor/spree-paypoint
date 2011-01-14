require File.join(File.dirname(__FILE__),'..','spec_helper')
describe CheckoutController do
  attr_accessor :order, :logged_in_user
  include Devise::TestHelpers
  render_views
  before do
    self.logged_in_user=mock_model(Abacus::User, :anonymous? => false).as_null_object
    self.order= mock_model(Order, :number=>"R848780870", :email=>'test_user_1@rubysystems.co.uk', :checkout_allowed? => true, :completed? => false, :update_attributes => true, :payment? => false, :user=>logged_in_user, :payment_method=>mock_payment_method, :total=>50.0,:bill_address=>mock_bill_address, :ship_address=>mock_ship_address, :line_items=>mock_line_items).as_null_object
    controller.stub :check_authorization
    controller.stub :current_order do
      order
    end
  end

  it "Should draw the correct form for passing to paypoint" do
    sign_in :user,logged_in_user
    logged_in_user.stub!(:has_role?).and_return true
    get :paypoint_payment, {:order_id=>"R848780870", :payment_method_id=>"957960602"}

    field(:trans_id).should eql "R848780870"
    field(:merchant).should eql "my_test_merchant"
    field(:template).should eql "test_template_address"
    field(:amount).should eql "50.0"
    field(:customer).should eql "First Last"
    field(:currency).should eql "GBP"
    field(:callback).should =~/paypoint_notify/
    options=field(:options).split(",")
    options.should =~ [
        'dups=false',
        'show_back=submit',
        'cb_flds=return_url:payment_method_id',
        'md_flds=trans_id:amount',
        'cb_post=true',
        'ssl_cb=false',
        'mail_customer=true',
        'mail_attach_merchant=true',
        'mail_attach_customer=true',
        'req_cv2=true',
        'test_status=true',
        'return_url=http%3A%2F%2Ftest.host%2Fshop%2Forders%2F1013',
        'payment_method_id=957960602'
    ]
    field(:bill_name).should eql "First Last"
    field(:bill_addr_1).should eql "Bill Address 1"
    field(:bill_addr_2).should eql "Bill Address 2"
    field(:bill_state).should eql "Bill State"
    field(:bill_post_code).should eql "DE110BH"
    field(:bill_country).should eql "Bill Country"
    field(:bill_tel).should eql "07777 999999"
    field(:bill_city).should eql "Bill City"
    field(:bill_email).should eql "test_user_1@rubysystems.co.uk"
    field(:ship_name).should eql "First Last"
    field(:ship_addr_1).should eql "Ship Address 1"
    field(:ship_addr_2).should eql "Ship Address 2"
    field(:ship_post_code).should eql "DE110BH"
    field(:ship_tel).should eql "07777 999999"
    field(:ship_city).should eql "Ship City"
    field(:ship_email).should eql "test_user_1@rubysystems.co.uk"
    field(:ship_country).should eql "Ship Country"
    field(:ship_state).should eql "Ship State"
    field(:backcallback).should =~/\/shop\/checkout/
    field(:mail_subject).should eql "My Test Subject"
    field(:bgcolor).should eql "lightblue"
    field(:font_color).should eql "red"
    field(:font_face).should eql "Arial"
    field(:font_size).should eql "12"
    field(:background).should eql "/my_image"
    field(:branding).should eql "Test Branding"
    field(:order).split(';').should =~ ['prod=Product 1,item_amount=10.0x2','prod=Product 2,item_amount=3.0x1']
    field(:digest).should eql "a6e3a19ff82982f2a768ba730ee83260"
    
    b=1
  end
  it "Should handle a nil state name and get state from state_name field instead" do
    self.order= mock_model(Order, :number=>"R848780870", :email=>'test_user_1@rubysystems.co.uk', :checkout_allowed? => true, :completed? => false, :update_attributes => true, :payment? => false, :user=>logged_in_user, :payment_method=>mock_payment_method, :total=>50.0,:bill_address=>mock_bill_address, :ship_address=>mock_ship_address_with_no_state, :line_items=>mock_line_items).as_null_object 

    sign_in :user,logged_in_user
    logged_in_user.stub!(:has_role?).and_return true
    get :paypoint_payment, {:order_id=>"R848780870", :payment_method_id=>"957960602"}
    field(:ship_state).should eql "Derbyshire"

  end
  def mock_order
    @_mock_order||=mock_model(Order,:number=>"R848780870")
  end
  def mock_payment_method
    @_mock_payment_method||=mock_model(PaymentMethod,:id=>"957960602",
      :preferred_merchant=>"my_test_merchant",
      :preferred_currency_code=>'GBP',
      :preferred_template=>'test_template_address',
      :preferred_mail_customer=>true,
      :preferred_mail_attach_customer=>true,
      :preferred_mail_attach_merchant=>true,
      :preferred_req_cv2=>true,
      :preferred_background_color=>'lightblue',
      :preferred_branding=>'Test Branding',
      :preferred_font_color=>'red',
      :preferred_font_size=>'12',
      :preferred_font_face=>'Arial',
      :preferred_background_image=>'/my_image',
      :preferred_mail_subject=>'My Test Subject',
      :preferred_password=>'password'

    )
  end
  def mock_bill_address
    @_mock_bill_address||=mock_model(Address,{
        :firstname=>'First',
        :lastname=>'Last',
        :address1=>'Bill Address 1',
        :address2=>'Bill Address 2',
        :zipcode=>'DE110BH',
        :state=>mock_bill_state,
        :country=>mock_bill_country,
        :city=>'Bill City',
        :phone=>'07777 999999'
    })
  end
  def mock_ship_address
    @_mock_ship_address||=mock_model(Address,{
        :firstname=>'First',
        :lastname=>'Last',
        :address1=>'Ship Address 1',
        :address2=>'Ship Address 2',
        :zipcode=>'DE110BH',
        :state=>mock_ship_state,
        :country=>mock_ship_country,
        :city=>'Ship City',
        :phone=>'07777 999999'
    })
  end
  def mock_ship_address_with_no_state
    @_mock_ship_address_with_no_state||=mock_model(Address,{
        :firstname=>'First',
        :lastname=>'Last',
        :address1=>'Ship Address 1',
        :address2=>'Ship Address 2',
        :zipcode=>'DE110BH',
        :state=>nil,
        :country=>mock_ship_country,
        :city=>'Ship City',
        :phone=>'07777 999999',
        :state_name=>'Derbyshire'
    })
  end
  def mock_bill_state
    @_bill_state||=mock_model(State,:name=>"Bill State")
  end
  def mock_bill_country
    @_bill_country||=mock_model(Country,:name=>'Bill Country')
  end
  def mock_ship_state
    @_ship_state||=mock_model(State,:name=>"Ship State")
  end
  def mock_ship_country
    @_ship_country||=mock_model(Country,:name=>'Ship Country')
  end
  def mock_line_items
    @_line_items||=[
      mock_model(LineItem,:quantity=>2,:product=>mock_model(Product,:price=>10.0,:name=>'Product 1')),
      mock_model(LineItem,:quantity=>1,:product=>mock_model(Product,:price=>3.0,:name=>'Product 2'))

    ]
  end
  def field(f)
    document.css("input[@name=#{f}]").first[:value]

  end
  def document
    @document||=Nokogiri::HTML(response.body)
  end

end
