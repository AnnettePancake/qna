# frozen_string_literal: true
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
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
    if can_manage_question?
      @question.update(question_params)
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
