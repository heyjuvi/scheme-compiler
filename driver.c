#include <stdio.h>

#define fixnum_mask  3
#define fixnum_tag   0
#define fixnum_shift 2

#define empty_list_mask 8
#define empty_list_tag  47

int main(int argc, char** argv)
{
	int val = ___reserved_main();

	if ((val & fixnum_mask) == fixnum_tag)
	{
		printf("%d\n", val >> fixnum_shift);
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
