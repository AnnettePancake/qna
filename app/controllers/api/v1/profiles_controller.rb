# frozen_string_literal: true
module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      skip_authorization_check

      def me
        respond_with current_resource_owner
      end

      def list
        respond_with(User.where.not(id: current_resource_owner.id))
      end
    end
  end
end
