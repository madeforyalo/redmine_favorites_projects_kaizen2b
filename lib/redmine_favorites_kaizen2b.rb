# frozen_string_literal: true

require 'redmine'

# Definimos el módulo para satisfacer a Zeitwerk
module RedmineFavoritesKaizen2b
end

# Cargar hooks
require_relative 'redmine_favorites/hooks/view_projects_show_right_hook'
