module TwilioRubyWrapper
  class Call
    attr_accessor :page_number, :page_size, :calls

    def initialize(account_sid:, auth_token:)
      client = Twilio::REST::Client.new(account_sid, auth_token)
      @calls = client.account.calls
      @filter = {}
      @page_number = 0
      @page_size = 50
    end

    def find_by(*args)
      hash = args.first

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v } || hash.size >= 2
        raise
      end

      condition = self.condition(:eq)
      condition.find_by(*args)
    end

    def filter(*args)
      hash = args.first
      @filter = hash
      self
    end

    def condition(value, filter: { page: @page_number, page_size: @page_size })
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

      filter = @filter unless @filter.empty?
      CallCondition.new(calls: @calls, condition: condition, filter: filter)
    end
  end
end
