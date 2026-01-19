Test leak when running `cargo test` with ASAN + panic=abort.

To reproduce, run `./run_test.sh`.

```
$ ./run_test.sh
    Finished `test` profile [unoptimized + debuginfo] target(s) in 0.03s
     Running unittests src/main.rs (target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa)

running 1 test
test test ... FAILED

failures:

---- test stdout ----
---- test stderr ----

=================================================================
==1610843==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 4 byte(s) in 1 object(s) allocated from:
    #0 0x55cd4e1994e4 in malloc /rustc/llvm/src/llvm-project/compiler-rt/lib/asan/asan_malloc_linux.cpp:67:3
    #1 0x55cd4e530b3b in <std::alloc::System as core::alloc::global::GlobalAlloc>::alloc /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/sys/alloc/unix.rs:14:22
    #2 0x55cd4e518c20 in __rustc::__rdl_alloc /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/alloc.rs:455:20
    #3 0x55cd4e5a6854 in <alloc::alloc::Global>::alloc_impl /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/alloc.rs:190:73
    #4 0x55cd4e5a9f08 in <alloc::alloc::Global as core::alloc::Allocator>::allocate /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/alloc.rs:251:14
    #5 0x55cd4e5ae231 in <alloc::raw_vec::RawVecInner>::with_capacity_in /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs:419:15
    #6 0x55cd4e5ab959 in <alloc::raw_vec::RawVec<u8>>::with_capacity_in /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs:187:20
    #7 0x55cd4e5a5d6b in <[u8]>::to_vec_in::<alloc::alloc::Global> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/slice.rs:400:16
    #8 0x55cd4e415dc3 in std::sys::helpers::small_c_string::run_with_cstr_stack::<core::option::Option<std::ffi::os_str::OsString>> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/sys/helpers/small_c_string.rs:48:18
    #9 0x55cd4e4155fc in std::sys::helpers::small_c_string::run_with_cstr::<core::option::Option<std::ffi::os_str::OsString>> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/sys/helpers/small_c_string.rs:28:18
    #10 0x55cd4e33f789 in std::env::_var_os /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/env.rs:264:5
    #11 0x55cd4e33f477 in std::env::_var /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/env.rs:227:11
    #12 0x55cd4e320def in std::env::var::<&str> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/env.rs:223:5
    #13 0x55cd4e1d9437 in test::test_main_static_abort /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/test/src/lib.rs:197:23
    #14 0x55cd4e1c7b62 in test_cargo_tests_leak::main /home/pauss/dev/tests/test-rust-std-tests-abort-leak/src/main.rs
    #15 0x55cd4e46727a in std::panic::catch_unwind::<&dyn core::ops::function::Fn<(), Output = i32> + core::panic::unwind_safe::RefUnwindSafe + core::marker::Sync, i32> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panic.rs:359:14
    #16 0x55cd4e4f29e5 in std::panicking::catch_unwind::do_call::<std::rt::lang_start_internal::{closure#0}, isize> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panicking.rs:581:40
    #17 0x55cd4e4f15ee in std::panicking::catch_unwind::<isize, std::rt::lang_start_internal::{closure#0}> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panicking.rs:544:19
    #18 0x55cd4e4671eb in std::panic::catch_unwind::<std::rt::lang_start_internal::{closure#0}, isize> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panic.rs:359:14
    #19 0x55cd4e4b9c12 in std::rt::lang_start_internal /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/rt.rs:171:5
    #20 0x55cd4e1c7fbf in std::rt::lang_start::<()> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/rt.rs:205:5
    #21 0x55cd4e1c7b9d in main (/home/pauss/dev/tests/test-rust-std-tests-abort-leak/target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa+0x30db9d) (BuildId: bd4c69f216c1b4942f288738109b016f6c3b8388)
    #22 0x7d23cd22a28a in __libc_start_main csu/../csu/libc-start.c:360:3
    #23 0x55cd4e10bb74 in _start (/home/pauss/dev/tests/test-rust-std-tests-abort-leak/target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa+0x251b74) (BuildId: bd4c69f216c1b4942f288738109b016f6c3b8388)

SUMMARY: AddressSanitizer: 4 byte(s) leaked in 1 allocation(s).

failures:
    test

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.17s

=================================================================
==1610841==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 96 byte(s) in 1 object(s) allocated from:
    #0 0x5710e79c94e4 in malloc /rustc/llvm/src/llvm-project/compiler-rt/lib/asan/asan_malloc_linux.cpp:67:3
    #1 0x5710e7d60b3b in <std::alloc::System as core::alloc::global::GlobalAlloc>::alloc /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/sys/alloc/unix.rs:14:22
    #2 0x5710e7d48c20 in __rustc::__rdl_alloc /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/alloc.rs:455:20
    #3 0x5710e7dd6854 in <alloc::alloc::Global>::alloc_impl /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/alloc.rs:190:73
    #4 0x5710e7dd9f08 in <alloc::alloc::Global as core::alloc::Allocator>::allocate /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/alloc.rs:251:14
    #5 0x5710e7dde231 in <alloc::raw_vec::RawVecInner>::with_capacity_in /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs:419:15
    #6 0x5710e7b3535b in <alloc::raw_vec::RawVec<alloc::string::String>>::with_capacity_in /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs:187:20
    #7 0x5710e7a3770d in <alloc::vec::Vec<alloc::string::String> as alloc::vec::spec_from_iter::SpecFromIter<alloc::string::String, std::env::Args>>::from_iter /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/vec/spec_from_iter.rs:33:9
    #8 0x5710e7a2e451 in <alloc::vec::Vec<alloc::string::String> as core::iter::traits::collect::FromIterator<alloc::string::String>>::from_iter::<std::env::Args> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs:3772:9
    #9 0x5710e7adc417 in <std::env::Args as core::iter::traits::iterator::Iterator>::collect::<alloc::vec::Vec<alloc::string::String>> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/core/src/iter/traits/iterator.rs:2032:9
    #10 0x5710e7a098c1 in test::test_main_static_abort /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/test/src/lib.rs:230:28
    #11 0x5710e79f7b62 in test_cargo_tests_leak::main /home/pauss/dev/tests/test-rust-std-tests-abort-leak/src/main.rs
    #12 0x5710e7c9727a in std::panic::catch_unwind::<&dyn core::ops::function::Fn<(), Output = i32> + core::panic::unwind_safe::RefUnwindSafe + core::marker::Sync, i32> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panic.rs:359:14
    #13 0x5710e7d229e5 in std::panicking::catch_unwind::do_call::<std::rt::lang_start_internal::{closure#0}, isize> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panicking.rs:581:40
    #14 0x5710e7d215ee in std::panicking::catch_unwind::<isize, std::rt::lang_start_internal::{closure#0}> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panicking.rs:544:19
    #15 0x5710e7c971eb in std::panic::catch_unwind::<std::rt::lang_start_internal::{closure#0}, isize> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panic.rs:359:14
    #16 0x5710e7ce9c12 in std::rt::lang_start_internal /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/rt.rs:171:5
    #17 0x5710e79f7fbf in std::rt::lang_start::<()> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/rt.rs:205:5
    #18 0x5710e79f7b9d in main (/home/pauss/dev/tests/test-rust-std-tests-abort-leak/target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa+0x30db9d) (BuildId: bd4c69f216c1b4942f288738109b016f6c3b8388)
    #19 0x7fbd59e2a28a in __libc_start_main csu/../csu/libc-start.c:360:3
    #20 0x5710e793bb74 in _start (/home/pauss/dev/tests/test-rust-std-tests-abort-leak/target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa+0x251b74) (BuildId: bd4c69f216c1b4942f288738109b016f6c3b8388)

Indirect leak of 134 byte(s) in 1 object(s) allocated from:
    #0 0x5710e79c94e4 in malloc /rustc/llvm/src/llvm-project/compiler-rt/lib/asan/asan_malloc_linux.cpp:67:3
    #1 0x5710e7d60b3b in <std::alloc::System as core::alloc::global::GlobalAlloc>::alloc /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/sys/alloc/unix.rs:14:22
    #2 0x5710e7d48c20 in __rustc::__rdl_alloc /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/alloc.rs:455:20
    #3 0x5710e7dd6854 in <alloc::alloc::Global>::alloc_impl /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/alloc.rs:190:73
    #4 0x5710e7dd9f08 in <alloc::alloc::Global as core::alloc::Allocator>::allocate /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/alloc.rs:251:14
    #5 0x5710e7dde231 in <alloc::raw_vec::RawVecInner>::with_capacity_in /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs:419:15
    #6 0x5710e7ddb959 in <alloc::raw_vec::RawVec<u8>>::with_capacity_in /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs:187:20
    #7 0x5710e7dd5d6b in <[u8]>::to_vec_in::<alloc::alloc::Global> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc/src/slice.rs:400:16
    #8 0x5710e7b6f872 in std::env::args_os /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/env.rs:857:21
    #9 0x5710e7b6f6e3 in std::env::args /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/env.rs:822:19
    #10 0x5710e7a098b3 in test::test_main_static_abort /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/test/src/lib.rs:230:16
    #11 0x5710e79f7b62 in test_cargo_tests_leak::main /home/pauss/dev/tests/test-rust-std-tests-abort-leak/src/main.rs
    #12 0x5710e7c9727a in std::panic::catch_unwind::<&dyn core::ops::function::Fn<(), Output = i32> + core::panic::unwind_safe::RefUnwindSafe + core::marker::Sync, i32> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panic.rs:359:14
    #13 0x5710e7d229e5 in std::panicking::catch_unwind::do_call::<std::rt::lang_start_internal::{closure#0}, isize> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panicking.rs:581:40
    #14 0x5710e7d215ee in std::panicking::catch_unwind::<isize, std::rt::lang_start_internal::{closure#0}> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panicking.rs:544:19
    #15 0x5710e7c971eb in std::panic::catch_unwind::<std::rt::lang_start_internal::{closure#0}, isize> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/panic.rs:359:14
    #16 0x5710e7ce9c12 in std::rt::lang_start_internal /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/rt.rs:171:5
    #17 0x5710e79f7fbf in std::rt::lang_start::<()> /home/pauss/.asdf/installs/rust/1.92.0/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/std/src/rt.rs:205:5
    #18 0x5710e79f7b9d in main (/home/pauss/dev/tests/test-rust-std-tests-abort-leak/target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa+0x30db9d) (BuildId: bd4c69f216c1b4942f288738109b016f6c3b8388)
    #19 0x7fbd59e2a28a in __libc_start_main csu/../csu/libc-start.c:360:3
    #20 0x5710e793bb74 in _start (/home/pauss/dev/tests/test-rust-std-tests-abort-leak/target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa+0x251b74) (BuildId: bd4c69f216c1b4942f288738109b016f6c3b8388)

SUMMARY: AddressSanitizer: 230 byte(s) leaked in 2 allocation(s).
error: test failed, to rerun pass `--bin test_cargo_tests_leak`

Caused by:
  process didn't exit successfully: `/home/pauss/dev/tests/test-rust-std-tests-abort-leak/target/x86_64-unknown-linux-gnu/debug/deps/test_cargo_tests_leak-fbac18a0befdc6fa` (signal: 6, SIGABRT: process abort signal)
```
