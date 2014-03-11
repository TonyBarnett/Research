function [DateTime] = GetDate(time)
    DateTime = [num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) 'T' num2str(time(4)) ':' num2str(time(5)) ':' num2str(time(6))];
end