# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'faker'

FactoryBot.define do
  factory :tag do
    name { Faker::Types.rb_string }
  end
end
