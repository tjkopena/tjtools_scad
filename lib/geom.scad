
module outline(a, n=1, col="red", d=1, fill=true) {
  if (fill)
    polygon(a);

  for (p = [0 : n : len(a)-1])
    translate([a[p].x, a[p].y, 0])
      color(col)
      sphere(d=d);
}


function ray(a, r) = [cos(a)*r, sin(a)*r];

function circlepts(n, r) = [ for (a=[0:n-1]) [cos(a*360/n) * r, sin(a*360/n) * r] ];


function dist(a, b) = sqrt((b.x-a.x)^2 + (b.y-a.y)^2);

function perimeter(a, i=0) =
  (i == len(a)-1)
  ? dist(a[i], a[0])
  : dist(a[i], a[i+1]) + perimeter(a, i+1);


function poly_interpolate(a, b, bias, n=0, style="subdivide") =
  assert(style=="subdivide" || style=="resample" || style=="uniform" || style=="dupe",
         str("ERROR: Invalid polygon interpolation expansion style '", style, "'"))
  (style == "subdivide") ? poly_interpolate_subdivide(a, b, bias, n)
  : (style == "resample") ? poly_interpolate_resample(a, b, bias, n)
  : (style == "uniform") ? poly_interpolate_uniform(a, b, bias, n)
  : poly_interpolate_dupe(a, b, bias, n);

function poly_interpolate_subdivide(a, b, bias, n=0) =
  let (
       len_ = (n>0) ? n : max(len(a), len(b)),
       a_ = (len(a) < len_) ? poly_subdivide(a, len_) : a,
       b_ = (len(b) < len_) ? poly_subdivide(b, len_) : b
       )
  (1-bias)*a_ + bias*b_;

function poly_interpolate_resample(a, b, bias, n=0) =
  let (
       len_ = (n>0) ? n : max(len(a), len(b)),
       a_ = (len(a) < len_) ? poly_resample(a, len_) : a,
       b_ = (len(b) < len_) ? poly_resample(b, len_) : b
       )
  (1-bias)*a_ + bias*b_;

function poly_interpolate_uniform(a, b, bias, n=0) =
  let (
       len_ = (n>0) ? n : max(len(a), len(b)),
       a_ = (len(a) < len_) ? poly_resample_uniform(a, len_) : a,
       b_ = (len(b) < len_) ? poly_resample_uniform(b, len_) : b
       )
  (1-bias)*a_ + bias*b_;

function poly_interpolate_dupe(a, b, bias, n=0) =
  let (
       len_ = (n>0) ? n : max(len(a), len(b)),
       a_ = (len(a) < len_) ? poly_dupe(a, len_) : a,
       b_ = (len(b) < len_) ? poly_dupe(b, len_) : b
       )
  (1-bias)*a_ + bias*b_;


function poly_dupe(q, n) =
  let (
       midpts = floor(n/len(q)),
       excess = n % len(q)
       )
  [ for (seg = [0:len(q)-1])
      let (
           p = q[seg],
           k = midpts + ((seg < excess)? 1 : 0)
           )
        for (i = [0:k-1])
          p
    ];


function poly_resample_uniform(q, n) =
  (perimeter(q) <= 0)
  ? poly_dupe(q, n)
  : let (
         midpts = floor(n/len(q)),
         excess = n % len(q)
         )
  [
   for (seg = [0:len(q)-1])
     let (
          p1 = q[seg],
          k = midpts + ((seg < excess)? 1 : 0)
          )
       for (i = [0:k-1])
         let (
              p2 = q[(seg+1)%len(q)],

              dx = p2.x - p1.x,
              dy = p2.y - p1.y,
              d = sqrt(dx^2 + dy^2)
              )
           [p1.x+dx*i/k, p1.y+dy*i/k]
   ];


function mk_buckets(q) =
  let (
       distances = [
                    for (seg = [0:len(q)-1])
                      let (
                           p1 = q[seg],
                           p2 = q[(seg+1)%len(q)]
                           )
                        dist(p1, p2)
                    ]
       )
  [
   for (seg = [0:len(distances)-1])
     sum(distances, 0, seg)
  ];

