require 'sinatra'
require 'active_record'
require 'digest/sha1'
require_relative 'db_setup'
require_relative 'config/environments'
# require_relative 'models'
enable :sessions

class Value < ActiveRecord::Base
	belongs_to :wall
end

class Wall < ActiveRecord::Base
	has_many :values
	before_save :validate_num_values

	def validate_num_values
		if !is_paid && values.count > 5
			throw :abort
		end
	end
end

# seed demo wall if needed

demo_wall = Wall.find_by(unique_hash_id: 'demo')
if demo_wall.nil?
	 demo_wall = Wall.create(unique_hash_id: 'demo', is_paid: true)
	['Synergy', 'Hard work', 'Agile', 'Flexibility', 'Idea validation'].each do |v|
		value = demo_wall.values.create(name: v, votes: (1..15).to_a.sample)
	end
end

# index route
get '/' do
	@recent_wall = session[:recent_wall]
	erb :index
end

get '/payment' do
	erb :payment
end

get '/walls/new' do
	hash_id = Digest::SHA1.hexdigest(Time.now.to_s)
	wall = Wall.create(unique_hash_id: hash_id)
	session[:recent_wall] = hash_id
	redirect '/walls/' + wall.unique_hash_id
end

get '/walls/:hash' do
	wall = Wall.find_by(unique_hash_id: params[:hash])
	redirect '/' if wall.nil?
	@values = wall.values
	@is_paid_wall = wall.is_paid || ''
	erb :wall
end


post '/walls/:hash/values/grow' do
	# add the value	
  	value_info = JSON.parse(request.body.string)
	wall = Wall.find_by(unique_hash_id: params[:hash])
	return if wall.nil? || wall.unique_hash_id == 'demo'
	value = Value.find_by(name: value_info['name'], wall_id: wall.id) || Value.create(name: value_info['name'], wall_id: wall.id)
	value.votes += 1
	value.save!
end

post '/walls/:hash/values/shrink' do
	# add the value	
  	value_info = JSON.parse(request.body.string)
	wall = Wall.find_by(unique_hash_id: params[:hash])
	return if wall.nil? || wall.unique_hash_id == 'demo'
	value = Value.find_by(name: value_info['name'], wall_id: wall.id)
	value.votes -= 1 unless value.votes < 1
	value.save!
end