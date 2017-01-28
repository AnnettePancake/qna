# frozen_string_literal: true
class AnswersController < ApplicationController
  include Votes

  before_action :authenticate_user!
  before_action :find_question, only: [:create, :new]
  before_action :find_answer, except: [:create, :like, :dislike]
  after_action :publish_answer, only: [:create]

  respond_to :js, :json

  def edit
  end

  def create
    @answer = current_user.answers.create(
      answer_params.merge(question_id: @question.id)
    )
    respond_with(@answer)
  end

  def update
    return unless can_manage_answer?
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy if can_manage_answer?
  end

  def toggle_best
    question = @answer.question

    return unless question.user.id == current_user.id
    @answer.toggle_best
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
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
