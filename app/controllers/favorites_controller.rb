# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :require_login

  def index
    @projects = Project.active.joins("INNER JOIN favorite_projects fp ON fp.project_id = projects.id")
                       .where('fp.user_id = ?', User.current.id)
                       .order('projects.name')
  end

  # POST /favorites/toggle?project_id=ID
  def toggle
    project = Project.find(params[:project_id])

    fav = FavoriteProject.find_by(user_id: User.current.id, project_id: project.id)
    if fav
      fav.destroy
      flash[:notice] = l(:notice_project_unfavourited)
    else
      FavoriteProject.create!(user_id: User.current.id, project_id: project.id)
      flash[:notice] = l(:notice_project_favourited)
    end

    redirect_back(fallback_location: project_path(project))
  end

  # Compat: no usamos create/destroy directos, pero quedan por si se requieren
  def create
    toggle
  end

  def destroy
    toggle
  end
end