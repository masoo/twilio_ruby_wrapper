module TwilioRubyWrapper
  class QueueCondition
    attr_accessor :page_number, :page_size, :queues
    @@account_sid = nil
    @@auth_token = nil

    def self.set_twilio_params(account_sid:, auth_token:)
      @@account_sid = account_sid
      @@auth_token = auth_token
      true
    end

    def initialize(condition: nil, page_number: 0, page_size: 50)
      @condition = condition
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
      twilio_queues = @twilio_queue_list.list(params)
      queues = []
      until twilio_queues.empty? do
        sub_queues = twilio_queues.select{|twilio_queue| @condition[value][build_value(twilio_queue.send(key), key)] }.map{|twilio_queue| Queue.new(twilio_queue) }
        queues.concat(sub_queues) unless sub_queues.empty?
        twilio_queues = twilio_queues.next_page
      end

      queues
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
      twilio_queues = @twilio_queue_list.list(params)
      queue = nil
      until twilio_queues.empty? do
        queue = twilio_queues.select{|twilio_queue| @condition[value][build_value(twilio_queue.send(key), key)] }.map{|twilio_queue| Queue.new(twilio_queue) }.first
        break queue.nil?
        twilio_queues = twilio_queues.next_page
      end

      queue
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
        when :sid, :account_sid, :friendly_name, :uri
          value = target
        when :current_size, :average_wait_time, :max_size
          value = target.to_i
        when :date_created, :date_updated
          value = DateTime.parse(target)
        else
          raise
        end

        value
      end

      def set_twilio_account
        @twilio_client = Twilio::REST::Client.new(@@account_sid, @@auth_token)
        @twilio_queue_list = @twilio_client.account.queues
      end
  end
end
