class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])

    @comment = @post.comments.new(comment_params)

    @user = User.find_by username: "Test"
    @comment.creator = @user

    if @comment.save
      flash[:notice] = "Your comment was added."
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
