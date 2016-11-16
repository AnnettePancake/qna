require 'rails_helper'

feature 'Sessions', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in or log out or sign up
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in :user_email, with: 'wrong@test.com'
    fill_in :user_password, with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Registered user try to log out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign up' do
    visit new_user_registration_path

    within 'form#new_user' do
      fill_in :user_email, with: 'user@test.com'
      fill_in :user_password, with: '12345678'
      fill_in :user_password_confirmation, with: '12345678'
      click_on 'Sign up'
    end

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
