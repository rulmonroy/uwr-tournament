// Dismiss the modal
$('.modal').modal('hide')

// First, find the player that scored and mark the goal
players_goals = $('#goals-<%= @player.id %>')
players_goals.text(+players_goals.text() + 1)

// Now increment the teams mark
if (<%= @player.team_id %> === <%= @game.blue_team_id %>)
{
  selector = '.js-blue-goals'
}
else
{
  selector = '.js-white-goals'
}

teams_score = $(selector)
teams_score.text(+(teams_score.text()) + 1)
