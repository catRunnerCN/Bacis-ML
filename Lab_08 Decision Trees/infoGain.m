function gain = infoGain(data, attr)
    H_D = entropyOfSet(data(:, end));
    values = unique(data(:, attr));
    H_cond = 0;

    for v = values'
        subset = data(data(:, attr) == v, :);
        p = size(subset, 1) / size(data, 1);
        H_cond = H_cond + p * entropyOfSet(subset(:, end));
    end

    gain = H_D - H_cond;
end
