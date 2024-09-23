# bin/bash

# make nested directory in the root upload (images) directory 
# curl --anyauth --user $CRED -k -X MKCOL 'https://iiif.acdh.oeaw.ac.at/upload/hsl-nfp' 

# add local dir with images for upload
cd ./new_facs && find . -exec curl -T {} 'https://iiif.acdh.oeaw.ac.at/upload/hsl-nfp/{}' --user $CRED -k \;

# delete images
# curl --anyauth --user $CRED -X "DELETE" "https://iiif.acdh.oeaw.ac.at/upload/hsl-nfp/"