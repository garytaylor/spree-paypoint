require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paypoint
        # Parser and handler for incoming callback from paypoint.
        # Here is how it would be used in a controller
        #
        # def notify
        #   n=ActiveMerchant::Billing::Integrations::Paypoint.notification(request.raw_post,:digest=>'my secret digest')
        #   order=Order.find_by_id(n.item_id)
        #   if n.from_paypoint?
        #     if n.completed? and n.amount==order.amount
        #       order.status='Paid'
        #     end
        #   end
        # end
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          include PostsData

          #Calculate hash
          def from_paypoint?
            expected_hash=Digest::MD5.hexdigest(@options[:digest])
            hash.nil? or expected_hash == hash
            
          end
          def item_id
            params['trans_id']
          end
          def hash
            params['hash']
          end
          # Was the transaction complete?
          def complete?
            status == "Completed"
          end

          # When was this payment received by the client. 
          # sometimes it can happen that we get the notification much later. 
          # One possible scenario is that our web application was down. In this case paypal tries several 
          # times an hour to inform us about the notification
          def received_at
            Time.now
          end

          #list of all possible codes along with their meanings
          #Definition
          #A Transaction authorised by bank. auth_code available as bank reference
          #N Transaction not authorised. Failure message text available to merchant
          #C Communication problem. Trying again later may well work
          #F The PayPoint.net system has detected a fraud condition and rejected the transaction. The message field will contain more details.
          #P:A Pre-bank checks. Amount not supplied or invalid
          #P:X Pre-bank checks. Not all mandatory parameters supplied
          #P:P Pre-bank checks. Same payment presented twice
          #P:S Pre-bank checks. Start date invalid
          #P:E Pre-bank checks. Expiry date invalid
          #P:I Pre-bank checks. Issue number invalid
          #P:C Pre-bank checks. Card number fails LUHN check (the card number is wrong)
          #P:T Pre-bank checks. Card type invalid - i.e. does not match card number prefix
          #P:N Pre-bank checks. Customer name not supplied
          #P:M Pre-bank checks. Merchant does not exist or not registered yet
          #P:B Pre-bank checks. Merchant account for card type does not exist
          #P:D Pre-bank checks. Merchant account for this currency does not exist
          #P:V Pre-bank checks. CV2 security code mandatory and not supplied / invalid
          #P:R Pre-bank checks. Transaction timed out awaiting a virtual circuit. Merchant may not have enough virtual circuits for the volume of business.
          #P:# Pre-bank checks. No MD5 hash / token key set up against account

          def status
            params['code']
          end

          # Id of this transaction (same as the order number I think)
          def transaction_id
            params['trans_id']
          end

          # the money amount we received in X.2 decimal.
          def amount
            params['amount']
          end

          # Was this a test transaction?
          def test?
            params['test_status'] =~ /true:false/
          end

          def currency
            params['currency'] || 'GBP'
          end

          def card_type
            params['card_type']
          end

          #This is true or false and indicates the acceptance or not of the card details
          def valid?
            params['valid']=='true' ? true : false
          end
          #This is the authorisation code obtained from the bank for this transaction.
          #This is only returned if valid=true. For a transaction sent with the optional parameter “test_status=true”
          #the auth_code will always be 9999.
          def auth_code
            params['auth_code']
          end
          #The Apacs approved text that is supplied as a result of the CV2 and AVS anti-Fraud checks.
          #There are five core values defined, these are:
          #ALL MATCH
          #SECURITY CODE MATCH ONLY
          #ADDRESS MATCH ONLY
          #NO DATA MATCHES
          #DATA NOT CHECKED
          #All the data provided matched that which the card issuer had on record.
          #Only the security code matched Only the address matched None of the data matched
          #The cv2avs system is unavailable or not supported by this card issuer.
          #With these core codes an address is only understood to match if and only if both the address
          #and the postcode match at the same time. This is a little strict for some people so the following codes
          # have been introduced too:
          #PARTIAL ADDRESS MATCH / POSTCODE	The postcode matched but the address did not.
          #PARTIAL ADDRESS MATCH / ADDRESS	The address matched but the postcode did not.
          #SECURITY CODE MATCH / POSTCODE	The security code and postcodes matched but the address did not.
          #SECURITY CODE MATCH / ADDRESS	The security code and address matched but the postcode did not.
          #Codes are only supplied when CV2 and/or Billing Address data is supplied.
          #It is in your interests to supply this data to us.
          def cv2avs
            params['cv2avs']
          end

          #This parameter is only returned when a transaction is declined and code=N.
          #It is a failure message sent from the bank and should not be displayed to the cardholder.
          def message
            params['message']
          end

          #This parameter is only returned when a transaction is declined and code=N.
          #This is the bank's failure code for your information only, do not show it to the customer.
          def resp_code
            params['resp_code']
          end
          
        end
      end
    end
  end
end
