# frozen_string_literal: true

module RedmineFavorites
  module Hooks
    class ViewLayoutsBaseHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(_context = {})
        javascript_include_tag('redmine_favorites', plugin: 'redmine_favorites_projects_kaizen2b') +
          stylesheet_link_tag('redmine_favorites', plugin: 'redmine_favorites_projects_kaizen2b')
      end
    end
  end
end
