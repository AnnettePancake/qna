# frozen_string_literal: true
require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create :user }

    let(:question) { create :question, user: user }
    let(:another_question) { create :question, user: another_user }

    let(:answer) { create :answer, user: user }
    let(:another_answer) { create :answer, user: another_user }

    let(:subscription) { create :subscription, user: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, another_question, user: user }

      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, another_question, user: user }

      it { should_not be_able_to :like, question, user: user }
      it { should be_able_to :like, another_question, user: user }

      it { should_not be_able_to :dislike, question, user: user }
      it { should be_able_to :dislike, another_question, user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, another_answer, user: user }

      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, another_answer, user: user }

      it { should be_able_to :toggle_best, create(:answer, question: question), user: user }
      it do
        should_not be_able_to :toggle_best, create(:answer, question: another_question),
                              user: user
      end

      it { should_not be_able_to :like, answer, user: user }
      it { should be_able_to :like, another_answer, user: user }

      it { should_not be_able_to :dislike, answer, user: user }
      it { should be_able_to :dislike, another_answer, user: user }
    end

    context 'Comment' do
      let(:comment) { create :comment, user: user }
      let(:another_comment) { create :comment, user: another_user }

      it { should be_able_to :create, Comment }

      it { should be_able_to :update, comment, user: user }
      it { should_not be_able_to :update, another_comment, user: user }

      it { should be_able_to :destroy, comment, user: user }
      it { should_not be_able_to :destroy, another_comment, user: user }
    end

    context 'Attachment' do
      let(:question_attachment) { create :attachment, attachable: question }
      let(:another_question_attachment) { create :attachment, attachable: another_question }

      let(:answer_attachment) { create :attachment, attachable: answer }
      let(:another_answer_attachment) { create :attachment, attachable: another_answer }

      it { should be_able_to :create, Attachment }

      it { should be_able_to :destroy, question_attachment, user: user }
      it { should_not be_able_to :destroy, another_question_attachment, user: user }

      it { should be_able_to :destroy, answer_attachment, user: user }
      it { should_not be_able_to :destroy, another_answer_attachment, user: user }
    end

    context 'Subscription' do
      it { should be_able_to :create, Subscription }

      it { should be_able_to :destroy, subscription, user: user }
    end
  end
end
