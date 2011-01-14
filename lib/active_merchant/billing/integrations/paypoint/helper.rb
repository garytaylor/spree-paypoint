module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paypoint
        class Helper < ActiveMerchant::Billing::Integrations::Helper
         CANADIAN_PROVINCES = {  'AB' => 'Alberta',
                                 'BC' => 'British Columbia',
                                 'MB' => 'Manitoba',
                                 'NB' => 'New Brunswick',
                                 'NL' => 'Newfoundland',
                                 'NS' => 'Nova Scotia',
                                 'NU' => 'Nunavut',
                                 'NT' => 'Northwest Territories',
                                 'ON' => 'Ontario',
                                 'PE' => 'Prince Edward Island',
                                 'QC' => 'Quebec',
                                 'SK' => 'Saskatchewan',
                                 'YT' => 'Yukon'
                               } 

          def initialize(order, account, options = {})
            super
          end

          mapping :amount, 'amount'
         mapping :order, 'trans_id'
          mapping :account, 'merchant'
          mapping :currency, 'currency'
         mapping :notify_url, 'callback'
         mapping :template, 'template'
         mapping :customer, 'customer'
         mapping :options, 'options'
         mapping :billing_name, 'bill_name'
         mapping :billing_address,  :city    => 'bill_city',
                                     :address1 => 'bill_addr_1',
                                     :address2 => 'bill_addr_2',
                                     :state   => 'bill_state',
                                     :zip     => 'bill_post_code',
                                     :country => 'bill_country'
         mapping :billing_tel, 'bill_tel'
         mapping :billing_email, 'bill_email'
         mapping :shipping_name, 'ship_name'
         mapping :shipping_address,  :city    => 'ship_city',
                                     :address1 => 'ship_addr_1',
                                     :address2 => 'ship_addr_2',
                                     :state   => 'ship_state',
                                     :zip     => 'ship_post_code',
                                     :country => 'ship_country'
         mapping :shipping_tel, 'ship_tel'
         mapping :shipping_email, 'ship_email'


          mapping :cancel_return_url, 'backcallback'
          mapping :presentation_options,  :background_color =>  'bgcolor',
                                          :background_image =>  'background',
                                          :branding         =>  'branding',
                                          :font_color       =>  'font_color',
                                          :font_size        =>  'font_size',
                                          :font_face        =>  'font_face',
                                          :template         =>  'template'
          mapping :mail_subject, 'mail_subject'
          mapping :mail_message, 'mail_message'
          mapping :order_lines, 'order'
          mapping :digest, 'digest'
          mapping :callback_params, 'callback_params'

        end
      end
    end
  end
end


