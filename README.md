# Football Coach for iOS
An iOS Port of https://github.com/jonesguy14/footballcoach.

**NOTE**: As of March 25, 2016, this repo is at beta status! The iOS version now matches all of the [Android version](https://github.com/jonesguy14/footballcoach)'s features.

_The original README of FootballCoach is below._

#Football Coach
![Football Coach](http://i.imgur.com/NBtg2lC.png)

#**[Available now and for free on the Play Store!](https://play.google.com/store/apps/details?id=achijones.footballcoach)**

To be clear, **Football Coach is a college football simulator/management game.** Though you yourself won't be controlling the QB via a joystick each play, you will be recruiting players, scouting other teams, setting strategies to help your team win, and simulating through the season week by week.

###[Here are some screenshots!](http://imgur.com/a/dj5JH)


###Basics:
In Football Coach, you take the role of a newly hired coach at your college of choice. As coach, it will be your responsibility to manage your team's strategy, simulate through seasons, recruit new players, and above all, win championships.

###Playing a Season:
Your team will play 12 games in the regular season, which consist of playing all 9 of your conference opponents once and three out-of-conference games. By navigating to the "GAMES" tab, you can see exactly what your team's schedule is. And by clicking on each game, you can see a scouting report of the two teams (if the game has yet to be played), or a summary of the game (if it was already played). The most important game of the regular season is your rivalry game, which you gain prestige if won or lose prestige if lost.

At the end of the regular season, the Conference Championship is played between the two teams with the best in-conference record. If two teams have the same record, a head-to-head tiebreaker is used. If three or more teams have the same record, the one with the highest poll ranking is chosen. After the Conference Championships, Bowl Games are played. Only the top 16 teams get chosen for a bowl, with the most important being the National Semifinals between the #1 and #4 team, and the #2 and #3 team. The winner of these two games advance to the National Championship where an undisputed champion is crowned.

After the season, your team will have gained or lost prestige based on their results versus their expectations, and you move onto recruiting.

###Rankings:
As your team plays through the season, it will be evaluated by pollsters who determine how good (or bad) your team is compared to others. This "Poll Ranking" is determined by wins, margin of victory, strength of schedule, and more, and has a big impact on how your season will play out, as it determines who gets into a bowl game and the semifinals. Many statistics are kept track of during the season, such as Yards Per Game, Opposing Points Per Game, Pass Yards Per Game, Turnover Differential and more. You can view all these statistics, as well as your team's ranking in each one, by navigating to the "STATS" tab.

###Roster:
When you first inherit a team, you will have a total of 46 players (22 starters) on your roster. Each player has a name, their year in school (from Freshman to Senior), an Overall rating, Potential rating, and three position specific ratings. The Overall rating is just a composite rating of the three position specific ones, while Potential determines how much each play improves during the offseason. You can view all of these players in the "ROSTER" tab.

QB (1 starter):
  - Quarterback, responsible for throwing passes to Wide Receivers
  - Pass Strength: how far the QB can throw. Higher strength means catches go for more yards.
  - Accuracy: how accurate the QB is. Higher accuracy means a greater chance that the throw will be caught, as well as a lower interception chance.
  - Evasion: how evasive the QB is. Higher evasion means less sacks.

RB (2 starters):
  - Running Back, responsible for carrying the ball up and down the field.
  - Rush Power: how strong the RB is. Higher power means he is less likely to be stopped at the line of scrimmage.
  - Rush Speed: how quick the RB is. Higher speed means runs go for more yards.
  - Evasion: how agile the RB is. Higher evasion means a higher chance of breaking free for bigger runs.

WR (3 starters):
  - Wide Receiver, responsible for catching passes from the QB downfield.
  - Catching: how good the WR is at catching the ball. Higher catching means higher chance of completion and less drops.
  - Speed: how quick the WR is. Higher speed means his catches go for more yards.
  - Evasion: how agile and crafty the WR is. Higher evasion means higher chance to break free for big gains and long touchdowns.

OL (5 starters):
  - Offensive Line, responsible for protecting the QB and blocking for the RBs when they run.
  - Strength: most important rating, how strong the OL is.
  - Run Block: how good the OL is at blocking for rushing plays.
  - Pass Block: how good the OL is at blocking for pass plays.

K (1 starter):
  - Kicker, responsible for kicking extra points and field goals.
  - Kick Strength: how strong the kicker's leg is. Higher strength means longer field goals.
  - Kick Accuracy: how accurate the kicker is, higher means kicks are more likely to be good.
  - Clumsiness: how clumsy the kicker is, higher means more chance of success at onside kicks.

S (1 starter):
  - Safety, responsible for covering the pass and causing inteceptions from opposing QBs.
  - Coverage: how good the safety is at convering the pass and how good he is at catching interceptions.
  - Speed: how quick the safety is, affects how he can keep up with WRs.
  - Tackling: how good the safety is at tackling, higher means he is more likely to tackle WRs before they get away.

CB (3 starters):
  - Cornerback, responsible for covering a corresponding WR.
  - Coverage: how good the cornerback is at covering receivers. Higher means less likely that the WR will complete the catch.
  - Speed: how quick the CB is, affects how he can keep up with WRs.
  - Tackling: how good the CB is at tackling, higher means he is more likely to tackle WRs before they get away.

F7 (7 starters):
  - Front Seven, responsible for putting pressure on the opposing QB and tackling RBs.
  - Strength: most important rating, how strong the F7 is against opposing OLs.
  - Run Stop: how good the F7 is at tackling opposing RBs without allowing many yards.
  - Pass Pressure: how much pressure they put on the opposing QB, higher pressure means the QB will have a harder time throwing accurate passes.

###Team Strategy:

As a coach, you can pick what strategy your team employs on offense and defense as they play through their season. By default both strategies are set to "No Preference", meaning there are no bonuses or penalties either way. But you can change your strategy to any of the following:

[Offense] Aggressive:
  - Utilize a more aggressive offense. Will pass a bit more.
  - Pass with a lower completion percentage and higher chance of interception.
  - However, passes that are caught will go for more yards.

[Offense] Conservative:
  - Utilize a more conservative offense. Will run a bit more.
  - Passes are more accurate but go for less yards.
  - Rushes are more likely to gain yards but less likely to break free for big plays.

[Defense] Stack the Box:
  - Defensive scheme with emphasis on stopping the run.
  - Will give up more big passing plays but will allow less rushing yards and big plays from rushing.

[Defense] No Fly Zone:
  - Defensive scheme with emphasis on limiting the pass.
  - Will give up less yards on catches and be more likely to intercept passes.
  - However, rushing plays will go for more yards.

###Recruiting:

At the end of each season, graduating seniors leave the program and spots open up. As coach, you are responsible for recruiting the next class of players that will lead your team to bigger and better wins. You recruit based on a budget, which is determined by your team's prestige. Better teams will have more money to work with, while worse teams will have to save money wherever they can.

When you press "Begin Recruiting" after the season, you can see who is leaving your program and give you a sense of how many players you will need to replace. Next, the Recruiting menu opens up. You can view recruits from every position or select "Top 100 Recruits" to see the best of the best. Each Recruit has their positional ratings as well as an Overall and Potential. The cost of each recruit (insert Cam Newton joke here) is determined by how good they are. Once you are done recruiting all the players you need, or have money for, you can press "Done" to advance to the next season.

###Saving:

~~In Football Coach, you can save your game at any time during the season. HOWEVER, since so much data is generated during the course of the season, Save Games are only saved FROM THE BEGINNING OF THE SEASON. For example, if you play through 5 games of the 2017 season, save your game, and then load it back up later, your game will start back at the beginning of the 2017 season.~~

The iOS version saves after each week is played and at the start of a new season, so you can pick up right where you left off!

###Donations:
Football Coach is not monetized and I have no plans to do so. I love college football and seeing people use my app is all the encouragement I need. But if you love the app and you would like to let me know, you can donate via PayPal:

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GAJZ8MFAY73D6)


**[Download Football Coach from the Google Play Store](https://play.google.com/store/apps/details?id=achijones.footballcoach)**
