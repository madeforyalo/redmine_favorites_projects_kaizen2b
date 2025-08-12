# frozen_string_literal: true

require 'redmine'

# Constante para zeitwerk
module RedmineFavoritesKaizen2b
end

# Incluir el helper en TODAS las vistas
Rails.configuration.to_prepare do
  require_dependency Rails.root.join(
    'plugins', 'redmine_favorites_projects_kaizen2b', 'app', 'helpers', 'favorites_helper'
  ).to_s

  # Hace disponibles los métodos de FavoritesHelper en todas las vistas
  ApplicationController.helper ::FavoritesHelper
end

# Hooks
require_relative 'redmine_favorites/hooks/view_projects_show_right_hook'
