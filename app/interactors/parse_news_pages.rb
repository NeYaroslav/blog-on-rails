class ParseNewsPages < ActiveInteractor::Base
  def perform
    context.news_ids.each do |news_id|
      next if Post.exists?(parsed_id: news_id)

      result = ParseNewsPage.perform(news_id: news_id, root_link: context.root_link)

      Post.new(result.news_info).save if result.success?
    end
  end
end