function bucket(buckets, d, i=0) =
  assert(i < len(buckets), "Bucket search went beyond range")
  (buckets[i] > d) ? i : bucket(buckets, d, i+1);


function poly_rebucket(q, n) =
  let (
       per = perimeter(q)
      )
  (per <= 0)
  ? poly_dupe(q, n)
  : let (
         buckets = mk_buckets(q)
        )
  [
   for (i = [0:n-1])
     let (
          p = i/n * per,
          b = bucket(buckets, p),

          prior = (b==0)? 0 : buckets[b-1],

          p1 = q[b],
          p2 = q[(b+1)%len(q)],

          dx = p2.x - p1.x,
          dy = p2.y - p1.y,

          d = sqrt(dx^2 + dy^2),

          frac = (p-prior)/d
          )
       [p1.x+dx*frac, p1.y+dy*frac]
   ];

function poly_resample(q, n) =
  let (
       per = perimeter(q)
       )
  (per <= 0)
  ? poly_dupe(q, n)
  : poly_resample_(q, 0, 0, n, 0, per);

function poly_resample_(q, e, i, n, per_acc, per) =
  let (
       p1 = q[e],
       p2 = q[(e+1)%len(q)],

       dx = p2.x - p1.x,
       dy = p2.y - p1.y,
       d = sqrt(dx^2 + dy^2),

       per_i = i/n * per,
       frac = (per_i-per_acc)/d,

       p = [p1.x+dx*frac, p1.y+dy*frac]
       )
  (per_i >= per_acc+d)
  ? poly_resample_(q, e+1, i, n, per_acc+d, per)
  : (i < n-1)
  ? concat([p], poly_resample_(q, e, i+1, n, per_acc, per))
  : [p];


function qsort_inv_y(q) =
  (len(q) <= 0)
  ? []
  : let(
        pivot   = q[floor(len(q)/2)],
        lesser  = [ for (v = q) if (v.y  < pivot.y) v ],
        equal   = [ for (v = q) if (v.y == pivot.y) v ],
        greater = [ for (v = q) if (v.y  > pivot.y) v ]
        )
  concat(qsort_inv_y(greater), equal, qsort_inv_y(lesser))
  ;

function qsort_x(q) =
  (len(q) <= 0)
  ? []
  : let(
        pivot   = q[floor(len(q)/2)],
        lesser  = [ for (v = q) if (v.x  < pivot.x) v ],
        equal   = [ for (v = q) if (v.x == pivot.x) v ],
        greater = [ for (v = q) if (v.x  > pivot.x) v ]
        )
  concat(qsort_x(lesser), equal, qsort_x(greater))
  ;

function allocate_pts(q, n) =
  let (
       per = perimeter(q),

       distances = [
                    for (i = [0:len(q)-1])
                      let (
                           p1 = q[i],
                           p2 = q[(i+1)%len(q)]
                           )
                        [i, dist(p1, p2)]
                   ],

       initial = [
                  for (i = [0:len(q)-1])
                    max(1, floor(n*(distances[i].y/per)))
                 ],

       excess = n - sum(initial)
       )
  (excess == 0)
  ? initial
  : let (
         ranked = qsort_inv_y(distances),
         counts = concat(
                         [
                          for (i = [0:abs(excess)-1])
                            [ranked[i].x, initial[ranked[i].x] + ((excess > 0)?1:-1)]
                          ],
                         [
                          for (i = [abs(excess):len(distances)-1])
                            [ranked[i].x, initial[ranked[i].x]]
                          ]
                         )
         )
  [
   for (p = qsort_x(counts))
     p.y
  ];

function poly_subdivide(q, n) =
  (perimeter(q) <= 0)
  ? poly_dupe(q, n)
  : let (
         counts = allocate_pts(q, n)
         )
  [
   for (seg = [0:len(q)-1])
     let (
          p1 = q[seg],
          p2 = q[(seg+1)%len(q)],
          k = counts[seg]
          )
       for (i = [0:k-1])
         let (
              dx = p2.x - p1.x,
              dy = p2.y - p1.y,
              d = sqrt(dx^2 + dy^2)
              )
           [p1.x+dx*i/k, p1.y+dy*i/k]
   ];
