# frozen_string_literal: true

require_relative 'lib/redmine_favorites_kaizen2b'

Redmine::Plugin.register :redmine_favorite_projects_kaizen2b do
  name        'Favorites projects'
  author      'Kaizen2B - Gonzalo Rojas'
  description 'Permite a cada usuario marcar proyectos como favoritos y accederlos rápido.'
  version     '0.1.0'
  url         'https://kaizen2b.com'
  author_url  'https://kaizen2b.com'

  # Permiso global (no por proyecto): requiere usuario logueado
  requires_redmine version_or_higher: '5.0.0'

  # Menú superior
  menu :top_menu, :favorite_projects,
       { controller: 'favorites', action: 'index' },
       caption: :label_favorite_projects,
       if: proc { User.current.logged? }

end