pointA = [1 2];
pointB = [4 6];
dist_eu = pdist2(pointA, pointB, 'euclidean')
dist_cityblock = pdist2(pointA, pointB, 'cityblock')
dist_cosine = pdist2(pointA, pointB, 'cosine')
dist_hamming = pdist2([1 0 1],[0 1 1],'hamming')
