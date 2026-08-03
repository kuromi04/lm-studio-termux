# LM Studio para Termux 🌌

Adaptación automática para instalar y ejecutar **LM Studio Headless/CLI** en Android usando **Termux** y un entorno Ubuntu con `proot-distro`.

## 🚀 Instalación rápida

Copia y pega este comando en Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/kuromi04/lm-studio-termux/main/install.sh | bash
```

## ✅ Requisitos

- Android con **Termux** instalado.
- Procesador **ARM64/aarch64**.
- Al menos **8 GB de RAM recomendados** para modelos pequeños.
- Espacio libre suficiente para Ubuntu, LM Studio y los modelos que descargues.
- Conexión a internet durante la instalación.

## 🛠️ Cómo funciona

LM Studio está diseñado para Linux con `glibc`. Android usa `bionic`, así que este instalador:

1. Verifica que estés en Termux y en arquitectura ARM64.
2. Actualiza Termux e instala `proot-distro`, `curl`, certificados y dependencias básicas.
3. Instala Ubuntu dentro de Termux mediante `proot-distro`.
4. Ejecuta el instalador oficial de LM Studio dentro de Ubuntu.
5. Crea un comando puente llamado `lms` en Termux.

El comando puente no depende de una versión fija de LM Studio. Primero intenta usar `lms` desde el `PATH` de Ubuntu y, si no está disponible, busca automáticamente el binario dentro de `/root/.lmstudio`.

## 💻 Comandos básicos

Después de instalar, usa `lms` directamente desde Termux:

```bash
lms status
lms search llama3
lms download <id-del-modelo>
lms ls
lms server start
```

## 🔧 Entrar manualmente a Ubuntu

Si necesitas depurar o ejecutar comandos dentro del entorno Linux:

```bash
proot-distro login ubuntu
```

## ♻️ Reinstalar o reparar

Puedes volver a ejecutar el instalador cuando quieras:

```bash
curl -fsSL https://raw.githubusercontent.com/kuromi04/lm-studio-termux/main/install.sh | bash
```

Esto reutiliza Ubuntu si ya está instalado y vuelve a crear el comando puente `lms`.

## ⚠️ Notas

- LM Studio y los modelos pueden consumir mucha memoria. Si Android cierra procesos en segundo plano, reduce el tamaño del modelo.
- La primera ejecución puede tardar mientras LM Studio detecta el hardware.
- Si `lms` no aparece después de instalar, reinicia Termux o ejecuta `hash -r`.

---

Adaptado por [@kuromi04](https://github.com/kuromi04) para la comunidad de Termux.
