function between(r, r1, r2) {
  lo = r1 < r2 ? r1 : r2;
  hi = r1 > r2 ? r1 : r2;

  # if(r >= lo && r <= hi) {
  #   print r, "in [" lo, ",", hi "]";
  # }
  return r >= lo && r <= hi;
}

function abs(n) { # can't believe this isn't built in
  return n < 0 ? (-n) : n;
}

# Munge for a nicer language

BEGIN {
  FS = ",";
  na = 0;
  nb = 0;
}

{
  x = 0;
  y = 0;

  for(i = 1; i <= NF; i++) {
    oldx = x;
    oldy = y;
    
    dir = substr($i, 1, 1);
    len = substr($i, 2);

    if(dir == "R") {
      x += len;
    } else if(dir == "U") {
      y += len;
    } else if(dir == "L") {
      x -= len;
    } else if(dir == "D") {
      y -= len;
    }

    if(NR == 1) {
      Ax1[i-1] = oldx;
      Ay1[i-1] = oldy;
      Ax2[i-1] = x;
      Ay2[i-1] = y;
      na++;
      # pathA[i] += (abs(x - oldx) + abs(y - oldy));
      pathA[i] += pathA[i - 1] + (abs(x - oldx) + abs(y - oldy));
      print "pathA", pathA[i];
    } else if(NR == 2) {
      Bx1[i-1] = oldx;
      By1[i-1] = oldy;
      Bx2[i-1] = x;
      By2[i-1] = y;
      nb++;
      # pathB[i] += (abs(x - oldx) + abs(y - oldy));
      pathB[i] += pathB[i - 1] + (abs(x - oldx) + abs(y - oldy));
      print "pathB", pathB[i];
    }

    print oldx " " oldy " " x " " y;
  }
}

# Okay maybe that nicer langauge doesn't want to be bothered right now.
END {
  for(ia = 0; ia < na; ia++) {
    xa1 = Ax1[ia];
    ya1 = Ay1[ia];
    xa2 = Ax2[ia];
    ya2 = Ay2[ia];
    for(ib = 0; ib < nb; ib++) {
      xb1 = Bx1[ib];
      yb1 = By1[ib];
      xb2 = Bx2[ib];
      yb2 = By2[ib];

      if(((between(xa1, xb1, xb2) ||
           between(xa2, xb1, xb2)) &&
          (between(yb1, ya1, ya2) ||
           between(yb2, ya1, ya2))) ||
         ((between(ya1, yb1, yb2) ||
           between(ya2, yb1, yb2)) &&
          (between(xb1, xa1, xa2) ||
           between(xb2, xa1, xa2)))) {
        # Axis-aligned perpendicular crossings only
        crossing = "";
        manhattan = 0;
        if(xa1 == xa2 && yb1 == yb2) { # horiz cross vert
          crossing = xa1 " " yb1;
          manhattan = abs(xa1) + abs(yb1);
          walksA[nw] = pathA[ia] + abs(xa1 - xb1);
          walksB[nw] = pathB[ib] + abs(yb1 - ya1);
          walks[nw] = walksA[nw] + walksB[nw];
          print "walks", walks[nw];
          nw++;
        } else if(ya1 == ya2 && xb1 == xb2) { # vert cross horiz
          crossing = xb1 " "  ya1;
          manhattan = abs(xb1) + abs(ya1);
          walksA[nw] = pathA[ia] + abs(ya1 - yb1);
          walksB[nw] = pathB[ib] + abs(xb1 - xa1);
          walks[nw] = walksA[nw] + walksB[nw];
          print "walks", walks[nw];
          nw++;
        }
        if(manhattan != 0) {
          crossings[nc] = crossing;
          manhattans[nc] = manhattan;
          nc++;
        }
      }
    }
  }

  for(ic in crossings) {
    if(minwalk == 0) {
      minwalk = walks[iw++];
    } else {
      walk = walks[iw++];
      minwalk = minwalk < walk ? minwalk : walk;
    }
    # print crossings[ic];
    # print manhattans[ic];
  }

  print minwalk;
}
