data() { cat<<EOF
#ACTUAL	EXPERT_COCOMO	2PAIR_Median	IMC_Median
#50	60.8	869.9090731	781.97
320	506.9	831.6713059	723.32
329	476	798.2775197	781.97
336	171	814.8308056	773.33
492	380.8	727.097363	698.64
552	354.9	1000.469015	773.33
637	103	796.3543377	773.33
648	366.2	850.0151272	717.61
691	1300	842.7594438	723.32
789	660.8	540.9978165	675.99
1042.8	910	940.2977906	838.36
1047.9	594.2	797.9114028	695.36
1080	219	787.2828733	760.58
1705	2610	813.514289	773.33
1735.4	1556.7	553.5598155	693.63
1830	1614.7	577.8208136	716.94
2519	1388.8	655.73658	698.64
3291.8	1370.6	729.7714593	723.32
EOF
}
mkdir -p /tmp/$USER
data > /tmp/$USER/d
data | gawk 'function abs(x) { return x< 0 ? -1*x : x} 
/#/ {next} {
n++
ab=int(100*abs($2 - $1)/$1)
ac=int(100*abs($3 - $1)/$1)
ad=int(100*abs($4 - $1)/$1) 
abss[n] = ab
acs[n]= ac
ads[n]= ad
print $0,ab,ac,ad
}
END {asort(abss); asort(acs); asort(ads)
     #printf("#coc--I") ; for (n in abss) printf(" ,%s",abss[n])
     #printf("\n#SLOPE") ; for (n in acs)  printf(" ,%s",acs[n])
     #printf("\n#SAMPLE") ; for (n in ads) printf(" ,%s",ads[n])
     #print ""
     n = int(n/2)
     print "## ",abss[n],acs[n],ads[n] 
}
'|  sort -k 5 -n | cat -n > /tmp/$USER/nums


  	#SAMPLE ,137 ,19 ,21 ,29 ,33 ,40 ,42 ,54 ,60 ,60 ,72 ,78 ,4 ,126 ,10 ,130 ,14
     	#SLOPE ,159 ,25 ,27 ,31 ,31 ,47 ,52 ,68 ,68 ,73 ,77 ,81 ,9 ,142 ,21 ,142 ,23    
    	#coc--I ,88 ,16 ,22 ,35 ,43 ,43 ,44 ,44 ,49 ,53 ,58 ,58 ,10 ,79 ,11 ,83 ,12


gnuplot<<EOF
set ylabel "predicted effort (months)"
set xlabel "actual effort (months)"
set terminal postscript eps enhanced color "Helvetica" 15
set output "estimates.eps"
set size 0.5,0.5
set key top left
set xtics (0,1000,2000,3000)
set ytics (0,1000,2000,3000)
set arrow 1 from 0,0 to 3500,3500 nohead
set yrange [0:5000]
set xrange [0:3500]

plot "/tmp/$USER/d" using 1:2 title "COCOMO-II",\
     "/tmp/$USER/d" using 1:3 title "SLOPE",\
     "/tmp/$USER/d" using 1:4 title "SAMPLE"
EOF
gnuplot<<EOF
set title "%MRE = abs(pred - actual)/actual * 100 "
set ylabel "%MRE"
set xlabel "NASA10 projects (sorted by COCOMO-II results)"
set terminal postscript eps enhanced color "Helvetica" 15
set output "mmre.eps"
set size 0.5,0.5
set key top right
set noxtics
set ytics (0,50,100,150)
set yrange [0:230]
set xrange [0:18]


plot "/tmp/$USER/nums" using 1:6 title "COCOMO-II" with linesp,\
     "/tmp/$USER/nums" using 1:7 title "SLOPE" with linesp#,\
#     "/tmp/$USER/nums" using 1:8 title "SAMPLE" with linesp
EOF
epstopdf estimates.eps
epstopdf mmre.eps
