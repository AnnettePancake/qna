# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:question) { create(:question, title: 'MyString') }

  describe 'GET #show' do
    before { get :show, params: { query: 'MyString' } }

    it 'search requested info' do
      expect(response).to be_success
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end
