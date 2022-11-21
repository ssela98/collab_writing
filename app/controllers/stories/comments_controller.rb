# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    before_action :authenticate_user!, except: %i[show]
    before_action :set_commentable, only: %i[ show edit create update destroy ]

    # GET /comments or /comments.json
    def index
      @comments = Comment.all
    end

    # GET /comments/1 or /comments/1.json
    def show
    end

    # GET /comments/new
    def new
      @comment = Comment.new
    end

    # GET /comments/1/edit
    def edit
    end

    # POST /comments or /comments.json
    def create
      @comment = @commentable.comments.new(comment_params.merge(user: current_user))

      respond_to do |format|
        if @comment.save
          format.html { redirect_to story_url(@commentable), notice: "Comment was successfully created." }
          format.json { render @comment, status: :created, location: story_url(@commentable) }
        else
          format.html { redirect_to @commentable, status: :unprocessable_entity }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /comments/1 or /comments/1.json
    def update
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /comments/1 or /comments/1.json
    def destroy
      @comment.destroy

      respond_to do |format|
        format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_commentable
      @commentable = Story.find(params[:story_id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :parent_id)
    end
  end
end
