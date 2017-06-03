module TwilioRubyWrapper
  class Condition
    attr_accessor :page_number, :page_size, :queues

    def initialize(condition, queues)
      @condition = condition
      @page_number = 0
      @page_size = 50
      @queues = queues
    end

    def where(*args)
      hash = args.first

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v } || hash.size >= 2
        raise
      end

      key = hash.keys.first
      value = build_value(hash[key], key)

      queues = []
      queue_set = @queues.list(page: @page_number, page_size: @page_size)
      until queue_set.empty? do
        t = queue_set.select {|queue| @condition[value][build_value(queue.send(key), key)] }
        queues.concat(t) unless t.empty?
        queue_set = queue_set.next_page
      end
      
      queues
    end

    def find_by(*args)
      hash = args.first

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v } || hash.size >= 2
        raise
      end

      key = hash.keys.first
      value = build_value(hash[key], key)

      queue_set = @queues.list(page: @page_number, page_size: @page_size)
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

  end
end
