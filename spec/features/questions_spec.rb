# frozen_string_literal: true
require 'rails_helper'
feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in :question_title, with: 'Test question'
    fill_in :question_body, with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

feature 'Browse list of questions', '
  As an aunthenticated user
  I want to be able to browse list of questions
' do

  given(:user) { create(:user) }
  given!(:questions_list) { create_list(:question, 3) }

  scenario 'Authenticated user can browse list of questions' do
    sign_in(user)
    visit questions_path

    questions_list.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end

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
  end

  scenario 'Non-authenticated user tries to add answer' do
    visit root_path
    click_on question.title

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

feature 'User browses question and answers', '
  As an aunthenticated user
  I want to be able to browse question and answers
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers_list) { create_list(:answer, 3, question: question) }

  scenario 'Authenticated user can browse question and answers' do
    sign_in(user)
    visit question_path(id: question.id)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers_list.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end

feature 'User deletes his question', '
  As an aunthenticated user
  I want to be able to delete my question
' do

  given(:user) { create(:user) }
  given!(:user_question) { create(:question, user: user) }
  given!(:another_question) { create(:question) }

  scenario 'Authenticated user can delete his question' do
    sign_in(user)
    visit question_path(id: user_question.id)

    click_on 'Delete question'
    expect(current_path).to eq root_path
    expect(page).not_to have_content(user_question.title)
  end

  scenario "Authenticated user can't delete someone else's question" do
    sign_in(user)
    visit question_path(id: another_question.id)

    expect(page).not_to have_content('Delete answer')
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
