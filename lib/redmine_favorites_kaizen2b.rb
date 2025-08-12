# frozen_string_literal: true

require 'redmine'

# Constante para zeitwerk
module RedmineFavoritesKaizen2b
end

# Cargar el helper y mezclarlo en ActionView
helper_path = Rails.root.join(
  'plugins', 'redmine_favorites_projects_kaizen2b', 'app', 'helpers', 'favorites_helper'
).to_s

Rails.configuration.to_prepare do
  require_dependency helper_path

  if defined?(ActionView::Base) && !ActionView::Base.included_modules.include?(::FavoritesHelper)
    ActionView::Base.include ::FavoritesHelper
  end
end

ActiveSupport.on_load(:action_view) do
  require_dependency helper_path
  include ::FavoritesHelper unless included_modules.include?(::FavoritesHelper)
end

# Hooks
require_relative 'redmine_favorites/hooks/view_projects_show_right_hook'
require_relative 'redmine_favorites/hooks/view_layouts_base_hook'