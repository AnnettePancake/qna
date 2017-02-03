# frozen_string_literal: true
require_relative 'feature_helper'

feature 'User sign in with Twitter' do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
  end

  scenario 'New user signs in with Twitter' do
    visit '/users/sign_in'
    click_on 'Sign in with Twitter'

    expect do
      fill_in :email, with: 'user@test.com'
      click_on 'Save'
    end.to change(UserMailer.deliveries, :count).by(1)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Check your email'

    open_email('user@test.com')

    current_email.click_link 'this link'
    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'User signs in with invalid credentials' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

    visit '/users/sign_in'
    click_on 'Sign in with Twitter'

    expect(page).to\
      have_content('Could not authenticate you from Twitter because "Invalid credentials"')
  end
end

feature 'User sign in with Facebook' do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end

  scenario 'User signs in with Facebook' do
    visit '/users/sign_in'
    click_on 'Sign in with Facebook'

    expect(page).to have_content('Successfully authenticated from Facebook account.')
  end

  scenario 'User signs in with invalid credentials' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

    visit '/users/sign_in'
    click_on 'Sign in with Facebook'

    expect(page).to\
      have_content('Could not authenticate you from Facebook because "Invalid credentials"')
  end
end
