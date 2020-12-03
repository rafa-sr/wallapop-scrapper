# frozen_string_literal: true

require 'open-uri'
require 'httparty'
require 'nokogiri'
require 'byebug'

URL = 'https://www.habitaclia.com/alquiler-piso-en_carrer_de_la_marina_179_calle_de_la_marina_179-barcelona-i500003911806.htm?hab=3&m2=100&pmin=900&pmax=1100&coddists=200&codzonas=203&ady=1&f=&from=list&lo=59'
MAX_SCRAPES = 10
MAX_TRIES = 3
LOG_FILE = 'habitaclia.log'
OWNER = 'Particular'
def open_log_file
  File.open(Rails.root.join('log', LOG_FILE), 'a')
end

def scrape
  puts "scraping #{URL}"
  puts owner?
end

def run
  # open_log_file
  scrape
end

def html_string
  response = HTTParty.get(URL)
  return response unless response.body.nil? || response.body.empty?

  puts 'Error cant find the url'
end

def doc
  res = html_string
  return puts 'error ' if res.body.nil? || res.body.empty?

  Nokogiri::HTML(res)
end

def owner?
  return true if doc.at("div[class='data_nl']").text.strip.eql? OWNER

  false
end

run
