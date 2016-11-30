# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, except: [:toggle_best]
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
    redirect_to question_path(id: @question.id)
  end

  def toggle_best
    question = @answer.question # true
    answers = question.answers

    return unless question.user == current_user

    answers.best_answers_except(@answer).update_all(best: false)
    @answer.best = !@answer.best
    @answer.save

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
