% example of knapsack problem
% solved using genetic algorithm here

% knapsack problem
% we have 16 items, each taking some units of space and worth some £ amount
% units of space 3   5   6   6   7   3   1   6   2   9   3   7   3   4   6   9
% £              1.1 5.1 0.2 4.4 9.1 0.4 9.5 1.8 3.7 2.2 0.9 4.3 2.8 1.1 4.9 2.4
%
% the problem is to take figure out which of these items to take
% in order to fit 40 units of space (or less) and maximise the total amount

% for the genetic algorithm
% we use binary encoding with 16 bits
% each bit represents either we take that item (1) or not (0)

% define problem
units_of_space = [3   5   6   6   7   3   1   6   2   9   3   7   3   4   6   9  ];
pounds_amount  = [1.1 5.1 0.2 4.4 9.1 0.4 9.5 1.8 3.7 2.2 0.9 4.3 2.8 1.1 4.9 2.4];

iter = 10;% Number of iterations: repeat "iter" times 
population_size = 20; % Number of chromosomes in population

%% generate random population of "population_size" chromosomes
population = zeros(population_size,16);
for i = 1:population_size
    % must be less than 40 units of space
    temp_chromosome = randi([0,1],1,16);
    while (sum(temp_chromosome .* units_of_space) > 40)
        temp_chromosome = randi([0,1],1,16);
    end
    population(i,:) = temp_chromosome;
end
%% always have an extra column at end for fitness scores
population = [population zeros(population_size,1)];

%% repeat k times; each time generates a new population
for k = 1:iter
    %% evaluate fitness scores
    for i = 1:population_size
        population(i,17) = sum(population(i,1:16) .* pounds_amount);
    end
    
    %% elite, keep best 2
    population = sortrows(population,17);
    population_new = zeros(population_size,16);
    population_new(1:2,:) = population(population_size-1:population_size,1:16);
    population_new_num = 2;
    
    %% repeat until new population is full
    while (population_new_num < population_size)
        %% use a selection method and pick two chromosomes
        weights= population(:,17)/sum(population(:,17));
        choice1 = Selection(weights);
        choice2 = Selection(weights);
        temp_chromosome_1 = population(choice1, 1:16);
        temp_chromosome_2 = population(choice2, 1:16);
        
        %% crossover prob 0.8 and random pick cross point
        if (rand < 0.8)
            % need to add your own code here ...
            
            
            
            
        end
        
        %% mutation prob 0.2 and random pick bit to switch
        if (rand < 0.2)
            % need to add your own code here ...
           
            
        end
        if (rand < 0.2)
            % need to add your own code here ...
            
            
        end
        
        %% put in new population if within max space
        if (sum(temp_chromosome_1 .* units_of_space) <= 40)
            population_new_num = population_new_num + 1;
            population_new(population_new_num,:) = temp_chromosome_1;
        end
        if (sum(temp_chromosome_2 .* units_of_space) <= 40)
            if (population_new_num < 20)
                population_new_num = population_new_num + 1;
                population_new(population_new_num,:) = temp_chromosome_2;
            end
        end
    end
    
    %% replace, last column not updated yet
    population(:,1:16) = population_new;
end

%% evaluate fitness scores and rank them
for i = 1:population_size
    population(i,17) = sum(population(i,1:16) .* pounds_amount);
end
population = sortrows(population,17);
population(end,17)