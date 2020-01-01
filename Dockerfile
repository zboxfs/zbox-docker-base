FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -yq sudo curl file wget make pkg-config libssl-dev git && \
    apt-get autoremove -y

# install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH /root/.cargo/bin:$PATH
RUN rustup default stable

# define libsodium library environment variables
ENV LIBSODIUM libsodium-1.0.17
ENV LIBSODIUM_FILE ${LIBSODIUM}.tar.gz
ENV LIBSODIUM_HOME /opt/${LIBSODIUM}

# download libsodium and its signature
RUN mkdir ${LIBSODIUM_HOME}
WORKDIR /opt
RUN wget -q https://download.libsodium.org/libsodium/releases/${LIBSODIUM_FILE} && \
    wget -q https://download.libsodium.org/libsodium/releases/${LIBSODIUM_FILE}.sig

# import libsodium's author's public key
# saved from https://download.libsodium.org/doc/installation/
COPY libsodium.gpg.key .
RUN gpg --import libsodium.gpg.key && \
    gpg --verify ${LIBSODIUM_FILE}.sig

# compire and install libsodium
RUN tar zxf ${LIBSODIUM_FILE} && rm ${LIBSODIUM_FILE}
WORKDIR ${LIBSODIUM_HOME}
RUN ./configure --prefix=/opt && make && make install
ENV PKG_CONFIG_PATH=/opt/lib/pkgconfig

# make a dummy project and pre-build dependencies
RUN mkdir /tmp/zbox
WORKDIR /tmp/zbox
COPY ./zbox/Cargo.toml ./
RUN mkdir src && \
    echo "// dummy file" > src/lib.rs && \
    echo "fn main() {}" > build.rs && \
    cargo build && \
    rm -rf /tmp/zbox

# set working dir
WORKDIR /root/zbox
