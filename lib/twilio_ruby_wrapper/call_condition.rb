module TwilioRubyWrapper
  class CallCondition
    attr_accessor :page_number, :page_size, :calls

    def initialize(calls:, condition:, filter: {})
      @calls = calls
      @condition = condition
      @filter = filter
      @page_number = 0
      @page_size = 50
    end

    def where(*args)
      hash = args.first

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v } || hash.size >= 2
        raise
      end

      key = hash.keys.first
      value = build_value(hash[key], key)

      calls = []
      params = {page: @page_number, page_size: @page_size}
      params.merge!(@filter) unless @filter.empty?
      queue_set = @calls.list(params)
      until queue_set.empty? do
        t = queue_set.select {|queue| @condition[value][build_value(queue.send(key), key)] }
        calls.concat(t) unless t.empty?
        queue_set = queue_set.next_page
      end
      
      calls
    end

    def find_by(*args)
      hash = args.first

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v } || hash.size >= 2
        raise
      end

      key = hash.keys.first
      value = build_value(hash[key], key)

      params = {page: @page_number, page_size: @page_size}
      params.merge!(@filter) unless @filter.empty?
      queue_set = @calls.list(params)
      t = nil
      until queue_set.empty? do
        t = queue_set.select {|queue| @condition[value][build_value(queue.send(key), key)] }.first
        break unless t.nil?
        queue_set = queue_set.next_page
      end
      
      t
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

  end
end
