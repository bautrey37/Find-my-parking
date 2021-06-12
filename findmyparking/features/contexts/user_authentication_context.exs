defmodule UserAuthenticationContext do
  use WhiteBread.Context
  use Hound.Helpers

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end
  scenario_starting_state fn _state ->
    Hound.start_session
    %{}
  end
  scenario_finalize fn _status, _state ->
    Hound.end_session
  end


  #######################################
  ## Background
  given_ ~r/^I log in to the system as "(?<usrname>[^"]+)" and "(?<pw>[^"]+)"$/,
  fn state, %{usrname: usrname, pw: pw} ->
    {:ok, state |> Map.put(:usrname, usrname) |> Map.put(:pw, pw)}
  end

  when_ ~r/^I enter the user credentials$/, fn state ->
    navigate_to "/sessions/new"
    fill_field({:id, "username"}, state[:usrname])
    fill_field({:id, "password"}, state[:pw])
    {:ok, state}
  end

  and_ ~r/^I submit the credentials$/, fn state ->
    click({:id, "submit_button"})
    {:ok, state}
  end

  then_ ~r/^I should see a welcome message$/, fn state ->
    assert visible_in_page? ~r/Hello shaggy/
    {:ok, state}
  end

  #######################################
  ## User Authentication Feature Step Definitions
  given_ ~r/^I have the login credentials $/, fn state ->
    {:ok, state}
  end

  when_ "I click on the log in button on the main page", fn state ->
    navigate_to "/sessions/new"
    {:ok, state}
  end

  and_ "I enter my credentials", fn state ->
    fill_field({:id, "username"}, "scoob")
    fill_field({:id, "password"}, "parool")
    {:ok, state}
  end

  and_ "I click on the submit button", fn state ->
    click({:id, "submit_button"})
    {:ok, state}
  end

  then_ "I should see the message \"Welcome scoob\"", fn state ->
    assert visible_in_page? ~r/Welcome scoob/
    {:ok, state}
  end

end
