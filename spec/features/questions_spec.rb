# frozen_string_literal: true
require_relative 'feature_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    ask_question
    fill_in :question_title, with: 'Test question'
    fill_in :question_body, with: 'text text'
    click_on 'Save'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    ask_question

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to create question with invalid content' do
    sign_in(user)

    ask_question
    click_on 'Save'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end
end

feature 'User edits his question', '
  As an aunthenticated user
  I want to be able to edit my question
' do

  given(:user) { create(:user) }
  given!(:user_question) { create(:question, title: 'title', body: 'lalala', user: user) }
  given!(:another_question) { create(:question) }

  scenario 'Non-authenticated user tries to edit question' do
    visit question_path(id: another_question.id)

    expect(page).not_to have_content 'Edit question'
  end

  scenario 'Authenticated user tries to edit his question', js: true do
    sign_in(user)
    visit question_path(id: user_question.id)

    within "#question_#{user_question.id}" do
      click_on 'Edit question'
      fill_in :question_title, with: 'question'
      fill_in :question_body, with: 'text-text-text'
      click_on 'Save'

      expect(page).not_to have_content 'lalala'
      expect(page).not_to have_content 'title'
      expect(page).to have_content 'text-text-text'
      expect(page).to have_content 'question'
    end
  end

  scenario "Authenticated user tries to edit someone else's question" do
    sign_in(user)
    visit question_path(id: another_question.id)

    within "#question_#{another_question.id}" do
      expect(page).not_to have_content('Edit question')
    end

    expect(page).to have_content(another_question.body)
  end
end

feature 'Browse list of questions', '
  As an aunthenticated user
  I want to be able to browse list of questions
' do

  given(:user) { create(:user) }
  given!(:questions_list) { create_pair(:question) }

  scenario 'Authenticated user can browse list of questions' do
    sign_in(user)
    visit questions_path

    questions_list.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end

feature 'User browses question', '
  As an aunthenticated user
  I want to be able to browse question and answers
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user can browse question' do
    sign_in(user)
    visit question_path(id: question.id)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
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

    expect(page).not_to have_content('Delete question')
  end
end

feature 'Add files to question', "
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
" do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in :question_title, with: 'Test question'
    fill_in :question_body, with: 'text text'
    attach_file :question_attachments_attributes_0_file, "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end

def ask_question
  visit questions_path
  click_on 'Ask question'
end
