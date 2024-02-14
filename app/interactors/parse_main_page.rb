class ParseMainPage < ActiveInteractor::Base
  def perform
    response_news = HTTParty.get(context.root_link)
    news = Nokogiri::HTML(response_news.body)

    context.news_ids = news.css("a.btn.medium").map do |html_link|
      endpoint = html_link.attribute("href").value
      news_id = endpoint[endpoint.index("=") + 1..-1]
    end
  end
end
