class SettingsController < ApplicationController
  layout "application"
  before_action :verify_is_logged_in
  before_action :set_setting, only: %i[ edit update ]

  # GET /settings/edit
  def edit
  end

  # PATCH/PUT /settings or /settings.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to edit_settings_path, notice: "Einstellungen aktualisiert." }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first()
    end

    # Only allow a list of trusted parameters through.
    def setting_params
      params.require(:setting).permit(:showArticlesForDays)
    end
end
