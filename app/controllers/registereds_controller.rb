require "csv"

class RegisteredsController < ApplicationController

  before_action :check_authorized
  before_action :load_prereg, only: [:edit, :update, :destroy]
  before_action :redirect_cancel, only: [:update]

  def index
    @query = params[:query]
    q = EcRegistration.includes(:name_meta, :vekn_meta, :country_meta)

    respond_to do |format|

      format.html do
        if @query.present?
          q = q.joins(:vekn_meta).where("wp_frm_item_metas.meta_value LIKE ?", "%#{@query}%")
               .or(EcRegistration.where("name LIKE ?", "%#{@query}%"))
        end
        @preregs = q.order(:name).page params[:page]

        if turbo_frame_request?
          render partial: "ec_registrations", locals: { preregs: @preregs, query: @query }
        else
          @prereg_count = EcRegistration.count
        end
      end

      format.csv do
        csv_string = CSV.generate do |csv|
          csv << %w[Name VEKN Country]
          q.order(:name).each do |r|
            csv << [r.name, r.vekn, r.country]
          end
        end
        filename = Time.now.strftime("preregistered-%Y-%m-%d.csv")
        send_data csv_string, filename: filename, type: "text/csv"
      end

    end
  end

  def edit
    @page = params[:page]
    @query = params[:query]
  end

  def update
    oldvalues = @prereg.changelog_text
    @prereg.assign_attributes(prereg_params)
    changed = @prereg.changelog_text != oldvalues
    if @prereg.save
      Changelog.create(change_type: :edit, player_type: :prereg, row_id: @prereg.id,
        oldvalues: oldvalues, newvalues: @prereg.changelog_text) if changed
      redirect_to registereds_path(page: params[:page], query: params[:query])
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    row_id = @prereg.id
    ident = @prereg.identifier
    oldvalues = @prereg.changelog_text
    @prereg.destroy
    Changelog.create(change_type: :remove, player_type: :prereg, row_id: row_id, oldvalues: oldvalues)
    redirect_to registereds_path, alert: "Deleted #{ident}"
  end

  private

  def load_prereg
    @prereg = EcRegistration.find(params[:id])
  end

  def prereg_params
    params.require(:ec_registration).permit(:name, :vekn, :country)
  end

  def redirect_cancel
    redirect_to registereds_path(page: params[:page], query: params[:query]) if params[:cancel]
  end

end
