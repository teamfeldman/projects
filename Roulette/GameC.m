% 1 trial of GameC is multiple plays of the game.  That is 1 of the 100,000
% games as called by roulette() has its own mini-game.  The bet starts at 
% $1, and if you win, you win the current bet value - and the bet value is 
% reset to $1.  Else if you lose, you lose the current bet value, and it 
% doubles for the next play.  This continues until the bet goes > $100 or 
% until you have won $10.  This is one game; 100,000 of these are played.
% This game will have a significantly higher variance than A or B as you 
% can lose up to $127.

function [Exp_winnings_per_game, Exp_prop_win, Exp_count_played, Max_win, Max_loss] = GameC(n)

Max_win = 0; Max_loss = 0;
sum_winnings = 0; sum_win_count = 0; sum_count_played = 0;
win_limit = 10; bet_limit = 100; 

for (i = 1:n)
    
    count_played = 0;
    winnings = 0;
    win_count = 0;
    bet = 1;
    
    while ((winnings < win_limit) && (bet <= bet_limit))
        count_played = count_played + 1; 
        r = randi([0, 36],1,1);
     
        if ((r(1,1) >= 1) && (r(1,1) <= 18))
            winnings = winnings + bet;
        
            if (winnings >= win_limit)
                win_count = win_count + 1;
            end
            
            if (winnings >= Max_win)
                Max_win = winnings;
            end
            
            bet = 1;
        
        else
            winnings = winnings - bet;
            
            if (winnings < Max_loss)
                Max_loss = winnings;
            end
            
            bet = 2*bet;
        end
    end

    sum_winnings = sum_winnings + winnings;
    sum_win_count = sum_win_count + win_count;
    sum_count_played = sum_count_played + count_played;
end

Exp_winnings_per_game = (sum_winnings/n);
Exp_prop_win = (sum_win_count/n);
Exp_count_played = (sum_count_played/n);

end
