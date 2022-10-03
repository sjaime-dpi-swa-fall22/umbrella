require "open-uri"
require "json"

p "Where are you located?"

user_location = gets.chomp

#user_location = "200 S Wacker"

p user_location

#URI.open("https://www.google.com").read #returns source code (HTML code) of Google home page

g_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=AIzaSyD8RrOFB0dPsF-leqeFJdmX3yOvcQbfNyY"
# or "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=AIzaSyD8RrOFB0dPsF-leqeFJdmX3yOvcQbfNyY"

raw_gmaps_data=URI.open(g_maps_url).read #returns source code (HTML code) of Google home page

parsed_gmaps_data=JSON.parse(raw_gmaps_data)

# p parsed_gmaps_data


# p parsed_gmaps_data.keys # gives you the main keys in the json

results_array=parsed_gmaps_data.fetch("results")  # results is an array of length 1

first_result = results_array.at(0) # get the first (and the only) element of the array

#p first_result.keys  # the keys inside results - ["address_components", "formatted_address", "geometry", "place_id", "types"]

geo= first_result.fetch("geometry")

loc= geo.fetch ("location")

latitude= loc.fetch("lat")

longitude= loc.fetch("lng")

p "latitude is #{latitude}, longitude is #{longitude}"

#p results_array=parsed_gmaps_data.fetch("results")

weather_url = "https://api.darksky.net/forecast/26f63e92c5006b5c493906e7953da893/#{latitude},#{longitude}"

raw_weather_data=URI.open(weather_url).read #returns source code (HTML code) of weather page

parsed_weather_data=JSON.parse(raw_weather_data)

# p parsed_weather_data.keys # gives you the main keys in the json

weather_results=parsed_weather_data.fetch("currently")  # results is an array of length 1

#p weather_results.keys

current_temperature = weather_results.fetch("temperature") # get the first (and the only) element of the array

p "current temperature in #{user_location} is #{current_temperature}"

p "It will be #{parsed_weather_data["hourly"]["summary"]}"

carry_umbrella=false

12.times do |index|
  precip_prob=parsed_weather_data["hourly"]["data"][index]["precipProbability"] # short-hand form of accessing hash and array elements instead of using "fetch" for hash or "at" for array
  if precip_prob > 0.1
    p "In #{index+1} hours the precipitation probability is #{precip_prob}"
    carry_umbrella=true
  end
end

if carry_umbrella==true
  p "You might want to carry an umbrella!"
else
  p "You probably won't need an umbrella today."
end
