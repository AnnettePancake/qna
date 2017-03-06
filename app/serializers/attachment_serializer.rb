# frozen_string_literal: true
class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file, :created_at, :updated_at, :attachable_id, :attachable_type, :url,
             :file_name

  def file_name
    object.file.identifier
  end

  def url
    object.file.url
  end
end
