require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @not_prioritized = articles(:not_prioritized)
    @prioritized = articles(:prioritized)
    @new_article = Article.new(title: "New", published: Time.current, content: "content", article_category: article_categories(:enabled))
    @new_article2 = Article.new(title: "New2", published: Time.current, content: "content", article_category: article_categories(:enabled))
  end

  test "should get index" do
    get articles_url
    assert_response :success, "Anyone should be able to access articles index"
    login_user
    get articles_url
    assert_response :success, "Logged-in user should be able to access articles index"
    login_admin
    get articles_url
    assert_response :success, "Admin should be able to access articles index"
  end

  test "should get new only when logged in" do
    get new_article_url
    assert_response :unauthorized, "Non-logged-in user should not access new article form"
    login_user
    get new_article_url
    assert_response :success, "Logged-in user should access new article form"
    login_admin
    get new_article_url
    assert_response :success, "Admin should access new article form"
  end

  test "should create article only when logged in" do
    assert_difference("Article.count", 0, "Non-logged-in user should not be able to create an article") do
      post articles_url, params: { article: { article_category_id: @new_article.article_category_id, content: @new_article.content, published_day: @new_article.published_day, published_time: @new_article.published_time, title: @new_article.title } }
      assert_response :unauthorized, "Should respond with unauthorized for non-logged-in user"
    end
    login_user
    assert_difference("Article.count", 1, "Logged-in user should be able to create an article") do
      post articles_url, params: { article: { article_category_id: @new_article.article_category_id, content: @new_article.content, published_day: @new_article.published_day, published_time: @new_article.published_time, title: @new_article.title } }
    end
    assert_redirected_to article_url(Article.last), "Should redirect to newly created article for logged-in user"
    login_admin
    assert_difference("Article.count", 1, "Admin should be able to create an article") do
      post articles_url, params: { article: { article_category_id: @new_article.article_category_id, content: @new_article.content, published_day: @new_article.published_day, published_time: @new_article.published_time, title: @new_article.title } }
    end
    assert_redirected_to article_url(Article.last), "Should redirect to newly created article for admin"
  end

  test "should show article" do
    get article_url(@not_prioritized)
    assert_response :success, "Anyone should be able to view a public article"
    login_user
    get article_url(@not_prioritized)
    assert_response :success, "Logged-in user should be able to view a public article"
    login_admin
    get article_url(@not_prioritized)
    assert_response :success, "Admin should be able to view a public article"
  end

  test "should get edit only when logged in" do
    get edit_article_url(@prioritized)
    assert_response :unauthorized, "Non-logged-in user should not access edit form"
    login_user
    get edit_article_url(@not_prioritized)
    assert_response :success, "Logged-in user should access edit form"
    login_admin
    get edit_article_url(@not_prioritized)
    assert_response :success, "Admin should access edit form"
  end

  test "should update article only when logged in" do
    patch article_url(@not_prioritized), params: { article: { article_category_id: @not_prioritized.article_category_id, content: @not_prioritized.content, published_day: @not_prioritized.published_day, published_time: @not_prioritized.published_time, title: @not_prioritized.title } }
    assert_response :unauthorized, "Non-logged-in user should not be able to update article"
    login_user
    patch article_url(@not_prioritized), params: { article: { content: "newcontent", published_day: @not_prioritized.published_day, published_time: @not_prioritized.published_time, title: @not_prioritized.title } }
    assert_redirected_to article_url(@not_prioritized), "Logged-in user should be redirected after updating article"

    login_admin
    patch article_url(@not_prioritized), params: { article: { content: "newercontent", published_day: @not_prioritized.published_day, published_time: @not_prioritized.published_time, title: @not_prioritized.title } }
    assert_redirected_to article_url(@not_prioritized), "Admin should be redirected after updating article"
    @not_prioritized.reload
    assert_equal "newercontent", @not_prioritized.content, "Article content should be updated by admin"
  end

  test "should destroy article only when logged in" do
    assert_difference("Article.count", 0, "Non-logged-in user should not be able to destroy article") do
      delete article_url(@prioritized)
      assert_response :unauthorized, "Should respond with unauthorized for non-logged-in user"
    end
    login_user
    assert_difference("Article.count", -1, "Logged-in user should be able to destroy article") do
      delete article_url(@not_prioritized)
    end
    assert_redirected_to articles_url, "Should redirect to articles index after destroy for logged-in user"
    login_admin
    assert_difference("Article.count", -1, "Admin should be able to destroy article") do
      delete article_url(@prioritized)
    end
    assert_redirected_to articles_url, "Should redirect to articles index after destroy for admin"
  end

  test "should get category index" do
    get article_category_articles_url(article_categories(:enabled))
    assert_response :success, "Anyone should be able to access enabled category index"
    login_user
    get article_category_articles_url(article_categories(:enabled))
    assert_response :success, "Logged-in user should be able to access enabled category index"
    login_admin
    get article_category_articles_url(article_categories(:enabled))
    assert_response :success, "Admin should be able to access enabled category index"
  end

  test "should get category index for disabled category only when logged in" do
    get article_category_articles_url(article_categories(:disabled))
    assert_response :unauthorized, "Non-logged-in user should not access disabled category index"
    login_user
    get article_category_articles_url(article_categories(:disabled))
    assert_response :success, "Logged-in user should access disabled category index"
    login_admin
    get article_category_articles_url(article_categories(:disabled))
    assert_response :success, "Admin should access disabled category index"
  end

  test "should show articles in disabled category only to logged in users" do
    get article_url(articles(:category_disabled))
    assert_response :unauthorized, "Non-logged-in user should not view article in disabled category"
    login_user
    get article_url(articles(:category_disabled))
    assert_response :success, "Logged-in user should view article in disabled category"
    login_admin
    get article_url(articles(:category_disabled))
    assert_response :success, "Admin should view article in disabled category"
  end

  test "should show unpublished article only to logged in users" do
    get article_url(articles(:not_published))
    assert_response :unauthorized, "Non-logged-in user should not view unpublished article"
    login_user
    get article_url(articles(:not_published))
    assert_response :success, "Logged-in user should view unpublished article"
    login_admin
    get article_url(articles(:not_published))
    assert_response :success, "Admin should view unpublished article"
  end

  test "should handle invalid requests" do
    login_user
    get article_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for non-existent article"
    get edit_article_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for edit form of non-existent article"
    post edit_article_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for post to edit form of non-existent article"
    patch article_url(@not_prioritized), params: { article: { title: nil } }
    assert_response :unprocessable_entity, "Should respond with unprocessable_entity for invalid update (missing title)"
    delete article_url(id: 456763)
    assert_response :not_found, "Should respond with not_found when trying to delete a non-existent article category"
  end
end
