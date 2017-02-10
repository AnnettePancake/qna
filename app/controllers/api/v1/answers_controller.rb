# frozen_string_literal: true
module Api
  module V1
    class AnswersController < Api::V1::BaseController
      load_and_authorize_resource

      def index
        respond_with @answers
      end

      def show
        respond_with @answer
      end

      def create
        @answer = current_resource_owner.answers.create(
          answer_params.merge(question_id: params[:question_id])
        )
        respond_with @answer
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
