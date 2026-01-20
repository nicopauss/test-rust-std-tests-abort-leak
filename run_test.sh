#!/bin/bash -eux

set -o pipefail


rust_toolchain="nightly"
if [ -n "${RUSTUP_TOOLCHAIN:-}" ]; then
    rust_toolchain="${RUSTUP_TOOLCHAIN//bisector-/}"
fi

rustup component add rust-src --toolchain "$rust_toolchain" 2>&1 | \
    tee -a script_output.txt

RUSTFLAGS=-Zsanitizer=address \
    cargo \
    "+$rust_toolchain" \
    test \
    -Zbuild-std=panic_abort,std \
    -Zpanic-abort-tests \
    --target x86_64-unknown-linux-gnu 2>&1 | \
        tee -a script_output.txt
