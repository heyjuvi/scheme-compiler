#include <stdio.h>

#define fixnum_mask     3
#define fixnum_tag      0
#define fixnum_shift    2

#define	char_mask       255
#define char_tag        15
#define char_shift      8

#define bool_mask       127
#define bool_tag        31
#define bool_shift      7

#define string_mask     7
#define string_tag      3

#define empty_list_mask 8
#define empty_list_tag  47

#define heap_mask       7
#define heap_shift      3

int main(int argc, char** argv)
{
	__int64_t val = ___reserved_main();
	int return_val = 0;

	if ((val & fixnum_mask) == fixnum_tag)
	{
		printf("Return (fixnum): %d\n", val >> fixnum_shift);
		return_val = val >> fixnum_shift;
	}
	else if ((val & bool_mask) == bool_tag)
	{
		__int64_t bool_val = (val & (~bool_mask)) >> bool_shift;
		printf("Return (bool): %s\n", (bool_val ? "#t" : "#f"));
		return_val = bool_val ? 0 : -1;
	}
	else if ((val & string_mask) == string_tag)
	{
		printf("Return (string): %s\n", (char *) (val & (~string_mask)));
	}
	else if (val == empty_list_tag)
	{
		printf("Return (empty list): ()\n");
	}
	else
	{
		printf("Return (unknown type): %x\n", val);
	}

	return return_val;
}
