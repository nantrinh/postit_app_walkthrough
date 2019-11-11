class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])

    @comment = @post.comments.new(comment_params)

    @user = current_user
    @comment.creator = @user

    if @comment.save
      flash[:notice] = 'Your comment was added.'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
    redirect_back fallback_location: root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
