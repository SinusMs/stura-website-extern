class ArticlesController < ApplicationController
  layout :determine_layout_for_user
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :verify_is_logged_in, only: %i[ new edit create update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.all.order(published: :desc)
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /articles/category/1
  def category
    @articles = Article.where(article_category_id: params[:article_category_id]).order(published: :desc)
    @article_category = ArticleCategory.find(params[:article_category_id])
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :published, :content, :article_category_id)
    end

    def verify_is_logged_in
      if !helpers.logged_in?
        head :unauthorized
      end
    end

    def determine_layout_for_user
      if helpers.logged_in?
        "backend"
      else
        "application"
      end
    end
end
