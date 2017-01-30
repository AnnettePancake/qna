# frozen_string_literal: true
class QuestionsController < ApplicationController
  include Votes

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :gon_question, only: :show

  after_action :publish_question, only: [:create]

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers.ordered
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    return unless can_manage_question?
    respond_with @question.update(question_params)
  end

  def destroy
    respond_with(@question.destroy) if can_manage_question?
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

  def build_answer
    @answer = @question.answers.build
  end

  def gon_question
    gon.question_id = @question.id
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
