# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  content    :text
#  public     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Story < ApplicationRecord
end
