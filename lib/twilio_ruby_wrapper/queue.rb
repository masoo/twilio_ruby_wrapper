module TwilioRubyWrapper
  class Queue
    attr_accessor :page_number, :page_size, :queues

    def initialize(account_sid:, auth_token:)
      client = Twilio::REST::Client.new(account_sid, auth_token)
      @queues = client.account.queues
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

      Condition.new(condition, @queues)
    end
  end
end
