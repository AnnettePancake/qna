class Attachment < ApplicationRecord
  belongs_to :question, inverse_of: :attachments

  mount_uploader :file, FileUploader
end
