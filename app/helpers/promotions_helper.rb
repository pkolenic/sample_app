module PromotionsHelper
  def promotion_choices(leaders_role, tanker_role)
    a = [['Recruit', UserRecruit]];
    case leaders_role
    when UserCompanyCommander
      a.push(['Soldier', UserSoldier])
    when UserDeputyCommander
      a.push(['Soldier', UserSoldier])
      a.push(['Treasurer', UserTreasurer])
      a.push(['Recruiter', UserRecruiter])
      a.push(['Diplomat', UserDiplomat])
      a.push(['Company Commander',UserCompanyCommander])
    when UserCommander
      a.push(['Soldier', UserSoldier])
      a.push(['Treasurer', UserTreasurer])
      a.push(['Recruiter', UserRecruiter])
      a.push(['Diplomat', UserDiplomat])
      a.push(['Company Commander',UserCompanyCommander])
      a.push(['Deputy Commander', UserDeputyCommander])
    when UserSuper
      a.push(['Commander', UserCommander])
    end

    current_role = [user_role(tanker_role), tanker_role]
    a.delete(current_role)
    @roles = a
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
end
