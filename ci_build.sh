#!/bin/bash
set -e

# Run the bootstrap function from build.sh
source ./build.sh

# Override functions to avoid Docker operations
function docker_import() {
    echo "Skipping docker_import in CI environment"
    return 0
}

function docker_push() {
    echo "Skipping docker_push in CI environment"
    return 0
}

# Run just the bootstrap part
docker_bootstrap

# Print success message
echo "Bootstrap completed successfully. Tarball created at: ${image}.tar"

# Exit with success
exit 0
