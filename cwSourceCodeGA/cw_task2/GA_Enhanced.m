% Enhanced Genetic Algorithm for TSP with Visualization and Selection Mechanisms

clear; clc;
load('xy.mat');

% Parameters
cityCount = size(xy, 1);
initialPopSizes = [50, 100, 150, 200];
generationCounts = [1000, 2500, 5000, 10000];
mutationProb = 0.3;
CrossProb = 0.7;
selectionType = 'tournament'; % 'roulette', 'rank', 'tournament'

% Initialize performance log
fitnessHistory = zeros(max(generationCounts), 1);
bestInitialFitness = 0;

% Choose one setting to run
popSize = initialPopSizes(4); % Try 200
maxGen = generationCounts(3); % Try 10000

% Create initial population
population = zeros(popSize, cityCount);
for i = 1:popSize
    population(i, :) = randperm(cityCount);
end

% Evaluate initial population
fitness = evaluate_fitness(population, xy);
bestInitialFitness = max(fitness);

for gen = 1:maxGen
    % Selection
    switch selectionType
        case 'roulette'
            newPop = roulette_selection(population, fitness);
        case 'rank'
            newPop = rank_selection(population, fitness);
        case 'tournament'
            newPop = tournament_selection(population, fitness);
        otherwise
            error('Unknown selection type');
    end

    % Crossover
    for i = 1:2:popSize
        [offspring1, offspring2] = ordered_crossover(newPop(i,:), newPop(i+1,:));
        newPop(i,:) = offspring1;
        newPop(i+1,:) = offspring2;
    end

    % Mutation
    for i = 1:popSize
        if rand() < mutationProb
            switch randi(3)
                case 1
                    newPop(i,:) = swap_mutation(newPop(i,:));
                case 2
                    newPop(i,:) = flip_mutation(newPop(i,:));
                case 3
                    newPop(i,:) = slide_mutation(newPop(i,:));
            end
        end
    end

    % Evaluate new generation
    fitness = evaluate_fitness(newPop, xy);
    population = newPop;

    [fitnessHistory(gen), bestIdx] = max(fitness);
    fprintf('Gen %d: Best Fitness = %.4f\n', gen, fitnessHistory(gen));
end

% Report initial and final best fitness
fprintf('\nInitial Best Fitness: %.4f\n', bestInitialFitness);
fprintf('Final Best Fitness: %.4f\n', fitnessHistory(maxGen));

% Plot fitness evolution
figure;
plot(1:maxGen, fitnessHistory(1:maxGen), 'LineWidth', 2);
xlabel('Generation'); ylabel('Best Fitness');
title('Fitness Evolution Over Generations'); grid on;

% Plot final route
bestRoute = population(bestIdx, :);
bestRoute = [bestRoute, bestRoute(1)];
figure;
plot(xy(:,1), xy(:,2), 'ko'); hold on;
plot(xy(bestRoute,1), xy(bestRoute,2), 'r-');
title(sprintf('Best Route (Distance = %.4f)', 1/fitnessHistory(maxGen)));

%100 bit
fprintf('Best Individual in Final Generation:\n');
disp(population(bestIdx, :));

% ===== Helper Functions =====
function fit = evaluate_fitness(pop, coords)
    n = size(pop, 1);
    fit = zeros(n, 1);
    for i = 1:n
        dist = 0;
        for j = 1:length(pop(i,:))-1
            dist = dist + norm(coords(pop(i,j), :) - coords(pop(i,j+1), :));
        end
        dist = dist + norm(coords(pop(i,end), :) - coords(pop(i,1), :));
        fit(i) = 1 / dist;
    end
end

function selected = roulette_selection(pop, fitness)
    probs = fitness / sum(fitness);
    idx = randsample(1:size(pop,1), size(pop,1), true, probs);
    selected = pop(idx, :);
end

function selected = rank_selection(pop, fitness)
    [~, rankIdx] = sort(fitness);
    probs = (1:size(pop,1))' / sum(1:size(pop,1));
    idx = randsample(rankIdx, size(pop,1), true, probs);
    selected = pop(idx, :);
end

function selected = tournament_selection(pop, fitness)
    n = size(pop,1);
    selected = zeros(size(pop));
    for i = 1:n
        candidates = randperm(n, 3);
        [~, best] = max(fitness(candidates));
        selected(i,:) = pop(candidates(best), :);
    end
end

function [child1, child2] = ordered_crossover(parent1, parent2)
    n = length(parent1);
    c = sort(randperm(n, 2));
    seg = parent1(c(1):c(2));
    rem1 = setdiff(parent2, seg, 'stable');
    child1 = [rem1(1:c(1)-1), seg, rem1(c(1):end)];
    rem2 = setdiff(parent1, seg, 'stable');
    child2 = [rem2(1:c(1)-1), seg, rem2(c(1):end)];
end

function mutated = swap_mutation(route)
    idx = randperm(length(route), 2);
    mutated = route;
    mutated(idx(1)) = route(idx(2));
    mutated(idx(2)) = route(idx(1));
end

function mutated = flip_mutation(route)
    idx = sort(randperm(length(route), 2));
    mutated = route;
    mutated(idx(1):idx(2)) = flip(route(idx(1):idx(2)));
end

function mutated = slide_mutation(route)
    pos = randperm(length(route), 1);
    new_pos = randi(length(route));
    city = route(pos);
    route(pos) = [];
    mutated = [route(1:new_pos-1), city, route(new_pos:end)];
end
