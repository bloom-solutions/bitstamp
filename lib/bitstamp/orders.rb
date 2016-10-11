module Bitstamp
  class Orders < Bitstamp::Collection
    def all(options = {}, currency_pair='btcusd')
      Bitstamp::Helper.parse_objects! Bitstamp::Net::post("/open_orders/#{currency_pair}").to_str, self.model
    end

    def create(options = {}, currency_pair='btcusd')
      path = "/#{currency_pair}" + (options[:type] == Bitstamp::Order::SELL ? "/sell" : "/buy")
      Bitstamp::Helper.parse_object! Bitstamp::Net::post(path, options).to_str, self.model
    end

    def sell(options = {})
      options.merge!({type: Bitstamp::Order::SELL})
      self.create options
    end

    def buy(options = {})
      options.merge!({type: Bitstamp::Order::BUY})
      self.create options
    end

    def find(order_id)
      Bitstamp::Helper.parse_objects! Bitstamp::Net::post("/order_status/",{ id: order_id }).to_str, self.model
    end
  end

  class Order < Bitstamp::Model
    BUY  = 0
    SELL = 1

    attr_accessor :type, :amount, :price, :id, :datetime
    attr_accessor :error, :message

    def cancel!
      Bitstamp::Net::post('/cancel_order', {id: self.id}).to_str
    end
  end
end
