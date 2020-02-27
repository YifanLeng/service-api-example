# entry point
require 'sinatra'
require 'faker'
require_relative './models/user'

configure do
  enable :cross_origin
end  

# later consider limiting Access-Control-Allow-Origin to only
# the frontend-sinatra's url
before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# Retrieve all users from database.
get '/users' do
  begin
    users = []
    User.all.each do |user|
    	hash_object = {
        :name => user.name, 
        :email => user.email,
        :bio => user.bio
      }
      users << hash_object
    end
    status 200
    return users.to_json
  rescue
    status 500
  end
end

# Create n users.
post '/users' do
  count = params[:n].to_i || 1
  if count > 30
  	status 400
  else
	  count.times do
	  	user = User.new
	  	user.name = Faker::Name.name  
	  	user.email = Faker::Internet.email
	  	user.password = Faker::Internet.password
	  	user.bio = Faker::Lorem.paragraph
	  	# if saving to database fails 
	  	# terminate returns 500 Internal error code
	  	if !user.save
	  		satus 500
	  	end
	  end
	  status 200
	 end
end

# Delete all users.
post '/users/destroy' do
  begin
  	User.delete_all
  	status 200
  rescue
  	status 500
  end
end
