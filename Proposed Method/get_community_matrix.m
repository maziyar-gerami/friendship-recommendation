function [e] = get_community_matrix(adj,com)

    % Number of communities
    nc = length(unique(com));

    % Initialise adjacency matrix list
    e = zeros(nc,nc);

    % Create edges and normalise values by dividing by the sum of all edges
    m = 0;
    for i=1:length(adj)
        for j=i:length(adj)
            if adj(i,j) ~= 0
                ic = com(i);
                jc = com(j);
                if ic == jc
                    e(ic,ic) = e(ic,ic) + adj(i,j);
                else
                    e(ic,jc) = e(ic,jc) + (0.5 * adj(i,j));
                    e(jc,ic) = e(ic,jc);
                end
                m = m + adj(i,j);
            end
        end
    end
    e = e / m;

end

