def a12(name1,lst1,name2,lst2,rev=True):
  lst1, lst2 = sorted(lst1), sorted(lst2)
  m, n       = len(lst1) , len(lst2)
  mid1, mid2 = int(m/2)  , int(n/2)
  med1, med2 = lst1[mid1], lst2[mid2]
  if med1 < med2:
    return a12(name2,lst2,name1,lst1)
  more,same = 0.0, 0.0
  for x in lst1:
    for y in lst2:
      if   x==y : same += 1
      elif rev     and x > y : more += 1
      elif not rev and x < y : more += 1
  return name1,med1,name2,med2,(more + 0.5*same)  / (m*n)

def report(l):
  for one in l:
    for two in l:
      if one[0] > two[0]:
        print a12(one[0], one[1:],two[0], two[1:])

report([
  ['SLOPE' ,159 ,25 ,27 ,31 ,31 ,47 ,52 ,68 ,68 ,73 ,77 ,81 ,9 ,142 ,21 ,142 ,23],    
	['SAMPLE' ,137 ,19 ,21 ,29 ,33 ,40 ,42 ,54 ,60 ,60 ,72 ,78 ,4 ,126 ,10 ,130 ,14],
  ['coc--I' ,88 ,16 ,22 ,35 ,43 ,43 ,44 ,44 ,49 ,53 ,58 ,58 ,10 ,79 ,11 ,83 ,12]
])
