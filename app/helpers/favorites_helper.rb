# frozen_string_literal: true

module FavoritesHelper
  def favorite_for?(project)
    return false unless User.current&.logged?
    FavoriteProject.exists?(user_id: User.current.id, project_id: project.id)
  end
end