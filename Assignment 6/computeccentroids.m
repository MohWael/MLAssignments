function [centroids,error] = computeccentroids(X, idx, K)
[m n] = size(X);
centroids = zeros(K, n);

for i = 1:K
    
    clustering = X(find(idx == i), :);
    centroids(i, :) = mean(clustering);
    error=0; 
            
   for z = 1 : size(clustering,1)
     error = error + sum((clustering(z,:) - centroids(i,:)).^2)/m;
     end
            
end

end