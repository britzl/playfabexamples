# PlayFab API examples for Defold
This project implements a simple game as well as a rudimentary menu system. The project currently shows:

* Authentication
* Storing user-data
* Storing player statistics in a leaderboard

# Authentication
Authentication in this example is done using either a generated custom id or using a username and password. The app will on startup attempt to authenticate the user. If no username and password is stored the app will generate a custom id and use that to authenticate. The user can later opt to register the account using e-mail, username and password and from there on use these credentials to authenticate.

![Start menu](https://github.com/britzl/playfab_example/raw/master/docs/startmenu.png)
The example shows both how to register and login with a PlayFab account

![Login](https://github.com/britzl/playfab_example/raw/master/docs/login.png)
Login with e-mail and password.

![Register](https://github.com/britzl/playfab_example/raw/master/docs/register.png)
Register with e-mail, username and password.

# Storing user-data
The example uses the [GetUserData](https://api.playfab.com/Documentation/Client/method/GetUserData) and [UpdateUserData](https://api.playfab.com/Documentation/Client/method/UpdateUserData) API methods to store and get per-player settings (in this game represented by a choice of color on the player character in the game, available from the Settings menu).

![Settings](https://github.com/britzl/playfab_example/raw/master/docs/settings.png)
Change player character and store it using PlayFab user-data

# Storing player statistics
The example uses the [GetLeaderboardAroundPlayer](https://api.playfab.com/Documentation/Client/method/GetLeaderboardAroundPlayer) and [UpdatePlayerStatistics](https://api.playfab.com/Documentation/Client/method/UpdatePlayerStatistics) API methods to store player statistics (score) and use these to show a leaderboard.

![Leaderboard](https://github.com/britzl/playfab_example/raw/master/docs/leaderboard.png)
Show leaderboard using PlayFab player statistics

# The game
The game itself challenges the player to survive an incoming swarm of nasty bats. The player can jump (and double jump) to land on top of the bats to kill them, scoring points.

![Game](https://github.com/britzl/playfab_example/raw/master/docs/game.png)

# Implementation details
The example uses the [PlayFab Lua SDK for Defold](https://github.com/PlayFab/LuaSdk)). The example uses a couple of different Lua modules to keep track of additional state:

* [authenticate.lua](https://github.com/britzl/playfab_example/blob/master/example/playfab/authentication.lua) - Keeps track of stored authentication credentials and does the actual call to the PlayFab SDK to either authenticate or register.
* [user_data.lua](https://github.com/britzl/playfab_example/blob/master/example/playfab/user_data.lua) - Get and set user data using the PlayFab SDK
* [leaderboard.lua](https://github.com/britzl/playfab_example/blob/master/example/playfab/leaderboard.lua) - Get and update leaderboard

The project makes heavy use of a couple of different utility functions to make the code a bit cleaner:

* [flow.lua](https://github.com/britzl/ludobits/blob/master/ludobits/m/flow.lua) - Run code in a coroutine and untangle nested callbacks into neat looking synchronous code.
* [listener.lua](https://github.com/britzl/ludobits/blob/master/ludobits/m/listener.lua) - Notify listeners either via Defold message passing or direct function calls. Used to send notifications when authentication, user data or leaderboard data changes.
* [Dirty Larry](https://github.com/andsve/dirtylarry) - This is a UI library which simplifies the creation of buttons, input fields and checkbox. It's perfect or sample apps such as this.

# Project dependencies
This project is built using the following Defold library projects:

* [PlayFab Lua SDK](https://github.com/PlayFab/LuaSdk) - The official Lua SDK for PlayFab
* [Dirty Larry](https://github.com/andsve/dirtylarry) - Quick and dirty GUI library
* [Ludobits](https://github.com/britzl/ludobits) - Utilities for game development

# Try it!
https://britzl.github.io/playfab_example/

# Credits
Art by [Kenney](http://www.kenney.nl)
