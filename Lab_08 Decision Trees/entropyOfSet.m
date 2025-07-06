function H = entropyOfSet(labels)
    classes = unique(labels);
    H = 0;
    for c = classes'
        p = sum(labels == c) / length(labels);
        if p > 0
            H = H - p * log2(p);
        end
    end
end
