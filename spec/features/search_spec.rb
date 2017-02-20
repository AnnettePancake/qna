# frozen_string_literal: true
require_relative 'feature_helper'

feature 'Search', '
  I want to be able to search for answer/comment/question/user
' do

  let!(:user) { create(:user, email: '123456@test.com') }
  let!(:question) { create(:question, title: 'Question', body: 'lalala') }
  let!(:answer) { create(:answer, body: 'Answer') }
  let!(:comment) { create(:comment, body: 'Comment', commentable: question) }

  before do
    visit root_path
  end

  scenario 'Search with no matches', type: :request do
    within 'form.search' do
      fill_in :search_query, with: 'Title'
      click_on 'Search'
    end

    within '.results' do
      expect(page).to have_content 'No matches'
    end
  end

  scenario 'Search in all classes', type: :request, js: true do
    within 'form.search' do
      fill_in :search_query, with: 'Question'
      click_on 'Search'
    end

    within '.results' do
      expect(page).to have_content 'Question'
    end
  end

  scenario 'Search in Question', type: :request do
    within 'form.search' do
      fill_in :search_query, with: 'lalala'
      select 'Question', from: :search_entity
      click_on 'Search'
    end

    within '.results' do
      expect(page).to have_content 'lalala'
    end
  end

  scenario 'Search in Answer', type: :request do
    within 'form.search' do
      fill_in :search_query, with: 'Answer'
      select 'Answer', from: :search_entity
      click_on 'Search'
    end

    within '.results' do
      expect(page).to have_content 'Answer'
    end
  end

  scenario 'Search in Comment', type: :request do
    within 'form.search' do
      fill_in :search_query, with: 'Comment'
      select 'Comment', from: :search_entity
      click_on 'Search'
    end

    within '.results' do
      expect(page).to have_content 'Comment'
    end
  end

  scenario 'Search in User', type: :request do
    within 'form.search' do
      fill_in :search_query, with: '123456@test.com'
      select 'User', from: :search_entity
      click_on 'Search'
    end

    within '.results' do
      expect(page).to have_content '123456@test.com'
    end
  end
end
