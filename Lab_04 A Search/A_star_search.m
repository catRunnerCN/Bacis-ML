clear all
clc

% basic code for doing A* search

% input is a 2D grid world
% with empty space (0) or obstacles (1)
% input also includes start position and goal position

% A* search finds
% output of solution path from start to goal while avoiding obstacles

% put code here...



% add start_pos to priority queue
% put code here...



% while not empty
while (size(priority_queue,1) > 0)
    % take element with lowest priority
    toexpand_pos = priority_queue(1,1:2);
    toexpand_dir = priority_queue(1,3);
    toexpand_distsofar = priority_queue(1,4);
    priority_queue = priority_queue(2:end,:);
    
    % check if this is goal
    if (toexpand_pos == goal_pos)
        world_grid(toexpand_pos(1),toexpand_pos(2)) = toexpand_dir;
        break;
    end

    % if not already expanded
    if (world_grid(toexpand_pos(1),toexpand_pos(2)) == 0)
        
        % neighbour - right side
        % check inside bounds and not obstacle/already expanded
        if (toexpand_pos(2) < c_world_grid) && (world_grid(toexpand_pos(1),toexpand_pos(2)+1) == 0)
            % add to priority queue
            temp_pos = [toexpand_pos(1) toexpand_pos(2)+1];
            temp_dist = (goal_pos-temp_pos) .* (goal_pos-temp_pos);
            toadd_row = [temp_pos 5 toexpand_distsofar+1 toexpand_distsofar+1+sqrt(sum(temp_dist))];
            priority_queue = add_element_priority_queue(priority_queue, toadd_row);
        end
        
        % neighbour - left side
        if (toexpand_pos(2) > 1) && (world_grid(toexpand_pos(1),toexpand_pos(2)-1) == 0)
            % add to priority queue
            temp_pos = [toexpand_pos(1) toexpand_pos(2)-1];
            temp_dist = (goal_pos-temp_pos) .* (goal_pos-temp_pos);
            toadd_row = [temp_pos 3 toexpand_distsofar+1 toexpand_distsofar+1+sqrt(sum(temp_dist))];
            priority_queue = add_element_priority_queue(priority_queue, toadd_row);
        end
        
        % neighbour - top
        if (toexpand_pos(1) > 1) && (world_grid(toexpand_pos(1)-1,toexpand_pos(2)) == 0)
            % add to priority queue
            temp_pos = [toexpand_pos(1)-1 toexpand_pos(2)];
            temp_dist = (goal_pos-temp_pos) .* (goal_pos-temp_pos);
            toadd_row = [temp_pos 6 toexpand_distsofar+1 toexpand_distsofar+1+sqrt(sum(temp_dist))];
            priority_queue = add_element_priority_queue(priority_queue, toadd_row);
        end

        % neighbour - bottom
        if (toexpand_pos(1) < r_world_grid) && (world_grid(toexpand_pos(1)+1,toexpand_pos(2)) == 0)
            % add to priority queue
            temp_pos = [toexpand_pos(1)+1 toexpand_pos(2)];
            temp_dist = (goal_pos-temp_pos) .* (goal_pos-temp_pos);
            toadd_row = [temp_pos 4 toexpand_distsofar+1 toexpand_distsofar+1+sqrt(sum(temp_dist))];
            priority_queue = add_element_priority_queue(priority_queue, toadd_row);
        end
        
        % mark current element as expanded
        world_grid(toexpand_pos(1),toexpand_pos(2)) = toexpand_dir;
    end
end

if (size(priority_queue,1) == 0)
    disp('no solution found');
else
    disp('solution found');
    % print solution path in reverse, using directions
    temp_pos = goal_pos;
    fprintf('%d %d\n',temp_pos(1),temp_pos(2));
    temp_dir = world_grid(temp_pos(1), temp_pos(2));
    while (temp_dir ~= 2)
        if (temp_dir == 3)
            temp_pos(2) = temp_pos(2)+1;
        elseif (temp_dir == 4)
            temp_pos(1) = temp_pos(1)-1;
        elseif (temp_dir == 5)
            temp_pos(2) = temp_pos(2)-1;            
        elseif (temp_dir == 6)
            temp_pos(1) = temp_pos(1)+1;
        end
        fprintf('%d %d\n',temp_pos(1),temp_pos(2));
        temp_dir = world_grid(temp_pos(1), temp_pos(2));
    end
end
