function closePool(pool_obj)
% This is the function to close a parallel pool

%poolobj = gcp('nocreate');
delete(pool_obj);

end