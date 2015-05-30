class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :confirm_destroy, to: :destroy

    ###################################################
    ################## CLUBS ##########################
    ###################################################
    can :create, Club

    can :read, Club do |club|
      user.clubs.where{ id == my{club.id} }.any? || user.administrated_clubs.where{ id == my{club.id} }.any?
    end

    can :update, Club do |club|
      user.administrated_clubs.where{ id == my{club.id} }.any?
    end

    ###################################################
    ################## CLUB ADMINS ####################
    ###################################################
    can :create, ClubAdmin do |club_admin|
      can? :update, club_admin.club
    end

    can :destroy, ClubAdmin do |club_admin|
      can? :update, club_admin.club
    end

    ###################################################
    ################## PLAYERS ########################
    ###################################################
    can :new, Player

    can :create, Player do |player|
      can? :update, player.team
    end

    can :destroy, Player do |player|
      can? :update, player.team
    end

    ###################################################
    ################## TEAMS ##########################
    ###################################################
    alias_action :add_player, to: :update

    can :new, Team

    can :create, Team do |team|
      can? :update, team.club
    end

    can :read, Team do |team|
      user.players.where{ team_id == my{team.id} }.any? ||
      user.administrated_clubs.joins{ teams }.where{ teams.id == my{team.id} }.any?
    end

    can :update, Team do |team|
      can? :update, team.club
    end

    can :destroy, Team do |team|
      can? :update, team.club
    end

    ###################################################
    ################## USER CLUBS #####################
    ###################################################
    can :destroy, UserClub do |user_club|
      can? :update, user_club.club
    end

    ###################################################
    ####################### USERS #####################
    ###################################################
    can :read, User do |authorized_user|
      user == authorized_user
    end
  end
end
