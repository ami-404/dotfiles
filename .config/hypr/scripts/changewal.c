
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include <limits.h>

#define FPS 60
#define TYPE "any"
#define DURATION 3
#define BEZIER "0.4,0.2,0.4,1.0"

typedef struct {
    char **items;
    size_t size;
    size_t capacity;
} StringArray;

void add_to_array(StringArray *arr, const char *str) {
    if (arr->size == arr->capacity) {
        arr->capacity = arr->capacity ? arr->capacity * 2 : 16;
        arr->items = realloc(arr->items, arr->capacity * sizeof(char *));
        if (!arr->items) {
            perror("realloc");
            exit(EXIT_FAILURE);
        }
    }
    arr->items[arr->size] = strdup(str);
    arr->size++;
}

int has_image_extension(const char *filename) {
    const char *exts[] = {".jpg", ".jpeg", ".png", ".gif"};
    for (int i = 0; i < 4; i++) {
        const char *ext = exts[i];
        size_t len_f = strlen(filename);
        size_t len_e = strlen(ext);
        if (len_f >= len_e && strcasecmp(filename + len_f - len_e, ext) == 0) {
            return 1;
        }
    }
    return 0;
}

void search_dir(const char *dirpath, StringArray *pics) {
    DIR *dir = opendir(dirpath);
    if (!dir) return;

    struct dirent *entry;
    while ((entry = readdir(dir))) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        char path[PATH_MAX];
        snprintf(path, sizeof(path), "%s/%s", dirpath, entry->d_name);

        struct stat st;
        if (lstat(path, &st) == -1) continue;

        if (S_ISDIR(st.st_mode)) {
            search_dir(path, pics); // recursive search
        } else if (S_ISREG(st.st_mode) && has_image_extension(path)) {
            add_to_array(pics, path);
        }
    }
    closedir(dir);
}

int main() {
    const char *home = getenv("HOME");
    if (!home) {
        fprintf(stderr, "HOME not set\n");
        return EXIT_FAILURE;
    }

    char wallpaper_dir[PATH_MAX];
    snprintf(wallpaper_dir, sizeof(wallpaper_dir), "%s/Pictures/wallpapers", home);

    StringArray pics = {0};
    search_dir(wallpaper_dir, &pics);

    if (pics.size == 0) {
        fprintf(stderr, "No images found in %s\n", wallpaper_dir);
        return EXIT_FAILURE;
    }

    srand(time(NULL));
    const char *random_pic = pics.items[rand() % pics.size];

    char cmd[PATH_MAX * 2];
    snprintf(cmd, sizeof(cmd),
             "swww img \"%s\" --transition-fps %d --transition-type %s "
             "--transition-duration %d --transition-bezier %s",
             random_pic, FPS, TYPE, DURATION, BEZIER);
    system(cmd);

    snprintf(cmd, sizeof(cmd), "wal -i \"%s\"", random_pic);
    system(cmd);

    for (size_t i = 0; i < pics.size; i++) {
        free(pics.items[i]);
    }
    free(pics.items);

    return 0;
}
