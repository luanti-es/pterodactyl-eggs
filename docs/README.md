# Eggs de Pterodactyl

## Descripción

Eggs de Pterodactyl para usar o usados en servidores de luanti.es.

## Nota sobre copia de elementos

Como las cosas pueden no ser estables en el tiempo, cualquier elemento externo se copiará a este repositorio, minimizando asi errores en compilaciones presentes y futuras.

Elementos que se copiarán:

- Ficheros JSON de Egg (*)
- Imagen de Docker de SOs (**)
- Imagen de Docker de Pterodactyl (Installers y Yolks) (*)

> (*) No suelen estar versioneados y siempre se usa 'el último', lo que puede llevar a romper cosas, como que se espere la version 5.6.0, se obtenga la 5.14.0, y muchos mods dejen de ser compatibles.
> 
> (**) Siendo oficiales y estables no deben cambiar, pero a veces hay descuidos por parte del desarrollador, como usar una version tipo 15.4, y que esta acabe recibiendo cambios de 15.4.1, 15.4.2 ...

## Primeros pasos

No habiendose usado antes Pterodactyl, se parte de las fuentes oficiales para el despliegue de nodos con Panel y Wings, y de la necesidad de alojar el servidor *Hispania*.

Una vez migrado se intentará actualizar la versión del servidor, que a su vez necesitará actualizar o arreglar ciertos mods.

El foco se pondrá en compilar minetest/luanti con Debian como entorno, en lugar de usar precompilaciones y Ubuntu.

Los siguientes puntos reflejan los Eggs y Yolks 'últimos en el momento que se creó el servidor' y actuales.

### JSON anterior

En la interfaz no tenemos acceso al JSON del egg, pero si a la imagen que usa, que es `quay.io/parkervcp/pterodactyl-images:base_ubuntu`.

Con ella se sigue la pista hasta un JSON de 2020 que parece ser compatible, despues de ese, todos los encontrados usan la imagen actual.

Abrir el [JSON anterior](../sources/20201102_pelican-eggs_egg-minetest.json) copiado en este repositorio ([Ver original](https://github.com/pelican-eggs/eggs/blob/d131e2a911733924b6ac421cb46945f3b7ba3868/game_eggs/minetest/minetest/egg-minetest.json), [Descargar original](https://raw.githubusercontent.com/pelican-eggs/eggs/d131e2a911733924b6ac421cb46945f3b7ba3868/game_eggs/minetest/minetest/egg-minetest.json)).

### Imagen anterior

Por suerte `quay.io/parkervcp/pterodactyl-images:base_ubuntu` sigue vigente, y por seguridad la copiamos como `ghcr.io/luanti-es/parkervcp_pterodactyl-images:base_ubuntu` para usarla como nuestra base de arranque.

Aparte de la imagen del server, está la del instalador `ubuntu:18.04`, que aunque es la genérica oficial, tambien la copiamos para que todo tire de un mismo lugar como `ghcr.io/luanti-es/ubuntu:18.04-bionic`.

### JSON actual

Aunque existe *Pelican Eggs*, nos ceñimos a los oficiales de Pterodactyl, que parecen darle proridad a la estabilidad (Pelican es para Pterodactyl, lo que Ubuntu para Debian).

Abrir el [JSON actual](../sources/20250125_pterodactyl-eggs_egg-minetest.json) copiado en este repositorio ([Ver original](https://pterodactyleggs.com/egg/6735ff5d4924a4e9bbcbeda6), [Descargar original](https://pterodactyleggs.com/egg/6735ff5d4924a4e9bbcbeda6/download/egg-minetest.json)).

### Imagen actual

En este caso se usa `ghcr.io/ptero-eggs/games:minetest`, copiada como `ghcr.io/luanti-es/ptero-eggs_games_minetest:5.14.0` (no mantienen versioneado, siempre es *modo latest*, y en el momento de la copia era la versión 5.14.0).

Para el instalador se usa `ghcr.io/ptero-eggs/installers:debian`, copiada como `ghcr.io/luanti-es/ptero-eggs_installers_debian:12` (no mantienen versioneado, siempre es *modo latest*, y en el momento de la copia era la versión 12).

### Resumen de imágenes

Las images de Docker copiadas en los puntos anteriores son las siguientes:

| Origen | Destino |
| :----- | :-----  |
| `quay.io/parkervcp/pterodactyl-images:base_ubuntu` | `ghcr.io/luanti-es/parkervcp_pterodactyl-images:base_ubuntu` |
| `ubuntu:18.04`                                     | `ghcr.io/luanti-es/ubuntu:18.04-bionic` |
| `ghcr.io/ptero-eggs/games:minetest`                | `ghcr.io/luanti-es/ptero-eggs_games_minetest:5.14.0` |
| `ghcr.io/ptero-eggs/installers:debian`             | `ghcr.io/luanti-es/ptero-eggs_installers_debian:12` |

## Desarrollo

### Versión del SO base

Elegir entre Debian y Ubuntu es ir sobre seguro ya de por si, ya que la primera se fundamenta en seguridad y estabilidad, y la segunda es una derivada que se enfoca en una actualización mas rápida, pero a la vez, menos testeada.

Para nuestro caso, siempre se intentará con Debian como punto de partida, usándose Ubuntu sólo si no funciona lo anterior. El motivo es lo ya comentado, seguridad y estabilidad, pero tambien evitar el uso de snap, flatpak, ppa ...

Entre las imágenes estándar y *slim* de Debian, se usará esta última (reducen unos 40 Mb eliminando locale, docs y man, que no necesitamos para Installer/Yolk).

En la fecha actual (20251101), las versiones disponibles de Debian y Ubuntu que se copian por reproducibilidad son las siguientes:

| Origen | Destino |
| :----- | :-----  |
| `debian:13.1`      | `ghcr.io/luanti-es/debian:13.1-trixie`      |
| `debian:13.1-slim` | `ghcr.io/luanti-es/debian:13.1-trixie-slim` |
| `ubuntu:25.04`     | `ghcr.io/luanti-es/ubuntu:25.04-plucky`     |

## Enlaces de consulta/interés

- [Terminología de Pterodactyl](https://pterodactyl.io/project/terms.html)
- [Instalación y configuración de Panel](https://pterodactyl.io/panel/1.0/getting_started.html)
- [Instalación y configuración de Wings](https://pterodactyl.io/wings/1.0/installing.html)
- [Creación de Egg personalizado (fichero JSON)](https://pterodactyl.io/community/config/eggs/creating_a_custom_egg.html)
    - [Egg oficial de Minetest/Luanti](https://github.com/Ptero-Eggs/game-eggs/tree/main/minetest)
- [Creación de Yolk personalizado (imágen de Docker)](https://pterodactyl.io/community/config/eggs/creating_a_custom_image.html)
    - [Yolk oficial de Minetest/Luanti](https://github.com/Ptero-Eggs/yolks/tree/main/games/minetest)
    - [Instalador usado en el Yolk](https://github.com/Ptero-Eggs/yolks/tree/main/installers/debian)

## Créditos

- [Pterodactyl](https://pterodactyl.io)
- [Pelican Eggs](https://github.com/pelican-eggs)
- Cacatuo (Owner de Hispania)
- Daneel (Mod de Hispania)
- OrugA (El que escribe)

## Para futuro

- Proyecto interesante y completo del que se pueden sacar ideas: [Pterodactyl-VPS-Egg](https://github.com/ysdragon/Pterodactyl-VPS-Egg), crear servidores VPS desde el Panel (usa proot, sustituto de chroot, para emular un sistema completo dentro del sistema de Wings/Egg).
