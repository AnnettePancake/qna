# frozen_string_literal: true
class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  respond_to :js

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:id, :file)
  end
end
