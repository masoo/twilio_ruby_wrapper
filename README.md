# TwilioRubyWrapper

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/twilio_ruby_wrapper`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twilio_ruby_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twilio_ruby_wrapper

## Usage

```ruby
queues = TwilioRubyWrapper::Queue.new(account_sid: "Twilio ACCOUNT SID", auth_token: "Twilio AUTH TOKEN")
queues.find_by(sid: "Queue SID") # return <Twilio::REST::Queue> object
queues.find_by(friendly_name: "Queue friendly name") # return <Twilio::REST::Queue> object
queues.condition(:gt).where(date_updated: "2017-05-31 0:0:0") # [<Twilio::REST::Queue>] array object
# The following is an error.
# queues.condition(:lt).where(date_updated: "2017-05-31 0:0:0").condition(:gt).where(date_updated: "2017-05-31 23:59:59")

calls = TwilioRubyWrapper::Call.new(account_sid: "Twilio ACCOUNT SID", auth_token: "Twilio AUTH TOKEN")
calls.filter(:"start_time>" => "2017-05-32").condition(:eq).where(from: "PHONE NUMBER")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/masoo/twilio_ruby_wrapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

