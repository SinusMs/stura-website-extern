class ArticlesController < ApplicationController
  layout "application"
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :verify_is_logged_in, only: %i[ new edit create update destroy ]

  # GET /articles or /articles.json
  def index
    @articles = Article.public_articles.order_by_date_and_priorization
  end

  # GET /articles/1 or /articles/1.json
  def show
    if !helpers.logged_in? && (!ArticleCategory.find(Article.find(params[:id]).article_category_id).enabled || @article.published > Time.current)
      head :unauthorized
    end
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
        format.html { redirect_to @article, notice: "Artikel \"#{@article.title}\" erstellt." }
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
        format.html { redirect_to @article, notice: "Artikel \"#{@article.title}\" aktualisiert." }
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
      format.html { redirect_to articles_path, status: :see_other, notice: "Artikel \"#{@article.title}\" gelöscht." }
      format.json { head :no_content }
    end
  end

  # GET /articles/category/1
  def category
    @article_category = ArticleCategory.find(params[:article_category_id])
    if helpers.logged_in? || @article_category.enabled
      @articles = Article.public_articles.where(article_category_id: params[:article_category_id]).order_by_date_and_priorization
      render :index
    else
      head :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      if Article.exists?(params[:id])
        @article = Article.find(params[:id])
      else
        head :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :published_day, :published_time, :content, :prioritize_until, :article_category_id, :image)
    end
end
