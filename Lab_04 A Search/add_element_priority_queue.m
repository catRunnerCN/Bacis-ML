% -this works with the A_star_search.m code
% -i just made a separate function to make the overall code
% in the search easier to read

function priority_queue = add_element_priority_queue(priority_queue, toadd_row)

temp_i = size(priority_queue,1);
if (temp_i == 0)
    priority_queue = toadd_row;
else
    % keep the rows or elements sorted based on last value
    while (toadd_row(5) < priority_queue(temp_i,5))
        temp_i = temp_i-1;
        if (temp_i == 0)
            break;
        end
    end
    % toadd_row goes after index temp_i
    priority_queue = [priority_queue(1:temp_i,:); toadd_row; priority_queue(temp_i+1:end,:)];
end
