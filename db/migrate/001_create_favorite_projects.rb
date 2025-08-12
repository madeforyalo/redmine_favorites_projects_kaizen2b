# frozen_string_literal: true

class CreateFavoriteProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_projects do |t|
      t.integer :user_id,    null: false
      t.integer :project_id, null: false
      t.timestamps null: false
    end

    add_index :favorite_projects, [:user_id, :project_id], unique: true
    add_index :favorite_projects, :project_id
  end
end