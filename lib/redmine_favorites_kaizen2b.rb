# frozen_string_literal: true

require 'redmine'

# Constante para zeitwerk
module RedmineFavoritesKaizen2b
end

# Hacer disponible el helper en cualquier vista (incluida la del proyecto)
Rails.configuration.to_prepare do
  require_dependency File.expand_path('../app/helpers/favorites_helper', __dir__)
  ActionView::Base.include ::FavoritesHelper
end

# Hooks
require_relative 'redmine_favorites/hooks/view_projects_show_right_hook'
