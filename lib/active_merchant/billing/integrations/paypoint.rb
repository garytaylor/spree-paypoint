module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paypoint
        autoload :Return, 'active_merchant/billing/integrations/paypoint/return.rb'
        autoload :Helper, 'active_merchant/billing/integrations/paypoint/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/paypoint/notification.rb'


        # Overwrite this if you want to change the Paypal production url
        mattr_accessor :production_url
        self.production_url = 'https://www.secpay.com/java-bin/ValCard'

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
          when :production
            self.production_url
          when :test
            self.production_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post,options={})
          ::ActiveMerchant::Billing::Integrations::Paypoint::Notification.new(post,options)
        end

        def self.return(query_string, options = {})
          Return.new(query_string)
        end
      end
    end
  end
end
