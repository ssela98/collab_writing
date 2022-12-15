# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(24)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :story_tags, dependent: :destroy, inverse_of: :tag
  has_many :stories, through: :story_tags

  validates :name, presence: true
end
