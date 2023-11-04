class V1::FoldersController < ApplicationController
  def index
    render json: Folder.all
  end

  def create
    folder = Folder.new(folder_params)

    if folder.save
      render json: folder
    else
      render json: folder.errors
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name)
  end
end
