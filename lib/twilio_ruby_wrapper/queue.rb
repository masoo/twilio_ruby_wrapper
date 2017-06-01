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

      if !(Hash === hash) || hash.values.any? {|v| v.nil? || Array === v || Hash === v }
        raise
      end

      sid = friendly_name = current_size = max_size = average_wait_time = nil
      equivalence = -> (x) { -> (y) { x == y }}
      keys = hash.keys
      keys.each do |key|
        case key
        when :sid
          sid = equivalence[hash[:sid]]
        when :friendly_name
          friendly_name = equivalence[hash[:friendly_name]]
        when :current_size
          current_size = equivalence[hash[:current_size]]
        when :max_size
          max_size = equivalence[hash[:max_size]]
        when :average_wait_time
          average_wait_time = equivalence[hash[:average_wait_time]]
        else
          raise
        end
      end

      queue_set = @queues.list(page: @page_number, page_size: @page_size)
      until queue_set.empty? do
        queue = queue_set.select {|queue| comparison(queue, sid, friendly_name, current_size, max_size, average_wait_time) }.first
        break unless queue.nil?
        queue_set = queue_set.next_page
      end
      
      queue
    end

    private

    def comparison(queue, sid, friendly_name, current_size, max_size, average_wait_time)
      value = false
      unless sid.nil?
        return false unless sid[queue.sid]
      end
      unless friendly_name.nil?
        return false unless friendly_name[queue.friendly_name]
      end
      unless current_size.nil?
        return false unless current_size[queue.current_size]
      end
      unless max_size.nil?
        return false unless max_size[queue.max_size]
      end
      unless average_wait_time.nil?
        return false unless average_wait_time[queue.average_wait_time]
      end
      return true
    end

  end
end
