require "test_helper"

class ArticleCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article_category = article_categories(:enabled)
    @new_article_category = ArticleCategory.new(enabled: true, name: "New Category")
    post login_url, params: { username: "admin", password: "123" }
    assert_response :found
  end

  test "should get index" do
    get article_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_article_category_url
    assert_response :success
  end

  test "should create article_category" do
    assert_difference("ArticleCategory.count") do
      post article_categories_url, params: { article_category: { enabled: @new_article_category.enabled, name: @new_article_category.name } }
    end

    assert_redirected_to article_categories_url
  end

  test "should show article_category" do
    get article_category_url(@article_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_category_url(@article_category)
    assert_response :success
  end

  test "should update article_category" do
    patch article_category_url(@article_category), params: { article_category: { enabled: @article_category.enabled, name: @article_category.name } }
    assert_redirected_to article_categories_url
  end

  # Commented out for now because an article category can't be deleted when its related to an article
  # TODO: write proper testcase for this
  # test "should destroy article_category" do
  #   assert_difference("ArticleCategory.count", -1) do
  #     delete article_category_url(@article_category)
  #   end

  #   assert_redirected_to article_categories_url
  # end
end
