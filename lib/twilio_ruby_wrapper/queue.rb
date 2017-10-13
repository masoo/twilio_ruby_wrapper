module TwilioRubyWrapper
  class Queue
    attr_reader :sid, :account_sid, :friendly_name, :uri, :current_size, :average_wait_time, :max_size, :date_created, :date_updated
    attr_accessor :queue_instance

    def self.set_twilio_params(account_sid:, auth_token:)
      @@account_sid = account_sid
      @@auth_token = auth_token
      true
    end

    def initialize(twilio_queue_instance)
      @twilio_client = Twilio::REST::Client.new(@@account_sid, @@auth_token)
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
      @queue_instance.members.list().map do |member|
        Call.new(@twilio_client.api.v2010.account.calls(member.call_sid).fetch)
      end
    end
  end
end
