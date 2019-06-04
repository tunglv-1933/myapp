class Micropost < ApplicationRecord
	belongs_to :user
	validates :content, length: { maximum: 140 }, presence: { message: "All fields are required. Please try again." }
end
