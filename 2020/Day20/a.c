#define __STDC_FORMAT_MACROS
#include <inttypes.h>
#include <stdio.h>

#define TILES_SIZE 256
#define BUF_SIZE 256

/* uint64_t i;
printf("%"PRIu64"\n", i); */

/* https://graphics.stanford.edu/~seander/bithacks.html#ReverseParallel */
uint16_t reverse16(uint64_t v) {
  // swap odd and even bits
  v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1);
  // swap consecutive pairs
  v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2);
  // swap nibbles ... 
  v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4);
  // swap bytes
  v = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8);

  return v;
}

/* Reverse the lowest 10 bits of a uint64_t */
uint16_t reverse10(uint64_t v) {
  return reverse16(v) >> 6;
}

typedef struct Tile {
  uint16_t index;

  uint16_t lines[10];
  uint16_t edges[8];

  uint64_t num_neighbors;
  struct Tile *neighbors[4];
} Tile;

int Tile_dump(Tile *tile) {
  int i;

  printf("Tile %04"PRIu16":\n", tile->index);
  for(i = 0; i < 10; ++i) {
    printf("  lines %"PRIu16"\n", tile->lines[i]);
  }
  for(i = 0; i < 8; ++i) {
    printf("  edges %"PRIu16"\n", tile->edges[i]);
  }

  return 1;
}

/* void *memcpy(void *dest, const void * src, size_t n) */
int Tile_init(Tile *tile, uint16_t index,  uint16_t lines[10]) {
  int i;
  uint16_t revlines[10];

  tile->index = index;
  for(i = 0; i < 10; ++i) {
    tile->lines[i] = lines[i] & 0x3FF;
  }

  for(i = 0; i < 10; ++i) {
    revlines[i] = reverse10(lines[i] & 0x3FF);
  }

  /* top bottom right left; big-endian little-endian */
  tile->edges[0] = lines[0] & 0x3FF;
  tile->edges[1] = lines[9] & 0x3FF;
  for(i = 0; i < 10; ++i) {
    tile->edges[2] <<= 1;
    tile->edges[2] |= (lines[i]) & 1;
  }
  for(i = 0; i < 10; ++i) {
    tile->edges[3] <<= 1;
    tile->edges[3] |= (lines[i] >> 9) & 1;
  }

  for(int i = 4; i < 8; ++i) {
    tile->edges[i] = reverse10(tile->edges[i - 4]);
  }

  /*tile->edges[4] = revlines[0] & 0x3FF;
  tile->edges[5] = revlines[9] & 0x3FF;
  for(i = 9; i >= 0; --i) {
    tile->edges[6] <<= 1;
    tile->edges[6] |= (lines[i]) & 1;
  }
  for(i = 9; i >= 0; --i) {
    tile->edges[7] <<= 1;
    tile->edges[7] |= (lines[i] >> 9) & 1;
  }*/

  tile->num_neighbors = 0;
  for(i = 0; i < 4; ++i) {
    tile->neighbors[i] = NULL;
  }

  return 1;
}

uint8_t Tile_fit(Tile *a, Tile *b) {
  uint8_t result;
  uint8_t i, j;
  for(i = 0; i < 8; ++i) {
    for(j = 0; j < 8; ++j) {
      if(a->edges[i] == b->edges[j]) {
        a->num_neighbors++;
        b->num_neighbors++;

        result = (i << 4) | j;
        return result;
      }
    }
  }
  return 0xFF;
}

int test_reversers() {
  int i;
  uint16_t v;
  uint16_t r10, r16, dr10, dr16;

  int error_count = 0;
  for(i = 0; i < 10; ++i) {
    v = (uint16_t)(((1<<10) - 5) + i);
    r16 = reverse16(v);
    r10 = reverse10(v);
    dr16 = reverse16(r16);
    dr10 = reverse10(r10);

    printf("%"PRIu16":\n", v);
    printf("reverse16(%"PRIu16") = %"PRIu16"\n", v, r16);
    printf("reverse10(%"PRIu16") = %"PRIu16"\n", v, r10);
    printf("reverse16(reverse16(%"PRIu16")) = %"PRIu16"\n", v, dr16);
    printf("reverse10(reverse10(%"PRIu16")) = %"PRIu16"\n", v, dr10);

    if(v == dr16) {
      printf("reverse16 is reversible!\n");
    } else {
      printf("reverse16 is not reversible! (%"PRIu16" != %"PRIu16")\n", v, dr16);
      ++error_count;
    }
    if(v == dr10) {
      printf("reverse10 is reversible!\n");
    } else {
      printf("reverse10 is not reversible! (%"PRIu16" != %"PRIu16")\n", v, dr10);
      ++error_count;
    }
  }

  printf("%d total errors\n", error_count);

  return error_count;
}

int main(int argc, char **argv) {
  int i, j;
  Tile tiles[TILES_SIZE];
  int num_tiles;
  char *fname;
  FILE *file;
  char buf[BUF_SIZE];

  char line[BUF_SIZE];
  uint16_t index;
  uint16_t lines[10];
  int line_index;

  uint8_t fit;
  uint8_t fit_i;
  uint8_t fit_j;

  uint64_t n_corners = 0, nbr_product = 1;

  Tile *tile_a, *tile_b;

  for(i = 0; i < 10; ++i) {
    lines[i] = 0;
  }

  if(argc < 2) {
    printf("Usage: %s <input file name>\n", argv[0]);
    return 1;
  }
  fname = argv[1];
  file = fopen(fname, "r");

  while(fgets(buf, BUF_SIZE, file) != 0) {
    if(buf[0] == 'T') {
      sscanf(buf, "Tile %"PRIu16":\n", &index);
    } else if(buf[0] == '.' || buf[0] == '#') {
      sscanf(buf, "%s", line);
      for(i = 0; i < 10; i++) {
        lines[line_index] <<= 1;
        if(line[i] == '.') {
          lines[line_index] |= 0;
        } else if(line[i] == '#') {
          lines[line_index] |= 1;
        } else{
          printf("\033[31mUnknown symbol '%c'\033[0m\n", buf[i]);
        }
      }

      ++line_index;

      if(line_index == 10) {
        Tile_init(tiles + num_tiles, index, lines);
        line_index = 0;
        ++num_tiles;
      }
    }
  }
  fclose(file);

  printf("Loaded %d tiles.\n", num_tiles);

  for(i = 0; i < num_tiles; ++i) {
    Tile_dump(tiles+i);
  }

  for(i = 0; i < num_tiles; ++i) {
    tile_a = tiles + i;
    for(j = 0; j < i; ++j) {
      tile_b = tiles + j;

      fit = Tile_fit(tile_a, tile_b);
      printf("%"PRIu8"", fit);
      if(fit != 255) {
        fit_i = (fit >> 4);
        fit_j = (fit & 0xF);
        printf(" (i=%"PRIu8"; j=%"PRIu8")", fit_i, fit_j);
      }
      printf("\n");
    }
  }

  for(i = 0; i < num_tiles; ++i) {
    printf("%"PRIu16" -> %"PRIu64" nbrs\n", tiles[i].index, tiles[i].num_neighbors);
    if(tiles[i].num_neighbors == 2) {
      printf("corner? %"PRIu16"\n", tiles[i].index);
      ++n_corners;
      nbr_product *= tiles[i].index;
    }
  }

  printf("%"PRIu64" corners found\n", n_corners);
  printf("%"PRIu64"\n", nbr_product);

  return 0;
}
