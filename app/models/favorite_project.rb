# frozen_string_literal: true

class FavoriteProject < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user_id, :project_id, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
end