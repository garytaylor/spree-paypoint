module Spree
  class PaypointCallbacksController < ::ActionController::Base
    #Called by paypoint when the payment is paid, but all security measures must be taken as this could easily be spoofed
    def notify
      payment_method=PaymentMethod.find_by_id(params[:payment_method_id])

      n=ActiveMerchant::Billing::Integrations::Paypoint.notification(request.query_string,:digest=>request.url.gsub(/hash=\w*/,'').gsub(/^https*:\/\/.*?/,'/') + payment_method.preferred_password)
      order=Order.find_by_id(n.item_id)
      Rails.logger.warn "Warning:: Attempt at spoofind the paypoint callback from #{request.ip}" unless n.from_paypoint?
      if n.from_paypoint? and n.completed? and n.amount==order.amount
        order.status='completed'
      else
        Rails.logger.warn "Warning:: Order #{n.item_id} was not authorised"
      end
    end

  end
end