require "application_system_test_case"

class ArticleCategoriesTest < ApplicationSystemTestCase
  setup do
    @article_category = article_categories(:one)
    visit login_url
    fill_in "username", with: "admin"
    fill_in "password", with: "123"
    click_on "login"
    assert_text "Logged in: true"
  end

  test "visiting the index" do
    visit article_categories_url
    assert_selector "h1", text: "Article categories"
  end

  test "should create article category" do
    visit article_categories_url
    click_on "New article category"

    check "Enabled" if @article_category.enabled
    fill_in "Name", with: @article_category.name
    click_on "Create Article category"

    assert_text "Article category was successfully created"
    click_on "Back"
  end

  test "should update Article category" do
    visit article_category_url(@article_category)
    click_on "Edit this article category", match: :first

    check "Enabled" if @article_category.enabled
    fill_in "Name", with: @article_category.name
    click_on "Update Article category"

    assert_text "Article category was successfully updated"
    click_on "Back"
  end

  test "should destroy Article category" do
    visit article_category_url(@article_category)
    click_on "Destroy this article category", match: :first

    assert_text "Article category was successfully destroyed"
  end
end
