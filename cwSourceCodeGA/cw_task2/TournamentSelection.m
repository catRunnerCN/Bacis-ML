load('xy.mat');  

% 参数设置
city_count = size(xy, 1);
population_size = 100;
max_iter = 10000;
mutation_probability = 0.3;
tournament_size = 3;

% 初始化种群
routes = zeros(population_size, city_count);
for i = 1:population_size
    routes(i, :) = randperm(city_count);
end

% 初始化历史记录
fitness_history = zeros(max_iter, 1);

% 主迭代过程
for generation = 1:max_iter
    % 计算适应度
    fit_values = zeros(population_size, 1);
    for i = 1:population_size
        fit_values(i) = 1 / computeDistance(xy, routes(i, :));
    end
    
    % 锦标赛选择
    selected_routes = zeros(size(routes));
    for i = 1:population_size
        candidates = randperm(population_size, tournament_size);
        [~, best_idx] = max(fit_values(candidates));
        selected_routes(i, :) = routes(candidates(best_idx), :);
    end

    % 变异操作（无交叉）
    for i = 1:population_size
        if rand < mutation_probability
            route = selected_routes(i, :);
            route = swapMutate(route);
            route = flipMutate(route);
            route = slideMutate(route);
            selected_routes(i, :) = route;
        end
    end

    routes = selected_routes;

    % 记录最优个体适应度
    fitness_history(generation) = max(fit_values);

    % 每500代显示一次
    if mod(generation, 500) == 0
        fprintf('Generation %d: Best Fitness = %.5f\n', generation, fitness_history(generation));
    end
end

% 绘制适应度变化图
figure;
plot(fitness_history, 'LineWidth', 1.5);
xlabel('Generation');
ylabel('Best Fitness');
title('Best Fitness Evolution Over Generations');
grid on;

% ===== 计算路径总距离函数 =====
function d = computeDistance(xy, path)
    d = sum(sqrt(sum(diff(xy(path, :)).^2, 2)));
    d = d + norm(xy(path(end), :) - xy(path(1), :));
end

% 显示最终最优路线
[~, best_index] = max(fit_values);
best_path = routes(best_index, :);
best_path = [best_path, best_path(1)];
figure;
plot(xy(:,1), xy(:,2), 'bo'); hold on;
plot(xy(best_path,1), xy(best_path,2), 'r-', 'LineWidth', 2);
d = computeDistance(xy, best_path);
title('Tournament Selection & All Mutations Distance =', d);
legend('Cities','Best Route');
grid on;



% ===== 交换变异（Swap）=====
function route = swapMutate(route)
    idx = randperm(length(route), 2);
    temp = route(idx(1));
    route(idx(1)) = route(idx(2));
    route(idx(2)) = temp;
end

% ===== 反转变异（Flip）=====
function route = flipMutate(route)
    idx = sort(randperm(length(route), 2));
    route(idx(1):idx(2)) = flip(route(idx(1):idx(2)));
end

% ===== 滑动变异（Slide）=====
function route = slideMutate(route)
    n = length(route);
    pos = randi(n);
    new_pos = randi(n);
    city = route(pos);
    route(pos) = [];
    if new_pos == 1
        route = [city, route];
    elseif new_pos >= length(route)
        route = [route, city];
    else
        route = [route(1:new_pos-1), city, route(new_pos:end)];
    end
end
