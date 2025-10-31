# Eggs de Pterodactyl

## Descripción

Eggs de Pterodactyl para usar o usados en servidores de luanti.es.

## Enlaces de consulta/interés

- [Terminología de Pterodactyl](https://pterodactyl.io/project/terms.html)
- [Instalación y configuración de Panel](https://pterodactyl.io/panel/1.0/getting_started.html)
- [Instalación y configuración de Wings](https://pterodactyl.io/wings/1.0/installing.html)
- [Creación de Egg personalizado (fichero JSON)](https://pterodactyl.io/community/config/eggs/creating_a_custom_egg.html)
    - [Egg oficial de Minetest/Luanti](https://github.com/Ptero-Eggs/game-eggs/tree/main/minetest)
- [Creación de Yolk personalizado (imágen de Docker)](https://pterodactyl.io/community/config/eggs/creating_a_custom_image.html)
    - [Yolk oficial de Minetest/Luanti](https://github.com/Ptero-Eggs/yolks/tree/main/games/minetest)
    - [Instalador usado en el Yolk](https://github.com/Ptero-Eggs/yolks/tree/main/installers/debian)

## Desarrollo

Se parte de la base de Hispania, para poder migrarlo correctamente, y luego ir actualizandolo progresivamente.

El foco se pondrá en utilizar compilaciones de minetest/luanti propias con Debian como entorno, en lugar de Ubuntu.

### JSON anterior

En la interfaz no tenemos acceso al JSON del egg, pero si a la imagen que usa, que es `quay.io/parkervcp/pterodactyl-images:base_ubuntu`.

Con ella se sigue la pista hasta un JSON de 2020 que parece ser compatible, despues de ese, todos los encontrados usan la imagen actual.

Abrir el [JSON anterior](../sources/20201102_pelican-eggs_egg-minetest.json) copiado en este repositorio ([Ver original](https://github.com/pelican-eggs/eggs/blob/d131e2a911733924b6ac421cb46945f3b7ba3868/game_eggs/minetest/minetest/egg-minetest.json), [Descargar original](https://raw.githubusercontent.com/pelican-eggs/eggs/d131e2a911733924b6ac421cb46945f3b7ba3868/game_eggs/minetest/minetest/egg-minetest.json)).

Créditos: [Pelican Eggs](https://github.com/pelican-eggs).

### Imagen anterior

Por suerte `quay.io/parkervcp/pterodactyl-images:base_ubuntu` sigue vigente, y por seguridad la copiamos como `ghcr.io/luanti-es/parkervcp_pterodactyl-images:base_ubuntu` para usarla como nuestra base de arranque.

Aparte de la imagen del server, está la del instalador `ubuntu:18.04`, que aunque es la genérica oficial, tambien la copiamos para que todo tire de un mismo lugar como `ghcr.io/luanti-es/ubuntu:18.04`.

### JSON actual

Aunque existe *Pelican Eggs*, nos ceñimos a los oficiales de Pterodactyl, que parecen darle proridad a la estabilidad (Pelican es para Pterodactyl, lo que Ubuntu para Debian).

Abrir el [JSON actual](../sources/20250125_pterodactyl-eggs_egg-minetest.json) copiado en este repositorio ([Ver original](https://pterodactyleggs.com/egg/6735ff5d4924a4e9bbcbeda6), [Descargar original](https://pterodactyleggs.com/egg/6735ff5d4924a4e9bbcbeda6/download/egg-minetest.json)).

### Imagen actual

En este caso se usa `ghcr.io/ptero-eggs/games:minetest`, copiada como `ghcr.io/luanti-es/ptero-eggs_games_minetest:5.14.0` (no mantienen versioneado, siempre es *modo latest*, y en el momento de la copia era la versión 5.14.0).

Para el instalador se usa `ghcr.io/ptero-eggs/installers:debian`, copiada como `ghcr.io/luanti-es/ptero-eggs_installers_debian:12` (no mantienen versioneado, siempre es *modo latest*, y en el momento de la copia era la versión 12).

## Para futuro

- Crear flujo de trabajo con JSON mas ágil, ya que copiar aqui y pegar en Panel se hace tedioso. [En este enlace](https://stackoverflow.com/a/51981304) muestran como pasar de JSON a YAML conservando bloques de codigo en multilinea.
- Proyecto interesante y completo del que se pueden sacar ideas: [Pterodactyl-VPS-Egg](https://github.com/ysdragon/Pterodactyl-VPS-Egg), crear servidores VPS desde el Panel (usa proot, sustituto de chroot, para emular un sistema completo dentro del sistema de Wings/Egg).
