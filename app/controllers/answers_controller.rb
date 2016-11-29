# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :edit, :update, :destroy]
  before_action :find_answer, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @question = @answer.question
    @answer.user = current_user
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy if can_manage_answer?
    redirect_to question_path(id: @question.id)
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
