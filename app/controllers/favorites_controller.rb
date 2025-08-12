# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :require_login
  respond_to :html, :json

  def index
    @projects = Project.active.joins("INNER JOIN favorite_projects fp ON fp.project_id = projects.id")
                       .where('fp.user_id = ?', User.current.id)
                       .order('projects.name')

    respond_to do |format|
      format.html
      format.json do
        render json: {
          project_ids: @projects.pluck(:id),
          project_identifiers: @projects.pluck(:identifier)
        }
      end
    end
  end

  # POST /favorites/toggle(.json)
  # Params: project_id OR project_identifier
  def toggle
    project = find_project_from_params!

    fav = FavoriteProject.find_by(user_id: User.current.id, project_id: project.id)
    favourited = false

    if fav
      fav.destroy
      flash[:notice] = l(:notice_project_unfavourited)
    else
      FavoriteProject.create!(user_id: User.current.id, project_id: project.id)
      favourited = true
      flash[:notice] = l(:notice_project_favourited)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: project_path(project)) }
      format.json do
        render json: {
          favourited: favourited,
          project_id: project.id,
          project_identifier: project.identifier
        }
      end
    end
  end

  private

  def find_project_from_params!
    if params[:project_id].present?
      Project.find(params[:project_id])
    elsif params[:project_identifier].present?
      Project.find_by!(identifier: params[:project_identifier])
    else
      raise ActiveRecord::RecordNotFound, 'project param missing'
    end
  end
end
