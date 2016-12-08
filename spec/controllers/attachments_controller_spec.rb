# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:attachment) { create(:attachment, attachable: answer) }

  sign_in_user(:user)

  describe 'DELETE #destroy' do
    it 'deletes attachment' do
      expect do
        delete :destroy, params: { id: attachment.id, format: :js }
      end.to change(Attachment, :count).by(-1)
    end
  end
end
