require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
    def setup
        @user = User.create(username: "john", email: "john@example.com", password: "password")
    end

    test "get new article form and create article" do
        sign_in_as(@user, "password")
        get new_article_path
        assert_template 'articles/new'
        assert_difference 'Article.count', 1 do
            post articles_path, params: { article: {title: "Test Article", description: "This is the description of the test article."} }
            follow_redirect!
        end
        assert_template 'articles/show'
        assert_match "Test Article", response.body
    end

    test "empty form submission results in failure" do
        sign_in_as(@user, "password")
        get new_article_path
        assert_template 'articles/new'
        assert_no_difference 'Article.count' do
            post articles_path, params: { article: {title: " ", description: " "} }
        end
        assert_template 'articles/new'
        assert_select 'div.alert-danger'
        assert_match "4 errors occurred", response.body
    end
end
