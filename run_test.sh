#!/bin/bash -eu

RUSTFLAGS=-Zsanitizer=address \
    cargo \
    +nightly \
    test \
    -Zbuild-std=panic_abort,std \
    -Zpanic-abort-tests \
    --target x86_64-unknown-linux-gnu
