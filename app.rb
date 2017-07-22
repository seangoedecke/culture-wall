require 'sinatra'
require 'active_record'
require 'byebug'
require_relative 'db_setup'
# require_relative 'models'

class Value < ActiveRecord::Base

end

# index route
get '/' do
	@values = Value.all
	erb :wall
end

post '/values/grow' do
	# add the value	
  	value_info = JSON.parse(request.body.string)
	value = Value.find_by(name: value_info['name']) || Value.create(name: value_info['name'])
	value.votes += 1
	value.save!
end

post '/values/shrink' do
	# add the value	
  	value_info = JSON.parse(request.body.string)
	value = Value.find_by(name: value_info['name'])
	value.votes -= 1 unless value.votes < 1
	value.save!
end