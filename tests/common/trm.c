
int main(const char *args);

#ifndef MAINARGS
#define MAINARGS ""
#endif
static const char mainargs[] = MAINARGS;

void _trm_init()
{
	// init system here
	main(mainargs);
	while(1);
}