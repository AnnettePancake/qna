# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :new]
  before_action :find_answer, except: [:create]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
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

    render nothing: true
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def can_manage_answer?
    @answer.user_id == current_user.id
  end
end
