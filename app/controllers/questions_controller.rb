# frozen_string_literal: true
class QuestionsController < ApplicationController
  include Votes

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.ordered
    @answer = Answer.new
    @answer.attachments.build

    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    @question.update(question_params) if can_manage_question?
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
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def can_manage_question?
    @question.user_id == current_user.id
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
