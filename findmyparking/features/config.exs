defmodule WhiteBreadConfig do
  use WhiteBread.SuiteConfiguration

  # suite name:          "All",
  #       context:       UserAuthenticationContext,
  #       feature_paths: ["features/"]

  suite name:          "User Authentication",
  context:       UserAuthenticationContext,
  feature_paths: ["features/user_authentication"]

end
