class ClubAdminsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  # GET /club_admins/new?club_id=:club_id
  #
  # Presents an interface to add a new administrator to the club
  #
  # @param [Integer] club_id Identifier of the club for which the administrator will be created
  def new
    @club = Club.find params[:club_id]

    authorize! :update, @club

    respond_to do |format|
      format.html{ render 'club_admins/_new', layout: false }
    end
  end

  # POST /club_admins
  # Adds a new administrator to the club
  #
  # @param [Integer] club_id Identifier of the club to be updated
  # @param [Integer] user_id Identifier of the user that's going to be added as administrator
  def create
    membership = UserClub.find_by(user: @club_admin.user, club: @club_admin.club)

    if membership.nil?
      redirect_params = { alert: t('club.errors.admin_must_be_member') }
    else
      if @club_admin.save
        membership.destroy
        redirect_params = { notice: t('club.admin_create_success') }
      else
        redirect_params = { alert: t('club.errors.admin_not_added') }
      end
    end

    redirect_to club_path(@club_admin.club), redirect_params
  end

  # GET /club_admins/:id/confirm_destroy
  #
  # Shows a confirmation dialog that allows the removal of an administrator from a club
  #
  # @param [Integer] id Identifier of the relationship to destroy
  def confirm_destroy
    respond_to do |format|
      format.html{ render 'club_admins/_confirm_destroy', layout: false }
    end
  end

  private

  # Returns sanitized parameters for the create action
  def create_params
    params.require(:club_admin).permit(:club_id, :user_id)
  end
end
