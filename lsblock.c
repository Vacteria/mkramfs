#include <stdio.h>
#include <stdlib.h>
#include <blkid/blkid.h>

int main (int argc, char **argv)
{   
	char* progname = argv[0];
	char* device   = argv[1];
	
	if (argc < 2)
	{
		printf("ERROR : %s need some argument\n", progname);
		exit(EXIT_FAILURE);		
	}
   	   
	blkid_probe pr = blkid_new_probe_from_filename(device);
	if (!pr)
	{
		printf("ERROR : Failedo to open %s\n", device);
		exit(EXIT_FAILURE);
	}
	
	const char* uuid  = NULL;
	const char* label = NULL;
	const char* type  = NULL;
		  
	blkid_do_probe(pr);

	blkid_probe_lookup_value(pr, "UUID", &uuid, NULL);
	if (uuid == NULL)
	{
		printf("UUID=\n");
	} else {
		printf("UUID=%s\n", uuid);		
	}
	
	blkid_probe_lookup_value(pr, "LABEL", &label, NULL);
	if (label == NULL)
	{
		printf("LABEL=\n");
	} else {
		printf("LABEL=%s\n", label);
	}
	  
	blkid_probe_lookup_value(pr, "TYPE", &type, NULL);
	if (type == NULL)
	{
		printf("TYPE=\n");
	} else {
		printf("TYPE=%s\n", type);
	}
	  
	blkid_free_probe(pr);

	return(EXIT_SUCCESS);
}

//ls -1 /sys/class/block | grep -E "^(s|h)d[a-z][[:digit:]]+"
