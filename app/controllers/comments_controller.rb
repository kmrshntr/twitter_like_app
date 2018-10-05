class CommentsController < ApplicationController
	before_action :logged_in_user, only:[:create, :destroy]
	before_action :correct_user, only: :destroy
	
	def create
		@micropost = Micropost.find(params[:micropost_id])
		@comment = @micropost.comment(params[:comment][:content], current_user)
		if @comment.save
			respond_to do |format|
				format.html { redirect_to micropost_path(@micropost) }
				format.js
			end
		else
			@comments = @micropost.comments.all
			render 'microposts/show'
		end
	end

	def destroy
		@comment.destroy
		redirect_to micropost_path(params[:micropost_id])
	end

	private
		def correct_user
			@comment = current_user.comments.find_by(id: params[:id])
			redirect_to root_url if @comment.nil?
		end
end
