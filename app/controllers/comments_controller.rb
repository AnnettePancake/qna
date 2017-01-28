# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, except: :destroy
  before_action :find_comment, only: :destroy
  after_action :publish_comment, only: :create

  respond_to :js

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.create(
      comment_params.merge(user_id: current_user.id)
    )
    respond_with(@comment)
  end

  def destroy
    @comment.destroy if can_manage_comment?
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def can_manage_comment?
    @comment.user_id == current_user.id
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
