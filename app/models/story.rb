# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  visible    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Story < ApplicationRecord
  belongs_to :user

  has_rich_text :content
  has_many :comments, as: :commentable
  has_many :pins, dependent: :destroy, inverse_of: :story

  validates :title, presence: true
  validates :content, no_attachments: true
end
