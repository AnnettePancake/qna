# frozen_string_literal: true
class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    @attachment.destroy if can_manage_attachment?
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:id, :file)
  end

  def can_manage_attachment?
    @attachment.attachable.user_id == current_user.id
  end
end
