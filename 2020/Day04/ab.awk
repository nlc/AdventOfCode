# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

function validate(key, value) {
  print "validating " key " with value " value;
  if(key == "byr") {
    return value >= 1920 && value <= 2002;
  } else if(key == "iyr") {
    return value >= 2010 && value <= 2020;
  } else if(key == "eyr") {
    return value >= 2020 && value <= 2030;
  } else if(key == "hgt") {
    if(match(value, /([0-9]+)(cm|in)/, matches)) {
      len = matches[1];
      unit = matches[2];

      if(unit == "cm") {
        return len >= 150 && len <= 193;
      } else if(unit == "in") {
        return len >= 59 && len <= 76;
      } else {
        print "something has gone horribly wrong!";
        return false;
      }
    } else {
      return false;
    }
  } else if(key == "hcl") {
    return value ~ /#[0-9a-f]{6}/;
  } else if(key == "ecl") {
    return value ~ /(amb|blu|brn|gry|grn|hzl|oth)/;
  } else if(key == "pid") {
    # watch out for leading zeros causing trouble here
    return value ~ /^[0-9]{9}$/;
  } else {
    print key " doesn't match!";
  }
}


BEGIN {
  key_names["byr"] = "Birth Year";
  key_names["iyr"] = "Issue Year";
  key_names["eyr"] = "Expiration Year";
  key_names["hgt"] = "Height";
  key_names["hcl"] = "Hair Color";
  key_names["ecl"] = "Eye Color";
  key_names["pid"] = "Passport ID";
  key_names["cid"] = "Country ID";

  ignored_keys["cid"] = 1;

  for(k in key_names) {
    if(!(k in ignored_keys)) {
      required_keys[k] = 1;
    }
  }
  person_index = 1;

  valid_count = 0;
}

# Blank line
/^\s*$/ {
  person_index++;
}

# Line with fields
/\S/ {
  split($0, fields, / +/);

  for(field in fields) {
    split(fields[field], pair, /:/);
    key = pair[1];
    val = pair[2];

    if(key in required_keys) {
      key_base = "person" person_index;
      person_key = key_base "$" key;

      people[person_key] = val;
      person_keysets[key_base] = person_keysets[key_base] ";;" key;
    }
  }
}

END {
  for(person in person_keysets) {
    printf("%s ", person);
    printf("%s\n", person_keysets[person]);
    split(gensub(/^ *;;/, "", "g", person_keysets[person]), person_keys, /;;/);
    if(length(person_keys) == 7) {
      valid_fields = 0;
      for(metakey in person_keys) {
        key = person_keys[metakey];

        person_key = person "$" key;
        val = people[person_key];

        if(validate(key, val)) {
          print "OK!";
          valid_fields++;
        } else {
          print "BAD!"
        }
      }
      if(valid_fields == 7) {
        valid_count++;
      }
    }
  }

  print valid_count;
}
