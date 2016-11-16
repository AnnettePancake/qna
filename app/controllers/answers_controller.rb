# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :find_question, only: [:create, :update, :destroy]
  before_action :find_answer, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(id: @question.id)
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(id: @question.id)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
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
end
