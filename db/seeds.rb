# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'json'
require 'open-uri'
require 'amazing_print'
require 'dotenv'

Dotenv.load(".env")
api_key = ENV['THE_MOVIE_DB_API_KEY']

base_url = 'https://api.themoviedb.org/3'

configuration_url = "#{base_url}/configuration?api_key=#{api_key}"
configuration_serialized = open(configuration_url).read
configuration = JSON.parse(configuration_serialized)

img_secure_base_url = configuration["images"]["secure_base_url"]
original_poster_size = "original"

top_rated_page_url = "#{base_url}/movie/top_rated?api_key=#{api_key}&language=en-US&page="

puts 'Cleaning DB'
Movie.destroy_all

puts 'Creating movies'
mv_count = 0
(1..10).each { |page_number|
  top_rated_page_serialized = open("#{top_rated_page_url}#{page_number}").read
  top_rated_page = JSON.parse(top_rated_page_serialized)
  top_rated_page["results"].each do |result|
    Movie.create(
      title: result["title"],
      overview: result["overview"],
      poster_url: "#{img_secure_base_url}#{original_poster_size}#{result["poster_path"]}",
      rating: result["vote_average"]
    )
    print "\r" + ("\e[K") if mv_count > 0
    print "#{mv_count} movies created"
    mv_count += 1
  end
}
puts "\nDB ready !"
