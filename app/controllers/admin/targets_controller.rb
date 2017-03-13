module Admin
  class TargetsController < Admin::BaseController
    load_and_authorize_resource :conference, find_by: :short_title
    load_and_authorize_resource :target, through: :conference

    def index; end

    def new
      @target = @conference.targets.new
    end

    def create
      @target = @conference.targets.new(target_params)
      respond_to do |format|
        if @target.save
          flash[:notice] = 'Target successfully created.'
        else
          flash[:error] = "Creating target failed: #{@room.errors.full_messages.join('. ')}."
        end
        format.js{ render 'message' }
      end
    end

    def edit; end

    def update
      if @target.update_attributes(target_params)
        redirect_to admin_conference_targets_path(conference_id: @conference.short_title),
                    notice: 'Target successfully updated.'
      else
        flash[:error] = "Target update failed: #{@target.errors.full_messages.join('. ')}."
        render :edit
      end
    end

    def destroy
      if @target.destroy
        redirect_to admin_conference_targets_path(conference_id: @conference.short_title),
                    notice: 'Target successfully destroyed.'
      else
        redirect_to admin_conference_targets_path(conference_id: @conference.short_title),
                    error: "Could not delete target for #{@conference.title}: "\
                    "#{@target.errors.full_messages.join('. ')}."
      end
    end

    private

    def target_params
      params.require(:target).permit(:due_date, :target_count, :unit, :conference_id)
    end
  end
end
