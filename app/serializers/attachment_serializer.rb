# frozen_string_literal: true
class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file, :created_at, :updated_at, :attachable_id, :attachable_type, :url

  def url
    object.file.url
  end
end
