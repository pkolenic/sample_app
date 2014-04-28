class PromotionsController < ApplicationController
  before_action :authorized_user

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])
    @promotion = promotion_params
    role = @promotion[:role_id]
    reason = @promotion[:reason]
    
    if @user.role < role.to_i  #Promotion
      if @user.update_attribute(:role, role)
        UserMailer.promoted(@user, user_role(role), reason).deliver
        flash[:success] = "#{@user.wot_name} has been promoted."
        redirect_to users_path
      else
        flash[:error] = "Unable to promote #{@user.wot_name}."
        render 'edit'
      end      
    else
      if !reason.empty? && @user.update_attribute(:role, role)
        UserMailer.demoted(@user, user_role(role), reason).deliver
        flash[:success] = "#{@user.wot_name} has been demoted."
        redirect_to users_path
      else
        flash[:error] = "Unable to demote #{@user.wot_name}, missing a reason"
        render 'edit'
      end
    end

  end

  private
    def user_role(role_id)
      case role_id.to_i
      when UserRecruit
        role = 'Recruit'
      when UserSoldier
        role = 'Soldier'
      when UserTreasurer
        role = 'Treasurer'
      when UserRecruiter
        role = 'Recruiter'
      when UserDiplomat
        role = 'Diplomat'
      when UserCompanyCommander
        role = 'Company Commander'
      when UserDeputyCommander
        role = 'Deputy Commander'
      when UserCommander
        role = 'Commander'
      else
      role = 'Recruit'
      end
      role
    end
  
    def promotion_params
      params.require(:promotion).permit(:role_id, :reason)
    end

    # Before filters
    def authorized_user
      redirect_to(users_url) unless current_user.role >= UserCompanyCommander
    end
end
