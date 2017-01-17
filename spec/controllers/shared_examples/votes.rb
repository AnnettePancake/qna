# frozen_string_literal: true
require 'rails_helper'

shared_examples 'votes' do
  sign_in_user

  describe 'POST #like' do
    it 'saves like in the database' do
      expect do
        post :like, params: { id: voteable.id }, format: :js
      end.to change(voteable.votes, :count).by(1)
    end
  end

  describe 'POST #dislike' do
    it 'saves dislike in the database' do
      expect do
        post :dislike, params: { id: voteable.id }, format: :js
      end.to change(voteable.votes, :count).by(1)
    end
  end
end

#   describe 'POST #dislike' do
#     it 'saves dislike in the database' do
#       expect do
#         post :dislike, params: params_voteable, format: :js
#       end.to change(voteable.votes, :count).by(1)
#     end
#   end
# end


# it behaves_like 'likeable', described_class: :question
# it behaves_like 'likeable', described_class: :answer
#
# shared_examples 'likable' do
#   # described_class == :question
#   user = create :user
#   entity = create described_class
#
#   expect do
#     post :like, "#{described_class}_id" => entity.id
#   end.to change(entity.votes, :count).by(1)
# end
