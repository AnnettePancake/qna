# frozen_string_literal: true
class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at, :question_id, :rating

  has_many :comments
  has_many :attachments
end
