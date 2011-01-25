module Spree
  class PaypointCallbacksController < ::ActionController::Base
    protect_from_forgery :except=>:notify
    #Called by paypoint when the payment is paid, but all security measures must be taken as this could easily be spoofed
    def notify
      payment_method=PaymentMethod.find_by_id(params[:payment_method_id])

      n=ActiveMerchant::Billing::Integrations::Paypoint.notification(request.query_string,:digest=>request.fullpath.gsub(/hash=\w*/,'') + payment_method.preferred_password)
      @order=Order.find_by_number(n.item_id)
      if @order.nil?
        Rails.logger.error "Error: A payment notification arrived for order #{n.item_id} using the paypoint integration.  This order did not exist"
      else
        Rails.logger.warn "Warning:: Attempt at spoofind the paypoint callback from #{request.ip}" unless n.from_paypoint?
        if n.from_paypoint? and n.complete? and n.amount.to_f==@order.total.to_f
          p=@order.payment
          p.complete
          @order.state='complete'
          @order.finalize!
        else
          Rails.logger.warn "Warning:: Order #{n.item_id} was not authorised - reason #{n.message}"
          p=@order.payment
          p.fail
          p.save
        end
        
      end
    end

  end
end