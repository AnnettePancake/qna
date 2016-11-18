# frozen_string_literal: true
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = Answer.where(question_id: @question.id)
  end

  def new
    @question = Question.new
  end

  def edit
    redirect_to(root_path) && return unless can_manage_question?
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, flash: { notice: 'Your question successfully created.' }
    else
      render :new
    end
  end

  def update
    redirect_to(root_path) && return unless can_manage_question?

    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy if can_manage_question?
    redirect_to root_path
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def can_manage_question?
    @question.user_id == current_user.id
  end
end
