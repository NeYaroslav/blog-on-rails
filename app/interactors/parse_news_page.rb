class ParseNewsPage < ActiveInteractor::Base
  def perform
    news_link = "#{context.root_link}/fullnews.php?news=#{context.news_id}"
    response_news = HTTParty.get(news_link, timeout: 120)
    post = Nokogiri::HTML(response_news.body)

    title = post.css("h2").first.text
    content = post.css(".one_half p").inner_text
    image_url = "#{context.root_link}/#{post.css(".preview img").first.attribute("src").value}"

    context.news_info = {
      title: title,
      content: content,
      image_url: image_url,
      parsed_id: context.news_id
    }
  end
end
