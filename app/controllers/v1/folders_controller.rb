class V1::FoldersController < ApplicationController
  def index
    render json: Folder.left_joins(:audios).group("folders.id").select("folders.*, count(audios.id) as audios_count")
  end

  def create
    folder = Folder.new(name: params[:name])

    if folder.save
      render json: folder
    else
      render json: folder.errors
    end
  end
end
