class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_content}
  validate  :picture_size

  private

  def picture_size
    return unless picture.size > Settings.pic_size.megabytes
    errors.add(:picture, t("picture_size.less_than_5mb"))
  end
end
