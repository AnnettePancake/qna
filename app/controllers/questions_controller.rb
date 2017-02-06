# frozen_string_literal: true
class QuestionsController < ApplicationController
  include Votes

  load_and_authorize_resource

  before_action :authenticate_user!, except: [:index, :show]
  before_action :build_answer, only: :show
  before_action :gon_question, only: :show

  after_action :publish_question, only: [:create]

  respond_to :js

  def index
    respond_with(@questions)
  end

  def show
    @answers = @question.answers.ordered
    respond_with @question
  end

  def new
    respond_with(@question)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    respond_with @question.update(question_params)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
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
