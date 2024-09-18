function pdp_plot(random_forest_model, X, Y, variable_idx, variable_name, grid_points)
    % random_forest_model: The trained Random Forest model (TreeBagger)
    % X: Matrix of independent variables
    % Y: Matrix of dependent variables
    % variable_idx: The index of the variable you want to plot PDP for (1-based index)
    % variable_name: Name of the variable (for labeling the plot)
    % grid_points: Number of points to evaluate the variable on
    % Written by Yuen-Siang Ang, DPhil.
    
    % Get min and max values for the variable of interest
    min_val = min(X(:, variable_idx));
    max_val = max(X(:, variable_idx));
    
    % Generate a sequence of values from min to max for the PDP
    grid_vals = linspace(min_val, max_val, grid_points);
    
    % Initialize the PDP array
    pdp_vals = zeros(size(grid_vals));
    
    % For each value in the grid, compute the average prediction
    for i = 1:grid_points
        X_temp = X;  % Make a copy of the input data
        X_temp(:, variable_idx) = grid_vals(i);  % Set the variable of interest to the grid value
        
        % Predict using the random forest model for all observations with the modified variable
        predictions = predict(random_forest_model, X_temp);
        
        % Compute the mean prediction for this grid value
        pdp_vals(i) = mean(predictions);
    end
    
    % Plot the partial dependence
    figure;
    plot(grid_vals, pdp_vals, 'LineWidth', 2);
    xlabel(variable_name);
    ylabel('Partial Dependence');
    title(['Partial Dependence Plot for ', variable_name]);
    grid on;
end