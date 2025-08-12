# frozen_string_literal: true

# Cargamos la inicialización del plugin (y definimos el módulo)
require_relative 'lib/redmine_favorites_kaizen2b'

Redmine::Plugin.register :redmine_favorites_projects_kaizen2b do
  name        'Favorites Projects (Kaizen2B)'
  author      'Kaizen2B - Gonzalo Rojas'
  description 'Permite a cada usuario marcar proyectos como favoritos y accederlos rápido.'
  version     '0.1.0'
  url         'https://github.com/madeforyalo/redmine_favorites_projects_kaizen2b'
  author_url  'https://github.com/madeforyalo/redmine_favorites_projects_kaizen2b'
  requires_redmine version_or_higher: '6.0.0'

  # Menú superior opcional
  menu :top_menu, :favorite_projects,
       { controller: 'favorites', action: 'index' },
       caption: :label_favorite_projects,
       if: proc { User.current.logged? }
end
