function [X_synthetic, Y_synthetic] = smote(X, Y, minority_class, N, k)
    % X, Y: Data and labels
    % minority_class: The class to oversample
    % N: Number of synthetic samples to create (as a multiple of the minority class count)
    % k: Number of nearest neighbors to use for generating synthetic samples
    % Written by Yuen Siang Ang DPhil
    
    minority_indices = find(Y == minority_class);
    num_minority = length(minority_indices);
    
    X_synthetic = zeros(num_minority * N, size(X, 2));
    Y_synthetic = minority_class * ones(num_minority * N, 1);
    
    for i = 1:num_minority
        % Find k-nearest neighbors of each minority instance
        this_sample = X(minority_indices(i), :);
        distances = sum((X(minority_indices, :) - this_sample).^2, 2);
        [~, idx] = sort(distances, 'ascend');
        neighbors = minority_indices(idx(2:k+1)); % the closest k neighbors
        
        for n = 1:N
            % Generate synthetic samples
            nn = neighbors(randi(k)); % pick a random neighbor
            diff = X(nn, :) - this_sample;
            gap = rand;
            X_synthetic((i-1)*N + n, :) = this_sample + gap * diff;
        end
    end
end
