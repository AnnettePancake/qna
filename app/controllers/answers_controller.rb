# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :update, :destroy]
  before_action :find_answer, only: [:edit, :update, :destroy]

  def edit
    redirect_to root_path unless can_manage_answer?
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(id: @question.id),
                  flash: { notice: 'Your answer successfully created.' }
    else
      render :new
    end
  end

  def update
    redirect_to root_path unless can_manage_answer?

    if @answer.update(answer_params)
      redirect_to question_path(id: @question.id)
    else
      render :edit
    end
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
