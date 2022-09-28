
function slice(list, start, end) =
  [
   for (i = [start:end])
     list[i]
   ];

function trim(list, n=1) =
  (len(list) <= n)
  ? []
  : slice(list, 0, len(list)-1-n);

function pop(list, n=1) =
  (len(list) <= n)
  ? []
  : slice(list, n, len(list)-1);

function sum(arr, start=0, end=-1) =
  let (
       end_ = (end < 0) ? len(arr)-1 : end
       )
  arr[start] + ((start < end_)
                ? sum(arr, start+1, end)
                : 0);
