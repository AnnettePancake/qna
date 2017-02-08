# frozen_string_literal: true
class AnswersController < ApplicationController
  include Votes

  before_action :authenticate_user!
  before_action :find_question, only: [:create]

  after_action :publish_answer, only: [:create]

  respond_to :js

  load_resource :question
  load_and_authorize_resource :answer, through: :question, shallow: true,
                                       only: [:create, :edit, :update, :destroy, :toggle_best]

  def create
    @answer = current_user.answers.create(
      answer_params.merge(question_id: @question.id)
    )
    respond_with(@answer)
  end

  def update
    respond_with @answer.update(answer_params)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def toggle_best
    respond_with(@answer.toggle_best)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def can_manage_answer?
    @answer.user_id == current_user.id
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answer_question_#{@question.id}",
      answer: @answer,
      question: @question,
      attachments: @answer.attachments
    )
  end
end
