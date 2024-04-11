https://stackoverflow.com/questions/59766239/how-to-build-a-rust-app-free-of-shared-libraries

rustup target add x86_64-unknown-linux-musl
rustup target add aarch64-unknown-linux-musl

RUSTFLAGS='-C link-arg=-s' cargo build --release --target x86_64-unknown-linux-musl

Note: to run on amazon graviton procs, I'll probably need to use an ARM-musl target.


To minimize executable size and build static executable, build with:
RUSTFLAGS='-C link-arg=-s -Zlocation-detail=none' cargo +nightly build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target x86_64-unknown-linux-gnu --release


Got error for static building against musl, but the above was small enough, so that's ok.
To minimize executable size and build static executable, build with:
RUSTFLAGS='-C link-arg=-s' cargo +nightly build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target x86_64-unknown-linux-musl --release

https://stackoverflow.com/questions/59766239/how-to-build-a-rust-app-free-of-shared-libraries