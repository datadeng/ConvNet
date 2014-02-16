function [weights, trainerr] = cnntrain(layers, weights_in, train_x, train_y, params, type)

if (length(size(train_x)) == 3)
  % insert singletone maps index
  train_x = permute(train_x, [1 2 4 3]); 
end;

tic;
if strcmp(type, 'mexfun')
  train_x = permute(train_x, [2 1 3 4]);
  train_y = train_y';
  if (isfield(layers{1}, 'mean'))
    layers{1}.mean = permute(layers{1}.mean, [2 1 3]);
  end;
  if (isfield(layers{1}, 'stdev'))
    layers{1}.stdev = permute(layers{1}.stdev, [2 1 3]);
  end;
  [weights, trainerr] = cnntrain_mex(layers, weights_in, train_x, train_y, params);  
elseif strcmp(type, 'matlab')
  [weights, trainerr] = cnntrain_mat(layers, weights_in, train_x, train_y, params);
else
  error('"%s" - wrong type, must be either "mexfun" or "matlab"', type);
end;
t = toc;
disp(['Total training time: ' num2str(t)]);

trainerr = trainerr(:);

end
