# frozen_string_literal: true
require 'rails_helper'

feature 'User creates answer on question page', '
  As an aunthenticated user
  I want to be able to create answer on question page
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user can create answer on question page' do
    sign_in(user)
    visit question_path(id: question.id)

    fill_in :answer_body, with: 'text text'
    click_on 'Answer'

    expect(page).to have_content 'text text'
    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-authenticated user tries to add answer' do
    visit root_path
    click_on question.title

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

feature 'User browses answers', '
  As an aunthenticated user
  I want to be able to browse answers
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers_list) { create_pair(:answer, question: question) }

  scenario 'Authenticated user can browse question and answers' do
    sign_in(user)
    visit question_path(id: question.id)

    answers_list.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end

feature 'User deletes his answer', '
  As an aunthenticated user
  I want to be able to delete my answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:user_answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question) }

  before do
    sign_in(user)
    visit question_path(id: question.id)
  end

  scenario 'Authenticated user can delete his answer' do
    within "#answer_#{user_answer.id}" do
      click_on 'Delete answer'
    end

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content(user_answer.body)
  end

  scenario "Authenticated user can't delete someone else's answer" do
    within "#answer_#{another_answer.id}" do
      expect(page).not_to have_content('Delete answer')
    end
    expect(page).to have_content(another_answer.body)
  end
end
