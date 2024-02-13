require "httparty"
require "nokogiri"



class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  def create_from_html
    root_link = "http://csbc.edu.ua/"
    count = 0
    response_news = HTTParty.get(root_link)
    news = Nokogiri::HTML(response_news.body)

    news.css("a.btn.medium").each do |html_link|
      endpoint = html_link.attribute("href").value
      retry_count = 0
      post_id = endpoint[endpoint.index("=") + 1..-1]

      next if Post.exists?(post_id: post_id)

      begin
        response_post = HTTParty.get("#{root_link}/#{endpoint}", {timeout: 120})
      rescue => error
        if retry_count < 5
          retry_count += 1
          sleep(5 * retry_count)
          retry
        end
      end

      post = Nokogiri::HTML(response_post.body)
      post_title = post.css("h2").first.text
      post_description = post.css(".one_half p").inner_text
      post_image = "#{root_link}/#{post.css(".preview img").first.attribute("src").value}"

      post = Post.new(
        title: post_title,
        content: post_description,
        image_url: post_image,
        parsed_id: post_id
      )
      count += 1 if post.save
      sleep(5)
    end


    respond_to do |format|
      format.html { redirect_to posts_url, notice: "#{count} posts were successfully parsed." }
      format.json { head :no_content }
    end
  end
  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :image_url, :image_file, :html_file)
    end
end
