function printTree(tree, depth)
    indent = repmat('  ', 1, depth);
    if isempty(tree.children)
        fprintf('%s-> 类别: %d\n', indent, tree.name);
    else
        fprintf('%s[属性 %d]\n', indent, tree.name);
        for i = 1:length(tree.children)
            fprintf('%s  = %.2f:\n', indent, tree.children{i}.value);
            printTree(tree.children{i}.subtree, depth + 1);
        end
    end
end
