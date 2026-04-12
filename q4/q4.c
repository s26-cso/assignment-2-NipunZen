#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

typedef int (*fptr)(int, int);

int main()
{
    char line[512];
    char op[10];
    char lib_path[256];
    int num1 = 0, num2 = 0;

    while (fgets(line, sizeof(line), stdin) != NULL)
    {
        int i = 0;
        num1 = 0;
        num2 = 0;

        int j = 0;
        while (line[i] != ' ' && line[i] != '\0' && line[i] != '\n')
        {
            op[j++] = line[i++];
        }
        op[j] = '\0';

        while (line[i] == ' ')
            i++;

        int sign1 = 1;
        if (line[i] == '-')
        {
            sign1 = -1;
            i++;
        }
        while (line[i] >= '0' && line[i] <= '9')
        {
            num1 = num1 * 10 + (line[i] - '0');
            i++;
        }
        num1 *= sign1;

        while (line[i] == ' ')
            i++;

        int sign2 = 1;
        if (line[i] == '-')
        {
            sign2 = -1;
            i++;
        }
        while (line[i] >= '0' && line[i] <= '9')
        {
            num2 = num2 * 10 + (line[i] - '0');
            i++;
        }
        num2 *= sign2;

        int p = 0;

        char *prefix = "./lib";
        for (int j = 0; prefix[j] != '\0'; j++)
        {
            lib_path[p++] = prefix[j];
        }

        for (int j = 0; op[j] != '\0'; j++)
        {
            lib_path[p++] = op[j];
        }

        char *suffix = ".so";
        for (int j = 0; suffix[j] != '\0'; j++)
        {
            lib_path[p++] = suffix[j];
        }

        lib_path[p] = '\0';

        void *handle = dlopen(lib_path, RTLD_LAZY | RTLD_LOCAL);
        if (handle) {
        fptr operation = dlsym(handle, op);
            printf("%d\n", operation(num1, num2));
        }
        dlclose(handle);
    }

    return 0;
}
