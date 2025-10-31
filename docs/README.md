# Eggs de Pterodactyl

## Descripción

Eggs de Pterodactyl para usar o usados en servidores de luanti.es.

## Desarrollo

Se parte de la base de Hispania, para poder migrarlo correctamente, y luego ir actualizandolo progresivamente.

El foco se pondrá en utilizar compilaciones de minetest/luanti propias con Debian como entorno, en lugar de Ubuntu.

### JSON anterior

En la interfaz no tenemos acceso al JSON del egg, pero si a la imagen que usa, que es `quay.io/parkervcp/pterodactyl-images:base_ubuntu`.

Con ella se sigue la pista hasta un JSON de 2020 que parece ser compatible, despues de ese, todos los encontrados usan la imagen actual.

Abrir el [JSON anterior](sources/20201102_pelican-eggs_egg-minetest.json) copiado en este repositorio ([Ver original](https://github.com/pelican-eggs/eggs/blob/d131e2a911733924b6ac421cb46945f3b7ba3868/game_eggs/minetest/minetest/egg-minetest.json), [Descargar original](https://raw.githubusercontent.com/pelican-eggs/eggs/d131e2a911733924b6ac421cb46945f3b7ba3868/game_eggs/minetest/minetest/egg-minetest.json)).

Créditos: [Pelican Eggs](https://github.com/pelican-eggs).

### Imagen anterior

Por suerte `quay.io/parkervcp/pterodactyl-images:base_ubuntu` sigue vigente, y por seguridad la copiamos como `ghcr.io/luanti-es/parkervcp_pterodactyl-images:base_ubuntu` para usarla como nuestra base de arranque.

Aparte de la imagen del server, está la del instalador `ubuntu:18.04`, que aunque es la genérica oficial, tambien la copiamos para que todo tire de un mismo lugar como `ghcr.io/luanti-es/ubuntu:18.04`.

### JSON actual

Aunque existe *Pelican Eggs*, nos ceñimos a los oficiales de Pterodactyl, que parecen darle proridad a la estabilidad (Pelican es para Pterodactyl, lo que Ubuntu para Debian).

Abrir el [JSON actual]() copiado en este repositorio ([Ver original](https://pterodactyleggs.com/egg/6735ff5d4924a4e9bbcbeda6), [Descargar original](https://pterodactyleggs.com/egg/6735ff5d4924a4e9bbcbeda6/download/egg-minetest.json)).

### Imagen actual

En este caso se usa `ghcr.io/ptero-eggs/games:minetest`, copiada como `ghcr.io/luanti-es/ptero-eggs_games_minetest:5.14.0` (no mantienen versioneado, siempre es *modo latest*, y en el momento de la copia era la versión 5.14.0).

Para el instalador se usa `ghcr.io/ptero-eggs/installers:debian`, copiada como `ghcr.io/luanti-es/ptero-eggs_installers_debian:12` (no mantienen versioneado, siempre es *modo latest*, y en el momento de la copia era la versión 12).
