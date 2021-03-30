# Runs prior to every test
setup() {
    # Load our script file.
    source ./src/scripts/install.sh
}

@test "1: Check Install" {
    export COSIGN_VERSION=v0.1.0
    echo "Running cosing install"
    run Install_Cosign
    echo "test output status: $status"
    echo "Output:"
    echo "$output"
    echo " --- "
    [ "$status" -eq 0 ] # Check for no exit error
}