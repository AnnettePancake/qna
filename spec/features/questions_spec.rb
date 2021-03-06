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
    visit new_question_path

    expect(page).to have_content 'You are not authorized to access this page'
  end

  scenario 'Authenticated user tries to create question with invalid content' do
    sign_in(user)

    ask_question
    click_on 'Save'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  context 'Multiple sessions' do
    scenario "Question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        ask_question
        fill_in :question_title, with: 'Test question'
        fill_in :question_body, with: 'text text'
        click_on 'Save'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text'
        expect(page).to have_content 'Your question successfully created.'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
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

    within '.question-title' do
      expect(page).not_to have_css('.question-settings')
    end
  end

  scenario 'Authenticated user tries to edit his question', js: true do
    sign_in(user)
    visit question_path(id: user_question.id)

    within "#question_#{user_question.id}" do
      find(:css, '.question-settings').click
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
      find(:css, '.question-settings').click
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

    within "#question_#{user_question.id}" do
      find(:css, '.question-settings').click
      click_on 'Delete question'
    end

    expect(current_path).to eq questions_path
    expect(page).not_to have_content(user_question.title)
  end

  scenario "Authenticated user can't delete someone else's question" do
    sign_in(user)
    visit question_path(id: another_question.id)

    within "#question_#{another_question.id}" do
      find(:css, '.question-settings').click
      expect(page).not_to have_content('Delete question')
    end
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
    ask_question
  end

  scenario 'User adds files when asks question', js: true do
    fill_in :question_title, with: 'Test question'
    fill_in :question_body, with: 'text text'

    2.times do
      click_on 'Add files'
      input_id = all('.nested-fields input[type=file]').last[:id]
      attach_file input_id, "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end

feature 'User deletes his attachment', '
  As an aunthenticated user
  I want to be able to delete my attachment
' do

  given(:user) { create(:user) }
  given(:user_question) { create(:question, user: user) }
  given(:another_question) { create(:question) }
  given!(:user_attachment) { create(:attachment, attachable: user_question) }
  given!(:another_attachment) { create(:attachment, attachable: another_question) }

  before do
    sign_in(user)
  end

  scenario 'Authenticated user can delete his attachment', js: true do
    visit question_path(id: user_question.id)

    within "#attachment_#{user_attachment.id}" do
      find(:css, 'span.glyphicon-remove').click
      wait_for_ajax
    end

    expect(page).not_to have_css("#attachment_#{user_attachment.id}")
  end

  scenario "Authenticated user can't delete someone else's attachment" do
    visit question_path(id: another_question.id)

    within "#attachment_#{another_attachment.id}" do
      expect(page).not_to have_css 'span.glyphicon-remove'
    end

    expect(page).to have_content(another_attachment.file_identifier)
  end
end

feature 'Subscription for question update', '
  As an aunthenticated user
  I want to be able to subscribe to question' do

  given(:user) { create(:user) }
  given!(:user_question) { create(:question, user: user) }
  given!(:another_question) { create(:question) }

  before do
    sign_in(user)
  end

  scenario 'Authenticated user can subscribe to question', js: true do
    visit question_path(id: another_question.id)

    within "#question_#{another_question.id}" do
      find(:css, '.question-settings').click
      click_on 'Subscribe'
      wait_for_ajax
      expect(page).to have_content 'Unsubscribe'
    end
  end

  scenario "Authenticated user can't subscribe to his question", js: true do
    visit question_path(id: user_question.id)

    within "#question_#{user_question.id}" do
      find(:css, '.question-settings').click
      expect(page).not_to have_content 'Subscribe'
    end
  end

  scenario 'Authenticated user can unsubscribe to question', js: true do
    visit question_path(id: another_question.id)

    within "#question_#{another_question.id}" do
      find(:css, '.question-settings').click
      click_on 'Subscribe'
      wait_for_ajax
      expect(page).to have_content 'Unsubscribe'

      click_on 'Unsubscribe'
      wait_for_ajax
      expect(page).to have_content 'Subscribe'
    end
  end

  scenario 'Authenticated user can unsubscribe to his question', js: true do
    visit question_path(id: user_question.id)

    within "#question_#{user_question.id}" do
      find(:css, '.question-settings').click
      click_on 'Unsubscribe'
      wait_for_ajax
      expect(page).to have_content 'Subscribe'
    end
  end
end

def ask_question
  visit questions_path
  click_on 'Ask question'
end
