class LikesController < ApplicationController
	before_action :logged_in_user

	def create
		@micropost = Micropost.find(params[:micropost_id])
		@micropost.like(current_user)
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end

	def destroy
		#@micropost = Micropost.find(params[:micropost_id])これではだめ？
		@micropost = Like.find(params[:id]).micropost
		@micropost.unlike(current_user)
		respond_to do |format|
			format.html { redirect_to root_url }
			format.js
		end
	end
	
end
