function tree = buildTree(data, attributes)
    % 若全属于一个类别，则为叶节点
    if length(unique(data(:, end))) == 1
        tree.name = data(1, end);
        tree.children = {};
        return;
    end

    % 若无可用属性，则投票选出最多类
    if isempty(attributes)
        tree.name = mode(data(:, end));
        tree.children = {};
        return;
    end

    % 选择最佳划分属性（信息增益）
    gains = zeros(1, length(attributes));
    for i = 1:length(attributes)
        gains(i) = infoGain(data, attributes(i));
    end

    [~, bestAttrIdx] = max(gains);
    bestAttr = attributes(bestAttrIdx);

    tree.name = bestAttr;
    tree.children = {};

    attrValues = unique(data(:, bestAttr));
    for v = attrValues'
        subset = data(data(:, bestAttr) == v, :);
        if isempty(subset)
            child.name = mode(data(:, end));
            child.children = {};
        else
            newAttr = attributes;
            newAttr(bestAttrIdx) = [];
            child = buildTree(subset, newAttr);
        end
        tree.children{end+1} = struct('value', v, 'subtree', child);
    end
end
