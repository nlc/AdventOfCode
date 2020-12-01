BEGIN {
  printf("px1,py1,pz1,px2,py2,pz2,px3,py3,pz3,px4,py4,pz4,vx1,vy1,vz1,vx2,vy2,vz2,vx3,vy3,vz3,vx4,vy4,vz4,U1,U2,U3,U4,T1,T2,T3,T4,E");
}

{
  gsub(/_/, "-");
}

/^p$/ {
  printf("\n");
}

/[0-9]/ {
  for(i = 1; i <= NF; i++) {
    printf("%d,", $i);
  }
}
