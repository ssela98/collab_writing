# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include ActionView::RecordIdentifier
    include RecordHelper

    before_action :authenticate_user!, except: %i[show]
    before_action :set_comment, except: %i[new]
    before_action :set_commentable

    # GET /comments/1 or /comments/1.json
    def show; end

    # GET /comments/new
    def new
      @comment = Comment.new
    end

    # GET /comments/1/edit
    def edit; end

    # POST /stories/:id/comments or /stories/:id/comments.json
    def create
      @comment = @commentable.comments.new(comment_params.merge(user: current_user))

      respond_to do |format|
        if @comment.save
          comment = Comment.new

          format.html { redirect_to @commentable }
          format.turbo_stream {
            flash.now[:notice] = I18n.t('comments.notices.successfully_created')
            render 'comments/create', comment: comment, commentable: @commentable
          }
        else
          format.html { redirect_to @commentable, status: :unprocessable_entity }
          format.turbo_stream {
            flash.now[:alert] = I18n.t('comments.errors.failed_to_create')
            render 'comments/create', comment: @comment, commentable: @commentable, status: :unprocessable_entity
          }
        end
      end
    end

    # PATCH/PUT /comments/1 or /comments/1.json
    def update
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to comment_url(@comment), notice: I18n.t('comments.notices.successfully_updated') }
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
        format.html { redirect_to comments_url, notice: I18n.t('comments.notices.successfully_destroyed') }
        format.json { head :no_content }
      end
    end

    private

    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end

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
