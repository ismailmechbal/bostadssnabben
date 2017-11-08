require 'dotenv'
Dotenv.load
require 'json'
require 'mechanize'
require 'slack-notifier'

BASE = "https://bostad.stockholm.se"
ADDRESS = "https://bostad.stockholm.se/Lista/AllaAnnonser"

@agent = Mechanize.new

def crawl
  page = @agent.get ADDRESS
  json = JSON.parse page.body
  
  results = []

  json.each do |hash|
    if hash["Bostadssnabben"] == true
      results = BASE + hash["Url"]
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK']
      message = "#{results}"
      notifier.ping message
    end
	end

end

crawl