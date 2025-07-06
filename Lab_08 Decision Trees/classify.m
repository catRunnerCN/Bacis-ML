function label = classify(tree, sample)
    if isempty(tree.children)
        label = tree.name;
        return;
    end

    attr = tree.name;
    value = sample(attr);

    for i = 1:length(tree.children)
        if tree.children{i}.value == value
            label = classify(tree.children{i}.subtree, sample);
            return;
        end
    end

    % 若无匹配值，返回根节点最多类（可优化）
    label = tree.name;
end
