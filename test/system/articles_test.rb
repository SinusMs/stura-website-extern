require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:one)
    visit login_url
    fill_in "username", with: "admin"
    fill_in "password", with: "123"
    click_on "login"
    assert_text "Logged in: true"
  end

  test "visiting the index" do
    visit articles_url
    assert_selector "h1", text: "Articles"
  end

  test "should create article" do
    visit articles_url
    click_on "New article"

    fill_in "Article category", with: @article.article_category_id
    fill_in "Content", with: @article.content
    fill_in "Published", with: @article.published
    fill_in "Title", with: @article.title
    click_on "Create Article"

    assert_text "Article was successfully created"
    click_on "Back"
  end

  test "should update Article" do
    visit article_url(@article)
    click_on "Edit this article", match: :first

    fill_in "Article category", with: @article.article_category_id
    fill_in "Content", with: @article.content
    fill_in "Published", with: @article.published.to_s
    fill_in "Title", with: @article.title
    click_on "Update Article"

    assert_text "Article was successfully updated"
    click_on "Back"
  end

  test "should destroy Article" do
    visit article_url(@article)
    click_on "Destroy this article", match: :first

    assert_text "Article was successfully destroyed"
  end
end
