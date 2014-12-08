# Jerrod Carpenter / 14170384
# Thursday 20th, 2014
# mattersMass.rb

require 'net/http'
require 'nokogiri'
require 'sinatra'
require 'openssl'

get '/' do
  erb :home
end

post '/' do
  @item1 = params[:item1]
  @item2 = params[:item2]

  # Regex patterns needed.
  number_pattern = /(\d+.\d+)/

  # First item, get xml, parse, then use regex to get number out of response.
  url = "http://api.wolframalpha.com/v2/query?appid=9LAWTU-GW6ARRVVQ8&input=#{@item1}%20mass%20kg&format=plaintext"
  resp = Net::HTTP.get_response(URI.parse(url))

  xml = Nokogiri::XML(resp.body)
  xml = xml.xpath("//pod//plaintext")
  number1 = xml[1]
  number1 = number_pattern.match(number1.text)
  number1 = number1.captures[0].to_s.to_f

  # Second item, get xml, parse, then use regex to get number out of response.
  url = "http://api.wolframalpha.com/v2/query?appid=9LAWTU-GW6ARRVVQ8&input=#{@item2}%20mass%20kg&format=plaintext"
  resp = Net::HTTP.get_response(URI.parse(url))

  xml = Nokogiri::XML(resp.body)
  xml = xml.xpath("//pod//plaintext")
  number2 = xml[1]
  number2 = number_pattern.match(number2.text)
  number2 = number2.captures[0].to_s.to_f

  @mass = number1 / number2
  @mass = @mass.round(2)

  erb :mass
end

not_found do
  halt 404, "We don't know the mass of that."
end
