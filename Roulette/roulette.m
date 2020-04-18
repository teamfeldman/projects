% Function roulette(gametype) that simulates four different types of 
% roulette play - with different betting strategies and winning/stopping
% conditions. 
% All calls simulate 100,000 games.  For each game see it's .m file for 
% description.  GameC() and GameD() are more interesting.

function roulette(gametype)
n = 100000;

if (gametype == "A")
    [Exp_winnings_per_game, Exp_prop_win] = GameA(n);
    disp(Exp_winnings_per_game); disp(Exp_prop_win);

elseif (gametype == "B")
    [Exp_winnings_per_game, Exp_prop_win] = GameB(n);
    disp(Exp_winnings_per_game); disp(Exp_prop_win);

elseif (gametype == "C")
    [Exp_winnings_per_game, Exp_prop_win, Exp_count_played, Max_win, Max_loss] = GameC(n);
    disp(Exp_winnings_per_game); disp(Exp_prop_win); disp(Exp_count_played);
    disp(Max_win); disp(Max_loss);
    
elseif (gametype == "D")
    [Exp_winnings_per_game, Exp_prop_win, Exp_count_played, Max_win, Max_loss] = GameD(n);
    disp(Exp_winnings_per_game); disp(Exp_prop_win); disp(Exp_count_played);
    disp(Max_win); disp(Max_loss);
    
end
end