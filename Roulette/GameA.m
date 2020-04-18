% Game A - Simple game where if you hit [1,18] you win $1.  Else if you hit
% [19,37] you lose $1.  Obviously, the expected value is negative as you
% lose more than you win.  

function [Exp_winnings_per_game, Exp_prop_win] = GameA(n)

winnings = 0; win_count = 0;
win_amount = 1; lose_amount = 1;

for (i = 1:n)
     r = randi([0, 36],1,1);
     
     if ((r(1,1) >= 1) && (r(1,1) <= 18))
         winnings = winnings + win_amount;
         win_count = win_count + 1;
     else
         winnings = winnings - lose_amount;
     end
end

Exp_winnings_per_game = (winnings/n);
Exp_prop_win = (win_count/n);

end