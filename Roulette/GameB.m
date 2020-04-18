% You win $35 if you hit 17; so 1/37 chance of occurring.  You lose $1, 
% every other time (36/37 times).  So the expected value is the same as in
% GameA().

function [Exp_winnings_per_game, Exp_prop_win] = GameB(n)

winnings = 0; win_amount = 35; win_count = 0;
lose_amount = 1;

for (i = 1:n)
     r = randi([0, 36],1,1);
     
     if (r(1,1) == 17)
         winnings = winnings + win_amount;
         win_count = win_count + 1;
     else
         winnings = winnings - lose_amount;
     end
end

Exp_winnings_per_game = (winnings/n);
Exp_prop_win = (win_count/n);

end