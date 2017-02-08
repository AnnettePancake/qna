# frozen_string_literal: true
class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  load_and_authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def attachment_params
    params.require(:attachment).permit(:id, :file)
  end
end
