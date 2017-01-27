# frozen_string_literal: true
require_relative 'feature_helper'

feature 'User creates comment for answer/question', '
  As an aunthenticated user
  I want to be able to create a comment for answer/question on question page
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  shared_examples 'comment' do |entity|
    before do
      @commentable = public_send(entity)
    end

    scenario 'Non-authenticated user tries to create a comment', js: true do
      visit question_path(id: question.id)

      expect(page).not_to have_button('Add a comment')
    end

    scenario 'Authenticated user tries to create a comment with invalid content', js: true do
      sign_in(user)
      visit question_path(id: question.id)

      within "#comments-#{@commentable.class.name}-#{@commentable.id}" do
        click_on 'Add a comment'
        click_on 'Save'

        expect(current_path).to eq question_path(id: question.id)
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'Authenticated user can create a comment on question page', js: true do
      sign_in(user)
      visit question_path(id: question.id)

      within "#comments-#{@commentable.class.name}-#{@commentable.id}" do
        click_on 'Add a comment'

        fill_in :comment_body, with: 'text text'
        click_on 'Save'

        expect(current_path).to eq question_path(id: question.id)
        expect(page).to have_content 'text text'
      end
    end

    scenario "Comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(id: question.id)
      end

      Capybara.using_session('guest') do
        visit question_path(id: question.id)
      end

      Capybara.using_session('user') do
        within "#comments-#{@commentable.class.name}-#{@commentable.id}" do
          click_on 'Add a comment'

          fill_in :comment_body, with: 'text text'
          click_on 'Save'

          expect(current_path).to eq question_path(id: question.id)
          expect(page).to have_content 'text text'
        end
      end

      Capybara.using_session('guest') do
        within "#comments-#{@commentable.class.name}-#{@commentable.id}" do
          expect(page).to have_content 'text text'
        end
      end
    end
  end

  context 'answer' do
    it_behaves_like 'comment', :answer
  end

  context 'question' do
    it_behaves_like 'comment', :question
  end
end

feature 'User deletes his comment', '
  As an aunthenticated user
  I want to be able to delete my comment
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }


  shared_examples 'comment' do |entity|
    before do
      @commentable = public_send(entity)
      @user_comment = create(:comment, commentable: @commentable, user: user)
      @another_comment = create(:comment, commentable: @commentable)

      sign_in(user)
      visit question_path(id: question.id)
    end

    scenario 'Authenticated user can delete his comment', js: true do
      within "#comment-#{@commentable.class.name}-#{@user_comment.id}" do
        find(:css, ".btn.glyphicon.glyphicon-trash").click
      end

      expect(current_path).to eq question_path(question)
      expect(page).not_to have_content(@user_comment.body)
    end

    scenario "Authenticated user can't delete someone else's comment" do
      within "#comment-#{@commentable.class.name}-#{@another_comment.id}" do
        expect(page).not_to have_css('.btn.glyphicon.glyphicon-trash')
      end
      expect(page).to have_content(@another_comment.body)
    end
  end

  context 'answer' do
    it_behaves_like 'comment', :answer
  end

  context 'question' do
    it_behaves_like 'comment', :question
  end
end
