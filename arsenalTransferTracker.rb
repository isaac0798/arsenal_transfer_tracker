require 'httparty'
require 'nokogiri'
require 'byebug'
require 'twilio-ruby'

$keywords = [
  'aubameyang',
  'contract',
  'signs',
  'extends',
  'extension',
  'partey',
  'houssem',
  'aouar',
]

def scraper
  url = "https://www.arsenal.com/news?field_article_arsenal_team_value=men&revision_information="
  untouchedPage = HTTParty.get(url);
  parsedPage = Nokogiri::HTML(untouchedPage)

  allArticles = Array.new
  articleContents = parsedPage.css('div.article-card__content')
  soundTheAlarm = false

  articleContents.each do |article|
    articleTitle = article.css('h3.article-card__title')
    articleTitleArray = articleTitle.text.delete!("\n").strip.split

    allArticles.push(articleTitleArray)
  end

  allArticles.each do |article|
    article.each do |word|
     titleWord = word.downcase   

     if $keywords.include?(titleWord)
      soundTheAlarm = true
     end
    end
  end

  account_sid = ENV['TWILIO_ACCOUNT_SID']
  auth_token = ENV['TWILIO_AUTH_TOKEN']

  if soundTheAlarm
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    message = @client.messages
      .create(
        body: 'Arsenal news no spoilers 😉',
        from: '+447455764183',
        to: '+447565517992'
      )
  end
end

scraper
