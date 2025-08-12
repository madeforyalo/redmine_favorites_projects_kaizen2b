# frozen_string_literal: true

require 'redmine'

# Constante que coincide con el nombre del archivo lib/redmine_favorites_kaizen2b.rb
module RedmineFavoritesKaizen2b
end

# Cargamos el hook (ruta → namespace RedmineFavorites::Hooks)
require_relative 'redmine_favorites/hooks/view_projects_show_right_hook'
