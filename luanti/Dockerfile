# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DESCRIPTION
#   Luanti Pterodactyl Yolk (5.6.0 and above)
#
# AUTHORS
#   OrugA <oruga@luanti.es>
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM "ghcr.io/luanti-es/debian:13.1-trixie-slim"

ARG LUANTI_VERSION="5.6.0"
ENV LUANTI_VERSION="${LUANTI_VERSION}"

LABEL org.opencontainers.image.title="Pterodactyl Luanti Yolk"
LABEL org.opencontainers.image.version="${LUANTI_VERSION}-oruga-luanti-es"
LABEL org.opencontainers.image.description="Pterodactyl Luanti Yolk - ${LUANTI_VERSION}-oruga-luanti-es"
LABEL org.opencontainers.image.authors="OrugA <oruga@luanti.es>"
LABEL org.opencontainers.image.source="https://github.com/luanti-es/pterodactyl-eggs"

ARG TZ="Europe/Madrid"
ENV TZ="${TZ}"

ARG DEBIAN_FRONTEND="noninteractive"

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
  # Add sudo access to user
  echo 'container ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; \
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
  # Until version 5.9 Minetest uses custom irrlicht which needs to match with
  # the one used at the time of the release, otherwise the build may fail.
  # Also older irc mods depends on older luasocket version. We will match under
  # luanti version, just because both irc mod and luanti will be upgraded at
  # the same time.
  if [ "${LUANTI_VERSION}" = "5.6.0" ]; then \
    LUANTI_NAME="minetest"; \
    LUASOCKET_VERSION="v3.1.0"; \
    IRRLICHT_VERSION="1.9.0mt7"; \
  elif [ "${LUANTI_VERSION}" = "5.9.0" ]; then \
    LUANTI_NAME="EDITME"; \
    LUASOCKET_VERSION="v3.1.0"; \
    IRRLICHT_VERSION="shipped"; \
  fi; \
  #
  # Set the base path
  mkdir -pv /build; \
  cd /build; \
  #
  # As we cannot use real version for luajit (they use rolling releases), we then
  # stick to the latest stable commit, by means of its hash:
  # - 20251103 - v2.1 - 8518c0b40b1734901de888a0a363450c0709d3f8
  git clone https://github.com/LuaJIT/LuaJIT luajit; \
  cd luajit; \
  git checkout "8518c0b40b1734901de888a0a363450c0709d3f8"; \
  make -j CCOPT=" -O2 -fomit-frame-pointer -fPIC " \
          XCFLAGS="-DLUAJIT_ENABLE_GC64" amalg PREFIX="/usr/local"; \
  make install PREFIX="/usr/local" DESTDIR="/"; \
  cd ..; \
  #
  # Get luasocket and compile it against luajit
  ln -sf "luajit-2.1" "/usr/local/include/lua5.1"; \
  git clone --depth=1 --branch="${LUASOCKET_VERSION}" https://github.com/diegonehab/luasocket; \
  cd luasocket; \
  make -j PLAT=linux DEBUG=NODEBUG LUAV=5.1 \
          LUAINC_linux_base="/usr/local/include" \
          LDFLAGS_linux="-O -shared -fpic -Wl,--no-undefined /usr/local/lib/libluajit-5.1.a -lm -ldl -o "; \
  make install PREFIX="/usr/local"; \
  cd ..; \
  #
  # Get irrlicht (irrlichtmt) if required
  IRRLICHT_ARGS=""; \
  if ! [ "${IRRLICHT_VERSION}" = "shipped" ]; then \
    git clone --depth=1 --branch="${IRRLICHT_VERSION}" https://github.com/minetest/irrlicht; \
    IRRLICHT_ARGS="-DIRRLICHT_INCLUDE_DIR=/build/irrlicht/include -DENABLE_GLES=0"; \
  fi; \
  #
  # Install Luanti, server-only flavour
  wget -Osrc.zip "https://github.com/luanti-org/luanti/archive/${LUANTI_VERSION}.zip"; \
  unzip src.zip; \
  rm src.zip; \
  cd "luanti-${LUANTI_VERSION}"; \
  mkdir build; \
  cd build; \
  cmake .. \
    -G Ninja ${IRRLICHT_ARGS} \
    -DCMAKE_INSTALL_PREFIX="/usr" \
    -DCUSTOM_BINDIR="/usr/bin" \
    -DCUSTOM_DOCDIR="/usr/share/doc/${LUANTI_NAME}" \
    -DCUSTOM_SHAREDIR="/usr/share/${LUANTI_NAME}" \
    -DLUA_INCLUDE_DIR="/build/luajit/src/" \
    -DLUA_LIBRARY="/build/luajit/src/libluajit.a" \
    # All CMake variables, from:
    # https://github.com/luanti-org/luanti/tree/master/doc/compiling#cmake-options
    # Build Luanti client
    -DBUILD_CLIENT=0 \
    # Build Luanti server
    -DBUILD_SERVER=1 \
    # Build unittest sources
    -DBUILD_UNITTESTS=0 \
    # Build benchmark sources
    -DBUILD_BENCHMARKS=0 \
    # Build doxygen documentation
    -DBUILD_DOCUMENTATION=0 \
    # Type of build (Release vs. Debug)
    -DCMAKE_BUILD_TYPE="Release" \
    # Precompile some headers (experimental; requires CMake 3.16 or later)
    -DPRECOMPILE_HEADERS=0 \
    # Links with SDL2::SDL2-static instead of SDL2::SDL2
    -DUSE_SDL2_STATIC=1 \
    # Build with cURL; Enables use of online mod repo, public serverlist and remote media fetching via http
    -DENABLE_CURL=1 \
    # Build with (n)curses; Enables a server side terminal (command line option: --terminal)
    -DENABLE_CURSES=1 \
    # Build with Gettext; Allows using translations
    -DENABLE_GETTEXT=1 \
    # Build with LevelDB; Enables use of LevelDB map backend
    -DENABLE_LEVELDB=0 \
    # Build with libpq; Enables use of PostgreSQL map backend (PostgreSQL 9.5 or greater recommended)
    -DENABLE_POSTGRESQL=0 \
    # Build with libhiredis; Enables use of Redis map backend
    -DENABLE_REDIS=0 \
    # Build with LibSpatial; Speeds up AreaStores
    -DENABLE_SPATIAL=0 \
    # Build with OpenSSL; Speeds up SHA1 and SHA2 hashing
    -DENABLE_OPENSSL=1 \
    # Build with OpenAL, libogg & libvorbis; in-game sounds
    -DENABLE_SOUND=0 \
    # Build with LuaJIT (much faster than non-JIT Lua)
    -DENABLE_LUAJIT=1 \
    # Build with Prometheus metrics exporter (listens on tcp/30000 by default)
    -DENABLE_PROMETHEUS=1 \
    # Use GMP from system (much faster than bundled mini-gmp)
    -DENABLE_SYSTEM_GMP=1 \
    # Use JsonCPP from system
    -DENABLE_SYSTEM_JSONCPP=1 \
    # Create a portable install (worlds, settings etc. in current directory)
    -DRUN_IN_PLACE=0 \
    # Whether to enable update checks by default
    -DENABLE_UPDATE_CHECKER=0 \
    # Whether the Development Test game should be installed alongside Luanti
    -DINSTALL_DEVTEST=1 \
    # Enable profiling using GProf
    -DUSE_GPROF=0 \
    # Fetch and build with the Tracy profiler client
    -DBUILD_WITH_TRACY=0 \
    # Text to append to version (e.g. VERSION_EXTRA=foobar -> Luanti 5.10.0-foobar)
    -DVERSION_EXTRA="oruga-luanti-es" \
  ; \
  ninja; \
  ninja install; \
  #
  # Normalize name for direct egg compatibility across different versions
  if [ -f "/usr/bin/minetest" ]; then \
    ln -s "/usr/bin/minetest" "/usr/bin/luanti"; \
  fi ; \
  if [ -f "/usr/bin/minetestserver" ]; then \
    ln -s "/usr/bin/minetestserver" "/usr/bin/luantiserver"; \
  fi ; \
  cd /; \
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

USER "container"
WORKDIR "/home/container"
ENV USER="container"
ENV HOME="/home/container"

# Use tini to launch our entrypoint, and ensure signals reach the server
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/usr/bin/tini", "-g", "-p", "SIGINT", "--" ]
CMD [ "/entrypoint.sh" ]
