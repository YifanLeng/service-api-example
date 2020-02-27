# entry point
require 'sinatra'
require 'net/http'

# retrieve your api host address like this
#   settings.api => "someaddress.ondigitalocean.com"
set :api, ENV['API_HOST']
set :api_port, ENV['API_PORT'] || 80

# Show a pretty table of all users... rendered on a html page.
get '/' do
  uri = URI.join("http://#{settings.api}:#{settings.api_port}", 
  	             "/users")
  res = Net::HTTP.get_response(uri)
  @api_host = settings.api
  @api_port = settings.api_port
  case res
  when Net::HTTPSuccess
  	@users = JSON.parse(res.body)
  	@count = @users.length
  	erb :index
  else
  	erb :error_page
  end
end

# the following routes are no longer needed because 
# we use Ajax(XMLHttpRequest). Therefore, both of the 
# post requests are send in the front end without re-routing
# post '/users' do
# 	uri = URI.join("http://#{settings.api}:#{settings.api_port}", 
#   	             "/users")
# 	puts "the count parameter is"
# 	puts params.to_s
# 	puts params[:count]
# 	res = Net::HTTP.post_form(uri, 'n' => params[:count])
# 	case res
#   when Net::HTTPSuccess
#   else
#   	erb :error_page
#   end
# end

# post '/users/destroy' do
# 	uri = URI.join("http://#{settings.api}:#{settings.api_port}", 
#   	             "/users/destroy")
# 	res = Net::HTTP.post_form(uri, params)
# 	case res
#   when Net::HTTPSuccess
#   else
#   	erb :error_page
#   end
# end



