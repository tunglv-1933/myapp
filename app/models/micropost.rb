class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_by_created_at, -> {order created_at: :desc}
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.max_content_length }
  validate  :picture_size

  delegate :name, to: :user, prefix: true
  delegate :url, to: :picture, prefix: true

  private

  def picture_size
    return unless picture.size > Settings.max_image_size.megabytes
    errors.add :picture, t("should_be_less")
  end
end
