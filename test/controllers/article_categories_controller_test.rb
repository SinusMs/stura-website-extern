require "test_helper"

class ArticleCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @enabled = article_categories(:enabled)
    @disabled = article_categories(:disabled)
    @new_article_category = { enabled: true, name: "New Category" }
    @new_article_category2 = { enabled: true, name: "New Category 2" }
  end

  test "should get index" do
    login_user
    get article_categories_url
    assert_response :success, "User should be able to access the article categories index"
    login_admin
    get article_categories_url
    assert_response :success, "Admin should be able to access the article categories index"
  end

  test "should get new" do
    login_user
    get new_article_category_url
    assert_response :success, "User should be able to access the new article category form"
    login_admin
    get new_article_category_url
    assert_response :success, "Admin should be able to access the new article category form"
  end

  test "should create article_category" do
    login_user
    assert_difference("ArticleCategory.count", 1, "User should be able to create a new article category") do
      post article_categories_url, params: { article_category: @new_article_category }
      assert_redirected_to article_categories_url, "User should be redirected to article categories index after creation"
    end
    login_admin
    assert_difference("ArticleCategory.count", 1, "Admin should be able to create a new article category") do
      post article_categories_url, params: { article_category: @new_article_category2 }
      assert_redirected_to article_categories_url, "Admin should be redirected to article categories index after creation"
    end
  end

  test "should show article_category" do
    login_user
    get article_category_url(@enabled)
    assert_response :success, "User should be able to view an article category"
    login_admin
    get article_category_url(@enabled)
    assert_response :success, "Admin should be able to view an article category"
  end

  test "should get edit" do
    login_user
    get edit_article_category_url(@enabled)
    assert_response :success, "User should be able to access the edit form for an article category"
    login_admin
    get edit_article_category_url(@enabled)
    assert_response :success, "Admin should be able to access the edit form for an article category"
  end

  test "should update article_category" do
    login_user
    patch article_category_url(@enabled), params: { article_category: { enabled: @enabled.enabled, name: @enabled.name } }
    assert_redirected_to article_categories_url, "User should be redirected to article categories index after update"
    login_admin
    patch article_category_url(@enabled), params: { article_category: { enabled: @enabled.enabled, name: @enabled.name } }
    assert_redirected_to article_categories_url, "Admin should be redirected to article categories index after update"
  end

  test "should destroy article_category that has no articles as user" do
    login_user
    assert_difference("ArticleCategory.count", -1, "User should be able to destroy an article category with no articles") do
      delete article_category_url(article_categories(:no_articles))
    end
    assert_redirected_to article_categories_url, "User should be redirected to article categories index after deletion"
  end

  test "should destroy article_category that has no articles as admin" do
    login_admin
    assert_difference("ArticleCategory.count", -1, "Admin should be able to destroy an article category with no articles") do
      delete article_category_url(article_categories(:no_articles))
    end
    assert_redirected_to article_categories_url, "Admin should be redirected to article categories index after deletion"
  end

  test "should not destroy article_category that has associated articles" do
    login_admin
    assert_difference("ArticleCategory.count", 0, "Should not destroy an article category that has associated articles") do
      delete article_category_url(article_categories(:enabled))
    end
    assert_response :unprocessable_content, "Should respond with unprocessable_entity when trying to destroy a category with articles"
  end

  test "should handle invalid requests" do
    login_user
    get article_category_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for non-existent article category"
    get edit_article_category_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for edit form of non-existent article category"
    post edit_article_category_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for post to edit form of non-existent article category"
    patch article_category_url(@enabled), params: { article_category: { enabled: true, name: @disabled.name } }
    assert_response :unprocessable_content, "Should respond with unprocessable_entity for invalid update (duplicate name)"
    delete article_category_url(id: 456763)
    assert_response :not_found, "Should respond with not_found when trying to delete a non-existent article category"
  end
end
