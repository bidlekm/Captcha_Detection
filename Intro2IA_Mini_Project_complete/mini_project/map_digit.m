function digit = map_digit(nfiles,nfile)
    % 3
    if nfile <= nfiles/3
        digit = 3;
        return;
    end
    % 4
    if nfile <= (nfiles/3)*2
        digit = 4;
        return;
    end
    % 5
    digit = 5;
end

