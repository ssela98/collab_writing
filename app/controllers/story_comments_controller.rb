class StoryCommentsController < ApplicationController
  before_action :set_story_comment, only: %i[ show edit update destroy ]

  # GET /story_comments or /story_comments.json
  def index
    @story_comments = StoryComment.all
  end

  # GET /story_comments/1 or /story_comments/1.json
  def show
  end

  # GET /story_comments/new
  def new
    @story_comment = StoryComment.new
  end

  # GET /story_comments/1/edit
  def edit
  end

  # POST /story_comments or /story_comments.json
  def create
    @story_comment = StoryComment.new(story_comment_params)

    respond_to do |format|
      if @story_comment.save
        format.html { redirect_to @story_comment.story, notice: "Story comment was successfully created." }
        format.json { render :show, status: :created, location: @story_comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_comments/1 or /story_comments/1.json
  def update
    respond_to do |format|
      if @story_comment.update(story_comment_params)
        format.html { redirect_to story_comment_url(@story_comment), notice: "Story comment was successfully updated." }
        format.json { render :show, status: :ok, location: @story_comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_comments/1 or /story_comments/1.json
  def destroy
    @story_comment.destroy

    respond_to do |format|
      format.html { redirect_to story_comments_url, notice: "Story comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_comment
      @story_comment = StoryComment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def story_comment_params
      params.require(:story_comment).permit(:story_id, :comment_id)
    end
end
