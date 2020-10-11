#!/bin/bash
set -ex

cd ../.git/hooks
echo '#!/bin/bash' > pre-commit
echo 'cd ./piwigo_sync' >> pre-commit
echo 'exec dart pub run dart_pre_commit' >> pre-commit
chmod a+x pre-commit
