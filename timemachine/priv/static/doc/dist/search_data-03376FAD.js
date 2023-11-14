searchData={"items":[{"type":"module","title":"Timemachine","doc":"Timemachine keeps the contexts that define your domain\r\nand business logic.\r\n\r\nContexts are also responsible for managing your data, regardless\r\nif it comes from the database, an external API or others.","ref":"Timemachine.html"},{"type":"module","title":"Timemachine.Data","doc":"The Data context.","ref":"Timemachine.Data.html"},{"type":"function","title":"Timemachine.Data.clock_create/2","doc":"Creates a clock for the given `user_id`. `attrs` should contains `\"status\"` and `\"time\"`.","ref":"Timemachine.Data.html#clock_create/2"},{"type":"function","title":"Timemachine.Data.clock_get_last_by_user_id/1","doc":"Returns the last clock made by the user `user_id`.","ref":"Timemachine.Data.html#clock_get_last_by_user_id/1"},{"type":"function","title":"Timemachine.Data.clock_list_by_user_id/1","doc":"Returns all clocks made by the user `user_id`.","ref":"Timemachine.Data.html#clock_list_by_user_id/1"},{"type":"function","title":"Timemachine.Data.team_create/1","doc":"Creates a new team. `attrs` should contain `\"name\"`.","ref":"Timemachine.Data.html#team_create/1"},{"type":"function","title":"Timemachine.Data.team_delete/1","doc":"Deletes the given team.","ref":"Timemachine.Data.html#team_delete/1"},{"type":"function","title":"Timemachine.Data.team_get/1","doc":"Returns the team with the same `id`.","ref":"Timemachine.Data.html#team_get/1"},{"type":"function","title":"Timemachine.Data.team_list/0","doc":"Returns all teams.","ref":"Timemachine.Data.html#team_list/0"},{"type":"function","title":"Timemachine.Data.team_update/2","doc":"Edits the team with the given `attrs`. `attrs` can contain `\"name\"`.","ref":"Timemachine.Data.html#team_update/2"},{"type":"function","title":"Timemachine.Data.user_create/1","doc":"Creates a new user. `attrs` should contain `\"username\"`, `\"email\"`, `\"password\"` and a optional `\"role\"`.","ref":"Timemachine.Data.html#user_create/1"},{"type":"function","title":"Timemachine.Data.user_delete/1","doc":"Deletes the given user.","ref":"Timemachine.Data.html#user_delete/1"},{"type":"function","title":"Timemachine.Data.user_get/1","doc":"Returns the team with the same `id`.","ref":"Timemachine.Data.html#user_get/1"},{"type":"function","title":"Timemachine.Data.user_search/1","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#user_search/1"},{"type":"function","title":"Timemachine.Data.user_try_login/1","doc":"Tries to authenticate the user. `credentials` is a `Map` with keys `\"username\"` and `\"password\"`.","ref":"Timemachine.Data.html#user_try_login/1"},{"type":"function","title":"Timemachine.Data.user_try_login/2","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#user_try_login/2"},{"type":"function","title":"Timemachine.Data.user_update/2","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#user_update/2"},{"type":"function","title":"Timemachine.Data.userteam_create/2","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#userteam_create/2"},{"type":"function","title":"Timemachine.Data.userteam_delete/2","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#userteam_delete/2"},{"type":"function","title":"Timemachine.Data.workingtime_create/2","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#workingtime_create/2"},{"type":"function","title":"Timemachine.Data.workingtime_delete/1","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#workingtime_delete/1"},{"type":"function","title":"Timemachine.Data.workingtime_generate/2","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#workingtime_generate/2"},{"type":"function","title":"Timemachine.Data.workingtime_get/1","doc":"Returns the workingtime with the same `id`.","ref":"Timemachine.Data.html#workingtime_get/1"},{"type":"function","title":"Timemachine.Data.workingtime_list/0","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#workingtime_list/0"},{"type":"function","title":"Timemachine.Data.workingtime_search/3","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#workingtime_search/3"},{"type":"function","title":"Timemachine.Data.workingtime_update/2","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Data.html#workingtime_update/2"},{"type":"module","title":"Timemachine.Data.Clock","doc":"","ref":"Timemachine.Data.Clock.html"},{"type":"module","title":"Timemachine.Data.Team","doc":"","ref":"Timemachine.Data.Team.html"},{"type":"module","title":"Timemachine.Data.User","doc":"","ref":"Timemachine.Data.User.html"},{"type":"function","title":"Timemachine.Data.User.clean/1","doc":"","ref":"Timemachine.Data.User.html#clean/1"},{"type":"function","title":"Timemachine.Data.User.default_role/0","doc":"When creating a user, the `:role` field uses the default value if no role is specified or the specified role does not exist.","ref":"Timemachine.Data.User.html#default_role/0"},{"type":"module","title":"Timemachine.Data.UserTeam","doc":"","ref":"Timemachine.Data.UserTeam.html"},{"type":"module","title":"Timemachine.Data.Workingtime","doc":"","ref":"Timemachine.Data.Workingtime.html"},{"type":"module","title":"Timemachine.Tokens.Bearer","doc":"","ref":"Timemachine.Tokens.Bearer.html"},{"type":"function","title":"Timemachine.Tokens.Bearer.generate_and_sign/2","doc":"Combines `generate_claims/1` and `encode_and_sign/2`","ref":"Timemachine.Tokens.Bearer.html#generate_and_sign/2"},{"type":"function","title":"Timemachine.Tokens.Bearer.generate_and_sign!/2","doc":"Same as `generate_and_sign/2` but raises if error","ref":"Timemachine.Tokens.Bearer.html#generate_and_sign!/2"},{"type":"function","title":"Timemachine.Tokens.Bearer.get_current_user_id/1","doc":"Returns the `id` of the current `user`. It is extracted from the bearer.","ref":"Timemachine.Tokens.Bearer.html#get_current_user_id/1"},{"type":"function","title":"Timemachine.Tokens.Bearer.get_from_conn/1","doc":"Returns the bearer token from a `conn` by reading `authorization` header.","ref":"Timemachine.Tokens.Bearer.html#get_from_conn/1"},{"type":"function","title":"Timemachine.Tokens.Bearer.verify_and_validate/3","doc":"Combines `verify/2` and `validate/2`","ref":"Timemachine.Tokens.Bearer.html#verify_and_validate/3"},{"type":"function","title":"Timemachine.Tokens.Bearer.verify_and_validate!/3","doc":"Same as `verify_and_validate/2` but raises if error","ref":"Timemachine.Tokens.Bearer.html#verify_and_validate!/3"},{"type":"module","title":"Timemachine.Tokens.CSRF","doc":"","ref":"Timemachine.Tokens.CSRF.html"},{"type":"function","title":"Timemachine.Tokens.CSRF.authorized?/2","doc":"Checks if the given CSRF token matches the stored one for this `user_id`.","ref":"Timemachine.Tokens.CSRF.html#authorized?/2"},{"type":"function","title":"Timemachine.Tokens.CSRF.delete/1","doc":"Deletes the CSRF token stored for the given `user_id`.","ref":"Timemachine.Tokens.CSRF.html#delete/1"},{"type":"function","title":"Timemachine.Tokens.CSRF.generate/1","doc":"Generates a new CSRF token for the given `user_id`. Use `get(user_id)` to get the token.","ref":"Timemachine.Tokens.CSRF.html#generate/1"},{"type":"function","title":"Timemachine.Tokens.CSRF.get/1","doc":"Returns the CSRF token stored for the given `user_id`.","ref":"Timemachine.Tokens.CSRF.html#get/1"},{"type":"function","title":"Timemachine.Tokens.CSRF.get_from_conn/1","doc":"Returns the CSRF token from a `conn` by reading `x-csrf-token` header.","ref":"Timemachine.Tokens.CSRF.html#get_from_conn/1"},{"type":"module","title":"TimemachineWeb.ClockController","doc":"","ref":"TimemachineWeb.ClockController.html"},{"type":"function","title":"TimemachineWeb.ClockController.create/2","doc":"","ref":"TimemachineWeb.ClockController.html#create/2"},{"type":"function","title":"TimemachineWeb.ClockController.create_for_team/2","doc":"","ref":"TimemachineWeb.ClockController.html#create_for_team/2"},{"type":"function","title":"TimemachineWeb.ClockController.get_by_team/2","doc":"","ref":"TimemachineWeb.ClockController.html#get_by_team/2"},{"type":"function","title":"TimemachineWeb.ClockController.index/2","doc":"","ref":"TimemachineWeb.ClockController.html#index/2"},{"type":"module","title":"TimemachineWeb.Plugs.BearerValidate","doc":"","ref":"TimemachineWeb.Plugs.BearerValidate.html"},{"type":"function","title":"TimemachineWeb.Plugs.BearerValidate.call/2","doc":"","ref":"TimemachineWeb.Plugs.BearerValidate.html#call/2"},{"type":"function","title":"TimemachineWeb.Plugs.BearerValidate.init/1","doc":"","ref":"TimemachineWeb.Plugs.BearerValidate.html#init/1"},{"type":"module","title":"TimemachineWeb.Plugs.CSRFValidate","doc":"","ref":"TimemachineWeb.Plugs.CSRFValidate.html"},{"type":"function","title":"TimemachineWeb.Plugs.CSRFValidate.call/2","doc":"","ref":"TimemachineWeb.Plugs.CSRFValidate.html#call/2"},{"type":"function","title":"TimemachineWeb.Plugs.CSRFValidate.init/1","doc":"","ref":"TimemachineWeb.Plugs.CSRFValidate.html#init/1"},{"type":"module","title":"TimemachineWeb.Router","doc":"","ref":"TimemachineWeb.Router.html"},{"type":"function","title":"TimemachineWeb.Router.api/2","doc":"","ref":"TimemachineWeb.Router.html#api/2"},{"type":"function","title":"TimemachineWeb.Router.auth/2","doc":"","ref":"TimemachineWeb.Router.html#auth/2"},{"type":"function","title":"TimemachineWeb.Router.browser/2","doc":"","ref":"TimemachineWeb.Router.html#browser/2"},{"type":"function","title":"TimemachineWeb.Router.call/2","doc":"Callback invoked by Plug on every request.","ref":"TimemachineWeb.Router.html#call/2"},{"type":"function","title":"TimemachineWeb.Router.init/1","doc":"Callback required by Plug that initializes the router\nfor serving web requests.","ref":"TimemachineWeb.Router.html#init/1"},{"type":"module","title":"TimemachineWeb.TeamController","doc":"","ref":"TimemachineWeb.TeamController.html"},{"type":"function","title":"TimemachineWeb.TeamController.create/2","doc":"","ref":"TimemachineWeb.TeamController.html#create/2"},{"type":"function","title":"TimemachineWeb.TeamController.delete/2","doc":"","ref":"TimemachineWeb.TeamController.html#delete/2"},{"type":"function","title":"TimemachineWeb.TeamController.index/2","doc":"","ref":"TimemachineWeb.TeamController.html#index/2"},{"type":"function","title":"TimemachineWeb.TeamController.show/2","doc":"","ref":"TimemachineWeb.TeamController.html#show/2"},{"type":"function","title":"TimemachineWeb.TeamController.update/2","doc":"","ref":"TimemachineWeb.TeamController.html#update/2"},{"type":"module","title":"TimemachineWeb.UserController","doc":"","ref":"TimemachineWeb.UserController.html"},{"type":"function","title":"TimemachineWeb.UserController.create/2","doc":"","ref":"TimemachineWeb.UserController.html#create/2"},{"type":"function","title":"TimemachineWeb.UserController.delete/2","doc":"","ref":"TimemachineWeb.UserController.html#delete/2"},{"type":"function","title":"TimemachineWeb.UserController.login/2","doc":"","ref":"TimemachineWeb.UserController.html#login/2"},{"type":"function","title":"TimemachineWeb.UserController.search/2","doc":"","ref":"TimemachineWeb.UserController.html#search/2"},{"type":"function","title":"TimemachineWeb.UserController.show/2","doc":"","ref":"TimemachineWeb.UserController.html#show/2"},{"type":"function","title":"TimemachineWeb.UserController.tokens/2","doc":"","ref":"TimemachineWeb.UserController.html#tokens/2"},{"type":"function","title":"TimemachineWeb.UserController.update/2","doc":"","ref":"TimemachineWeb.UserController.html#update/2"},{"type":"function","title":"TimemachineWeb.UserController.update_password/2","doc":"","ref":"TimemachineWeb.UserController.html#update_password/2"},{"type":"module","title":"TimemachineWeb.UserTeamController","doc":"","ref":"TimemachineWeb.UserTeamController.html"},{"type":"function","title":"TimemachineWeb.UserTeamController.add/2","doc":"","ref":"TimemachineWeb.UserTeamController.html#add/2"},{"type":"function","title":"TimemachineWeb.UserTeamController.remove/2","doc":"","ref":"TimemachineWeb.UserTeamController.html#remove/2"},{"type":"module","title":"TimemachineWeb.WorkingtimeController","doc":"","ref":"TimemachineWeb.WorkingtimeController.html"},{"type":"function","title":"TimemachineWeb.WorkingtimeController.create/2","doc":"","ref":"TimemachineWeb.WorkingtimeController.html#create/2"},{"type":"function","title":"TimemachineWeb.WorkingtimeController.create_for_team/2","doc":"","ref":"TimemachineWeb.WorkingtimeController.html#create_for_team/2"},{"type":"function","title":"TimemachineWeb.WorkingtimeController.delete/2","doc":"","ref":"TimemachineWeb.WorkingtimeController.html#delete/2"},{"type":"function","title":"TimemachineWeb.WorkingtimeController.get_by_team/2","doc":"","ref":"TimemachineWeb.WorkingtimeController.html#get_by_team/2"},{"type":"function","title":"TimemachineWeb.WorkingtimeController.index/2","doc":"","ref":"TimemachineWeb.WorkingtimeController.html#index/2"},{"type":"function","title":"TimemachineWeb.WorkingtimeController.show/2","doc":"","ref":"TimemachineWeb.WorkingtimeController.html#show/2"},{"type":"function","title":"TimemachineWeb.WorkingtimeController.update/2","doc":"","ref":"TimemachineWeb.WorkingtimeController.html#update/2"}],"content_type":"text/markdown"}