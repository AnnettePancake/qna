require 'rails_helper'
feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

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

feature 'Browse list of questions', %q{
  As an aunthenticated user
  I want to be able to browse list of questions
} do

  given(:user) { create(:user) }
  given!(:questions_list) { create_list(:question, 3) }

  scenario 'Authenticated user can browse list of questions' do
    sign_in(user)
    visit questions_path

    questions_list.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end

feature 'User creates answer on question page', %q{
  As an aunthenticated user
  I want to be able to create answer on question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user can create answer on question page' do
    sign_in(user)
    visit question_path(id: question.id)

    fill_in :answer_body, with: 'text text'
    click_on 'Answer'
  end
end
