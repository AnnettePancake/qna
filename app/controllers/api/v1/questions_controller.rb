# frozen_string_literal: true
module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      load_and_authorize_resource

      def index
        respond_with @questions
      end

      def show
        respond_with @question
      end

      def create
        respond_with @question = current_resource_owner.questions.create(question_params)
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
