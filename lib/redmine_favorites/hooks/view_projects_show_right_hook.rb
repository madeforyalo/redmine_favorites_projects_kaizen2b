# frozen_string_literal: true

module RedmineFavorites
  module Hooks
    class ViewProjectsShowRightHook < Redmine::Hook::ViewListener
      # Inserta el botón en la vista del proyecto (columna derecha)
      render_on :view_projects_show_right,
                partial: 'redmine_favorites_kaizen2b/favorite_button'
    end
  end
end
