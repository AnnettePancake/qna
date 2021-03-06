# frozen_string_literal: true
require 'rails_helper'

shared_examples 'votes' do
  sign_in_user

  describe 'POST #like' do
    it 'saves like in the database with correct value' do
      expect do
        post :like, xhr: true, params: { id: voteable.id }
      end.to change(voteable.votes, :count).by(1)

      expect(voteable.votes.last.value).to eq 1
    end
  end

  describe 'POST #dislike' do
    it 'saves dislike in the database with correct value' do
      expect do
        post :dislike, xhr: true, params: { id: voteable.id }
      end.to change(voteable.votes, :count).by(1)

      expect(voteable.votes.last.value).to eq(-1)
    end
  end
end
