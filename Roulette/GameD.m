% GameD() is a simulation of the labouchere betting system.
% Where you bet from a list (in this case 1:4) - the bet is always the 
% first element of the list + the last element of the list.
% If you win (hit [1,18]), you reduce the start and the end of the list 
% by 1 (either side) and recalculate the bet.  If you lose, the list size 
% (and the bet) the same.
% This continues until the list is size 0; or the bet goes over $100.  Upon
% meeting these criteria that is 1 trial of the game, of which 100,000 
% simulations are done from the roulette() function.

function [Exp_winnings_per_game, Exp_prop_win, Exp_count_played, Max_win, Max_loss] = GameD(n)

Max_win = 0; Max_loss = 0;
sum_winnings = 0; sum_win_count = 0; sum_count_played = 0;

for i = 1:n
    
    count_played = 0;
    winnings = 0;
    list = 1:4;
    bet = list(1,1) + list(1,length(list));
    
    while ((length(list) ~= 0) && (bet <= 100)) %#ok<ISMT>
        
        r = randi([0, 36],1,1);
        count_played = count_played + 1;
        
        % Win %
        if ((r(1,1) >= 1) && (r(1,1) <= 18))
            winnings = winnings + bet;
            list = list(2:(length(list)-1));
            
            if (length(list) == 1)
                bet = list(1,1);
            elseif (length(list) == 0)
                break;
            else
                bet = list(1,1) + list(1,length(list));
            end
            
        % lose %
        else
            winnings = winnings - bet;
            list(1,(length(list)+1)) = bet;
            
            if (length(list) == 1)
                bet = list(1,1);
            elseif (length(list) == 0)
                break;
            else
                bet = list(1,1) + list(1,length(list));
            end
            
        end
    end
    
    if (winnings > Max_win)
        Max_win = winnings;
    end
    
    if (winnings < Max_loss)
        Max_loss = winnings;
    end
    
    if (length(list) == 0) %#ok<*ISMT>
        sum_win_count = sum_win_count + 1;
    end
    
    sum_winnings = sum_winnings + winnings;
    sum_count_played = sum_count_played + count_played;
end

Exp_winnings_per_game = sum_winnings/n;
Exp_prop_win = sum_win_count/n;
Exp_count_played = sum_count_played/n;

end