module TestResponses
  def self.sample_wot_user(clan_id)
    total =  {
      "1001261893" => {
        "updated_at" => 1389073280,
        "achievements" => {},
        "ratings" => {},
        "name" => 'articblast',
        "vehicles" => {},
        "battles" => {
          "spotted" => 1000,
          "frags" => 1500,
          "damage_dealt" => 1000000,
          "hits_percents" => 55,
          "capture_points" => 5000,
          "dropped_capture_points" => 6000
        },
        "summary" => {
          "battles_count" => 3000,
          "wins" => 1500,
          "losses" => 1000,
          "survived_battles" => 450
        },
        "experience" => {
          "xp" => 1500000,
          "max_xp" => 1000
        },
        "clan" => {
          "role" => "recruiter",
          "clan_id" => clan_id
        }}}
  end
end