class V1::FoldersController < ApplicationController
  def index
    render json: Folder.all
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
