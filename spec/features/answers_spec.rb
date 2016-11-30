# frozen_string_literal: true
require_relative 'feature_helper'

feature 'User creates answer on question page', '
  As an aunthenticated user
  I want to be able to create answer on question page
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user can create answer on question page', js: true do
    sign_in(user)
    expect(page).to have_current_path(root_path)
    visit question_path(id: question.id)

    fill_in :answer_body, with: 'text text'
    click_on 'Save'

    expect(current_path).to eq question_path(id: question.id)
    within '.answers' do
      expect(page).to have_content 'text text'
    end
  end

  scenario 'Non-authenticated user tries to add answer' do
    visit root_path
    click_on question.title

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to create answer with invalid content', js: true do
    sign_in(user)
    expect(page).to have_current_path(root_path)
    visit question_path(id: question.id)
    click_on 'Save'

    expect(current_path).to eq question_path(id: question.id)
    expect(page).to have_content "Body can't be blank"
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

feature 'User edits his answer', '
  As an aunthenticated user
  I want to be able to edit my answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:user_answer) { create(:answer, question: question, body: 'lalala', user: user) }
  given!(:another_answer) { create(:answer, question: question) }

  scenario 'Non-authenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Edit'
  end

  scenario 'Authenticated user tries to edit his answer', js: true do
    sign_in(user)
    visit question_path(id: question.id)

    within "#answer_#{user_answer.id}" do
      click_on 'Edit'
      fill_in :answer_body, with: 'text-text-text'
      click_on 'Save'

      expect(page).not_to have_content 'lalala'
      expect(page).to have_content 'text-text-text'
    end
  end

  scenario "Authenticated user tries to edit someone else's answer" do
    sign_in(user)
    visit question_path(id: question.id)

    within "#answer_#{another_answer.id}" do
      expect(page).not_to have_content('Edit')
    end

    expect(page).to have_content(another_answer.body)
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

  scenario 'Authenticated user can delete his answer', js: true do
    within "#answer_#{user_answer.id}" do
      click_on 'Delete'
    end

    expect(current_path).to eq question_path(question)
    expect(page).not_to have_content(user_answer.body)
  end

  scenario "Authenticated user can't delete someone else's answer" do
    within "#answer_#{another_answer.id}" do
      expect(page).not_to have_content('Delete')
    end
    expect(page).to have_content(another_answer.body)
  end
end

feature 'User chooses best answer', '
  As an aunthenticated user and author of question
  I want to be able to choose best answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:another_answer) { create(:answer, question: question) }

  scenario 'Non-author of question tries to choose best answer' do
    visit question_path(question)

    expect(page).not_to have_css 'input#toggle-best'
  end

  scenario 'Author of question tries to choose best answer for his question', js: true do
    sign_in(user)
    visit question_path(id: question.id)

    within '.answers' do
      find(:css, "#toggle_best_#{answer.id}").click
      wait_for_ajax

      expect(page).to have_css("input#toggle_best_#{answer.id}:checked")
      expect(page).to have_css("input#toggle_best_#{another_answer.id}:not(:checked)")

      find(:css, "#toggle_best_#{another_answer.id}").click
      wait_for_ajax

      expect(page).to have_css("input#toggle_best_#{another_answer.id}:checked")
      expect(page).to have_css("input#toggle_best_#{answer.id}:not(:checked)")
    end
  end
end
