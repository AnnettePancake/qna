# frozen_string_literal: true
require_relative 'feature_helper'

feature 'User votes for answer/question', '
  As an aunthenticated user
  I want to be able to vote for answer/question on question page
' do

  shared_examples 'vote' do |entity|
    given!(:user) { create(:user) }
    given!(:voteable) { create(entity) }
    given!(:user_voteable) { create(entity, user: user) }

    def question_page(voteable)
      if voteable.is_a?(Question)
        question_path(id: voteable.id)
      else
        question_path(id: voteable.question_id)
      end
    end

    scenario 'Non-authenticated user tries to vote', js: true do
      visit question_page(voteable)

      expect(page).not_to have_css('.rating.btn-group')
    end

    scenario 'Authenticated user tries to vote by like', js: true do
      sign_in(user)
      visit question_page(voteable)

      within "#rating-#{voteable.class.name}-#{voteable.id}" do
        find(:css, '.glyphicon-thumbs-up').click
        wait_for_ajax

        expect(page).to have_content '1'
      end
    end

    scenario 'Authenticated user tries to vote by dislike', js: true do
      sign_in(user)
      visit question_page(voteable)

      within "#rating-#{voteable.class.name}-#{voteable.id}" do
        find(:css, '.glyphicon-thumbs-down').click
        wait_for_ajax

        expect(page).to have_content '-1'
      end
    end

    scenario 'Authenticated user tries to vote for his answer/question', js: true do
      sign_in(user)
      visit question_page(user_voteable)

      within "#rating-#{user_voteable.class.name}-#{user_voteable.id}" do
        expect(page).not_to have_css('.rating.btn-group')
      end
    end

    scenario 'Authenticated user tries to cancel his vote', js: true do
      sign_in(user)
      visit question_page(voteable)

      within "#rating-#{voteable.class.name}-#{voteable.id}" do
        find(:css, '.glyphicon-thumbs-down').click
        wait_for_ajax

        expect(page).to have_content '-1'

        find(:css, '.glyphicon-thumbs-down').click
        wait_for_ajax

        expect(page).to have_content '0'
      end
    end
  end

  context 'answer' do
    it_behaves_like 'vote', :answer
  end

  context 'question' do
    it_behaves_like 'vote', :question
  end
end
