# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include Commentable

    skip_before_action :authenticate_user!, only: %i[show]

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
  end
end
