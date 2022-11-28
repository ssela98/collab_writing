# frozen_string_literal: true

class AddCachedScopedLikeVotesToStories < ActiveRecord::Migration[7.0]
  def up
    add_column :stories, :cached_scoped_like_votes_total, :integer, default: 0, if_not_exists: true
    add_column :stories, :cached_scoped_like_votes_score, :integer, default: 0, if_not_exists: true
    add_column :stories, :cached_scoped_like_votes_up, :integer, default: 0, if_not_exists: true
    add_column :stories, :cached_scoped_like_votes_down, :integer, default: 0, if_not_exists: true
    add_column :stories, :cached_weighted_like_score, :integer, default: 0, if_not_exists: true
    add_column :stories, :cached_weighted_like_total, :integer, default: 0, if_not_exists: true
    add_column :stories, :cached_weighted_like_average, :float, default: 0.0, if_not_exists: true

    # calculate the existing votes
    # Story.find_each { |p| p.update_cached_votes("like") }
  end

  def down
    remove_column :stories, :cached_scoped_like_votes_total, if_exists: true
    remove_column :stories, :cached_scoped_like_votes_score, if_exists: true
    remove_column :stories, :cached_scoped_like_votes_up, if_exists: true
    remove_column :stories, :cached_scoped_like_votes_down, if_exists: true
    remove_column :stories, :cached_weighted_like_score, if_exists: true
    remove_column :stories, :cached_weighted_like_total, if_exists: true
    remove_column :stories, :cached_weighted_like_average, if_exists: true
  end
end
