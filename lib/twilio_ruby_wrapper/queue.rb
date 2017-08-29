module TwilioRubyWrapper
  class Queue
    attr_reader :sid, :account_sid, :friendly_name, :uri, :current_size, :average_wait_time, :max_size, :date_created, :date_updated
    attr_accessor :queue_instance

    def initialize(twilio_queue_instance)
      @queue_instance = twilio_queue_instance
      @sid = @queue_instance.sid
      @account_sid = @queue_instance.account_sid
      @friendly_name = @queue_instance.friendly_name
      @uri = @queue_instance.uri
      @current_size = @queue_instance.current_size
      @average_wait_time = @queue_instance.average_wait_time
      @max_size = @queue_instance.max_size
      @date_created = @queue_instance.date_created
      @date_updated = @queue_instance.date_updated
    end

    def calls
      @queue_instance.members.list().map{|twilio_call| Call.new(twilio_call) }
    end
  end
end
