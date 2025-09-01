class ArticleCategoriesController < ApplicationController
  layout "application"
  before_action :set_article_category, only: %i[ show edit update destroy ]
  before_action :verify_is_logged_in

  # GET /article_categories or /article_categories.json
  def index
    @article_categories = ArticleCategory.all
  end

  # GET /article_categories/1 or /article_categories/1.json
  def show
  end

  # GET /article_categories/new
  def new
    @article_category = ArticleCategory.new
  end

  # GET /article_categories/1/edit
  def edit
  end

  # POST /article_categories or /article_categories.json
  def create
    @article_category = ArticleCategory.new(article_category_params)

    respond_to do |format|
      if @article_category.save
        format.html { redirect_to article_categories_path, notice: "Artikelkategorie \"#{@article_category.name}\" erstellt." }
        format.json { render :show, status: :created, location: @article_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /article_categories/1 or /article_categories/1.json
  def update
    respond_to do |format|
      if @article_category.update(article_category_params)
        format.html { redirect_to article_categories_path, notice: "Artikelkategorie \"#{@article_category.name}\" aktualisiert." }
        format.json { render :show, status: :ok, location: @article_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /article_categories/1 or /article_categories/1.json
  def destroy
    respond_to do |format|
      if @article_category.destroy
        format.html { redirect_to article_categories_path, status: :see_other, notice: "Artikelkategorie \"#{@article_category.name}\" gelöscht." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article_category.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_category
      if ArticleCategory.exists?(params[:id].to_i)
        @article_category = ArticleCategory.find(params[:id].to_i)
      else
        head :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def article_category_params
      params.require(:article_category).permit(:name, :enabled)
    end
end
