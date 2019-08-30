#include <stdio.h>

#define fixnum_mask  3
#define fixnum_tag   0
#define fixnum_shift 2

#define string_mask  7
#define string_tag   3

#define empty_list_mask 8
#define empty_list_tag  47

int main(int argc, char** argv)
{
	__int64_t val = ___reserved_main();

	if ((val & fixnum_mask) == fixnum_tag)
	{
		printf("%d\n", val >> fixnum_shift);
	}
	else if ((val & string_mask) == string_tag)
	{
		printf("%s\n", (char *) (val & (~string_mask)));
	}
	else if (val == empty_list_tag)
	{
		printf("()\n");
	}
	else
	{
		printf("%x\n", val);
	}

	return 0;
}
