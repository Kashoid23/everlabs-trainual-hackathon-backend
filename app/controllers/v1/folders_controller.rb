class V1::FoldersController < ApplicationController
  def index
    return render json: Folder.all if params[:all].present?

    render json: Folder.joins(:audios).group("folders.id").select("folders.*, count(audios.id) as audios_count")
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
