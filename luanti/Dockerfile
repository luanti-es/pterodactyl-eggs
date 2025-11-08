# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DESCRIPTION
#   Luanti Pterodactyl Yolk (5.6.0 and above)
#
# AUTHORS
#   OrugA <oruga@luanti.es>
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM "ghcr.io/luanti-es/debian:13.1-trixie-slim"

LABEL org.opencontainers.image.description="Pterodactyl Luanti Yolk"
LABEL org.opencontainers.image.authors="OrugA <oruga@luanti.es>"
LABEL org.opencontainers.image.source="https://github.com/luanti-es/pterodactyl-eggs"

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Madrid"

# Until version 5.9 Minetest uses custom irrlicht, which is need to match with
# the one used at the time of the release, otherwise compilation may fail.
ENV LUANTI_VERSION="5.6.0" LUANTI_NAME="minetest" IRRLICHT_VERSION="1.9.0mt7"
#ENV LUANTI_VERSION="5.9.0" LUANTI_NAME="EDITME" IRRLICHT_VERSION="shipped"

# Do the full process in a single step, shrinking the image as much as possible
RUN set -ex; \
  #
  # Add default group
  groupadd --gid 1000 "container"; \
  #
  # Add default user
  useradd \
    --create-home \
    --home-dir "/home/container" \
    --comment "Pterodactyl Luanti Yolk user" \
    --shell "/bin/bash" \
    --uid 1000 \
    --gid 1000 \
    "container" \
  ; \
  #
  # Install common packages
  apt-get update; \
  apt-get install --yes --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    figlet \
    fontconfig \
    git \
    gnupg2 \
    iproute2 \
    libfreetype6-dev \
    libjsoncpp-dev \
    nano \
    openssl \
    rsync \
    sqlite3 \
    sudo \
    tar \
    tini \
    tzdata \
    unzip \
    wget \
    zip \
  ; \
  #
  # Install common packages for builders (luajit & luanti)
  apt-get update; \
  apt-get install --yes --no-install-recommends \
    build-essential \
    cmake \
    g++ \
    libcurl4-openssl-dev \
    libgmp-dev \
    libncurses-dev \
    libsqlite3-dev \
    libzstd-dev \
    ninja-build \
    zlib1g-dev \
  ; \
  #
  # As we cannot use real version for luajit (they use rolling releases), we then
  # stick to the latest stable commit, by means of its hash:
  # - 20251103 - v2.1 - 8518c0b40b1734901de888a0a363450c0709d3f8
  mkdir -pv build; \
  cd build; \
  git clone https://github.com/LuaJIT/LuaJIT luajit; \
  cd luajit; \
  git checkout "8518c0b40b1734901de888a0a363450c0709d3f8"; \
  make amalg; \
  cd ..; \
  #
  # Download, compile and install the server
  wget -Osrc.zip "https://github.com/luanti-org/luanti/archive/${LUANTI_VERSION}.zip"; \
  unzip src.zip; \
  rm src.zip; \
  IRRLICHT_ARGS=""; \
  if ! [ "${IRRLICHT_VERSION}" = "shipped" ]; then \
    git clone --depth=1 --branch="${IRRLICHT_VERSION}" https://github.com/minetest/irrlicht; \
    IRRLICHT_ARGS="-DIRRLICHT_INCLUDE_DIR=../../irrlicht/include -DENABLE_GLES=0"; \
  fi; \
  cd "luanti-${LUANTI_VERSION}"; \
  mkdir build; \
  cd build; \
  cmake .. \
    -G Ninja ${IRRLICHT_ARGS} \
    -DCMAKE_INSTALL_PREFIX="/usr" \
    -DCUSTOM_BINDIR="/usr/bin" \
    -DCUSTOM_DOCDIR="/usr/share/doc/minetest" \
    -DCUSTOM_SHAREDIR="/usr/share/minetest" \
    -DLUA_INCLUDE_DIR="../../luajit/src/" \
    -DLUA_LIBRARY="../../luajit/src/libluajit.a" \
    # All CMake variables, from:
    # https://github.com/luanti-org/luanti/tree/master/doc/compiling#cmake-options
    # Build Luanti client
    -DBUILD_CLIENT=FALSE \
    # Build Luanti server
    -DBUILD_SERVER=TRUE \
    # Build unittest sources
    -DBUILD_UNITTESTS=FALSE \
    # Build benchmark sources
    -DBUILD_BENCHMARKS=FALSE \
    # Build doxygen documentation
    -DBUILD_DOCUMENTATION=FALSE \
    # Type of build (Release vs. Debug)
    -DCMAKE_BUILD_TYPE="Release" \
    # Precompile some headers (experimental; requires CMake 3.16 or later)
    -DPRECOMPILE_HEADERS=FALSE \
    # Links with SDL2::SDL2-static instead of SDL2::SDL2
    -DUSE_SDL2_STATIC=TRUE \
    # Build with cURL; Enables use of online mod repo, public serverlist and remote media fetching via http
    -DENABLE_CURL=ON \
    # Build with (n)curses; Enables a server side terminal (command line option: --terminal)
    -DENABLE_CURSES=ON \
    # Build with Gettext; Allows using translations
    -DENABLE_GETTEXT=ON \
    # Build with LevelDB; Enables use of LevelDB map backend
    -DENABLE_LEVELDB=OFF \
    # Build with libpq; Enables use of PostgreSQL map backend (PostgreSQL 9.5 or greater recommended)
    -DENABLE_POSTGRESQL=OFF \
    # Build with libhiredis; Enables use of Redis map backend
    -DENABLE_REDIS=OFF \
    # Build with LibSpatial; Speeds up AreaStores
    -DENABLE_SPATIAL=OFF \
    # Build with OpenSSL; Speeds up SHA1 and SHA2 hashing
    -DENABLE_OPENSSL=ON \
    # Build with OpenAL, libogg & libvorbis; in-game sounds
    -DENABLE_SOUND=OFF \
    # Build with LuaJIT (much faster than non-JIT Lua)
    -DENABLE_LUAJIT=ON \
    # Build with Prometheus metrics exporter (listens on tcp/30000 by default)
    -DENABLE_PROMETHEUS=ON \
    # Use GMP from system (much faster than bundled mini-gmp)
    -DENABLE_SYSTEM_GMP=ON \
    # Use JsonCPP from system
    -DENABLE_SYSTEM_JSONCPP=ON \
    # Create a portable install (worlds, settings etc. in current directory)
    -DRUN_IN_PLACE=FALSE \
    # Whether to enable update checks by default
    -DENABLE_UPDATE_CHECKER=FALSE \
    # Whether the Development Test game should be installed alongside Luanti
    -DINSTALL_DEVTEST=TRUE \
    # Enable profiling using GProf
    -DUSE_GPROF=FALSE \
    # Fetch and build with the Tracy profiler client
    -DBUILD_WITH_TRACY=FALSE \
    # Text to append to version (e.g. VERSION_EXTRA=foobar -> Luanti 5.10.0-foobar)
    -DVERSION_EXTRA="oruga-luanti-es" \
  ; \
  ninja; \
  ninja install; \
  cd ../../..; \
  rm -rfv build; \
  #
  # Full cleanup to free as much space as possible
  apt-get remove --purge --auto-remove --yes \
    build-essential \
    cmake \
    g++ \
    libcurl4-openssl-dev \
    libgmp-dev \
    libncurses-dev \
    libsqlite3-dev \
    libzstd-dev \
    ninja-build \
    zlib1g-dev \
  ; \
  apt-get autoremove --purge; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/*;

RUN set -ex; \
  apt-get update; \
  apt-get install --yes --no-install-recommends \
    lua-socket \
    lua-socket-dev \
  ; \

USER container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD [ "/bin/bash", "/entrypoint.sh" ]
