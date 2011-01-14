class BillingIntegration::Paypoint < BillingIntegration
  preference :merchant, :string, :default=>"" #Set to your merchant account
  preference :password, :string, :default=>''
  preference :template, :string, :default=>'' #Set if you want anything but the standard template shown by paypoint
  preference :currency_code, :string, :default=>"GBP"
  preference :mail_customer, :boolean, :default=>true
  preference :mail_attach_customer, :boolean, :default=>true
  preference :mail_attach_merchant, :boolean, :default=>true
  preference :req_cv2, :boolean, :default=>true
  preference :background_color, :default=>''
  preference :branding, :default=>''
  preference :font_color, :default=>''
  preference :font_size, :default=>''
  preference :font_face, :default=>''
  preference :background_image, :default=>''
  preference :mail_subject, :default=>''


end
