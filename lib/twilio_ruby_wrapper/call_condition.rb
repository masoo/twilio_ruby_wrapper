module TwilioRubyWrapper
  class CallCondition
    attr_accessor :page_number, :page_size, :calls
    @@account_sid = nil
    @@auth_token = nil

    def self.set_twilio_params(account_sid:, auth_token:)
      @@account_sid = account_sid
      @@auth_token = auth_token
      true
    end

    def initialize(condition: nil, filter: {}, page_number: 0, page_size: 50)
      @condition = condition
      @filter = filter
      @page_number = page_number
      @page_size = page_size
    end

    def where(*args)
      set_twilio_account()
      hash = args.first

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v } || hash.size >= 2
        raise
      end

      key = hash.keys.first
      value = build_value(hash[key], key)

      params = {page: @page_number, page_size: @page_size}
      params.merge!(@filter) unless @filter.empty?
      twilio_calls = @twilio_call_list.list(params)
      calls = []
      until twilio_calls.empty? do
        sub_calls = twilio_calls.select{|twilio_call| @condition[value][build_value(twilio_call.send(key), key)] }.map{|twilio_call| Call.new(twilio_call) }
        calls.concat(sub_calls) unless sub_calls.empty?
        twilio_calls = twilio_calls.next_page
      end

      calls
    end

    def find_by(*args)
      set_twilio_account()
      condition(:eq)
      hash = args.first

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v } || hash.size >= 2
        raise
      end

      key = hash.keys.first
      value = build_value(hash[key], key)

      params = {page: @page_number, page_size: @page_size}
      params.merge!(@filter) unless @filter.empty?
      twilio_calls = @twilio_call_list.list(params)
      call = nil
      until twilio_calls.empty? do
        call = twilio_calls.select {|twilio_call| @condition[value][build_value(twilio_call.send(key), key)] }.map{|twilio_call| Call.new(twilio_call) }.first
        break call.nil?
        twilio_calls = twilio_calls.next_page
      end

      call
    end

    def filter(*args)
      hash = args.first
      @filter = hash
      self
    end

    def condition(value)
      if !(Symbol === value)
        raise
      end

      condition = nil
      case value
      when :eq
        condition  = -> (x) { -> (y) { y == x }}
      when :lt
        condition  = -> (x) { -> (y) { y < x }}
      when :lteq
        condition  = -> (x) { -> (y) { y <= x }}
      when :gt
        condition  = -> (x) { -> (y) { y > x }}
      when :gteq
        condition  = -> (x) { -> (y) { y >= x }}
      else
        raise
      end

      @condition = condition

      self
    end

    private
      def build_value(target, key)
        value = nil
        case key
        when :sid, :parent_call_sid, :account_sid, :to, :from, :phone_number_sid, :status, :price_unit, :direction, :answered_by, :forwarded_from, :to_formatted, :from_formatted, :caller_name
          value = target
        when :duration, :price
          value = target.to_i
        when :date_created, :date_updated, :start_time, :end_time
          value = DateTime.parse(target)
        else
          raise
        end

        value
      end

      def set_twilio_account
        @twilio_client = Twilio::REST::Client.new(@@account_sid, @@auth_token)
        @twilio_call_list = @twilio_client.account.calls
      end
  end
end
