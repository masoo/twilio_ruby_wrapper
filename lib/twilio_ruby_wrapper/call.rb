module TwilioRubyWrapper
  class Call
    attr_reader :sid, :parent_call_sid, :account_sid, :to, :from, :phone_number_sid, :status, :price_unit, :direction, :answered_by, :forwarded_from, :to_formatted, :from_formatted, :caller_name, :duration, :price, :date_created, :date_updated, :start_time, :end_time
    attr_reader :call_instance

    def initialize(twilio_call_instance)
      @call_instance = twilio_call_instance
      @sid = @call_instance.sid
      @parent_call_sid = @call_instance.parent_call_sid
      @account_sid = @call_instance.account_sid
      @to = @call_instance.to
      @from = @call_instance.from
      @phone_number_sid = @call_instance.phone_number_sid
      @status = @call_instance.status
      @price_unit = @call_instance.price_unit
      @direction = @call_instance.direction
      @answered_by = @call_instance.answered_by
      @forwarded_from = @call_instance.forwarded_from
      @to_formatted = @call_instance.to_formatted
      @from_formatted = @call_instance.from_formatted
      @caller_name = @call_instance.caller_name
      @duration = @call_instance.duration
      @price = @call_instance.price
      @date_created = @call_instance.date_created
      @date_updated = @call_instance.date_updated
      @start_time = @call_instance.start_time
      @end_time = @call_instance.end_time
    end
  end
end
