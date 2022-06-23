class RegisteredsController < ApplicationController

  before_action :check_authorized
  before_action :load_prereg, only: [:edit, :update, :destroy]
  before_action :redirect_cancel, only: [:update]

  def index
    q = EcRegistration.includes(:name_meta, :vekn_meta, :country_meta)
    @query = params[:query]
    if @query.present?
      q = q.where("name LIKE ?", "%#{@query}%")
    end
    @preregs = q.order(:name).page params[:page]

    if turbo_frame_request?
      render partial: "ec_registrations", locals: { preregs: @preregs, query: @query }
    else
      @prereg_count = EcRegistration.count
      render :index
    end
  end

  def edit
    @page = params[:page] # remember page we came from, if any, store in hidden field
  end

  def update
    oldvalues = @prereg.changelog_text
    respond_to do |format|
      @prereg.assign_attributes(prereg_params)
      changed = @prereg.any_changed?
      if @prereg.save
        Changelog.create(change_type: :edit, player_type: :prereg, row_id: @prereg.id,
                         oldvalues: oldvalues, newvalues: @prereg.changelog_text) if changed
        format.html do
          flash.notice = "Updated #{@prereg.identifier}" if changed
          redirect_to registereds_path(page: params[:page])
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    row_id = @prereg.id
    ident = @prereg.identifier
    oldvalues = @prereg.changelog_text
    @prereg.destroy
    Changelog.create(change_type: :remove, player_type: :prereg, row_id: row_id, oldvalues: oldvalues)
    respond_to do |format|
      format.html { redirect_to registereds_path(page: params[:page]), notice: "Deleted #{ident}" }
    end
  end

  private

  def load_prereg
    @prereg = EcRegistration.find(params[:id])
  end

  def prereg_params
    params.require(:ec_registration).permit(:name, :vekn, :country)
  end

  def redirect_cancel
    redirect_to registereds_path if params[:cancel]
  end

end
