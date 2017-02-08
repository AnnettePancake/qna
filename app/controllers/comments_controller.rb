# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, except: :destroy
  after_action :publish_comment, only: :create

  respond_to :js

  load_resource only: :destroy
  authorize_resource

  def new
    respond_with(@comment = @commentable.comments.new)
  end

  def create
    @comment = @commentable.comments.create(
      comment_params.merge(user_id: current_user.id)
    )
    respond_with(@comment)
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = params[:commentable].classify.constantize.find(commentable_id)
  end

  def commentable_id
    params[(params[:commentable].singularize + '_id').to_sym]
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments-question-#{@comment.question.id}",
      comment: @comment,
      commentable: { class: @commentable.class.name, id: @commentable.id }
    )
  end
end
