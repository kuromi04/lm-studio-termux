# LM Studio para Termux (Adaptación) 🌌

Este repositorio contiene una adaptación automática para instalar y ejecutar **LM Studio (Headless/CLI)** en Android utilizando **Termux**.

## 🚀 Instalación Rápida

Copia y pega este comando en tu terminal de Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/kuromi04/lm-studio-termux/main/install.sh | bash
```

*(Nota: Reemplaza TU_USUARIO por tu nombre de usuario de GitHub después de hacer el fork o subirlo).*

## 🛠️ Cómo funciona

LM Studio está diseñado para Linux con `glibc`. Android usa `bionic`, por lo que esta adaptación:
1.  Instala un entorno **PRoot Ubuntu** dentro de Termux.
2.  Ejecuta el script oficial de instalación de LM Studio dentro de ese entorno.
3.  Crea un comando puente (`lms`) en Termux para que puedas controlar LM Studio sin entrar manualmente a Ubuntu.

## 💻 Comandos básicos

Una vez instalado, puedes usar el comando `lms` directamente:

-   **Buscar modelos:** `lms search llama3`
-   **Descargar un modelo:** `lms download <id-del-modelo>`
-   **Iniciar el servidor API (OpenAI compatible):** `lms server start`
-   **Ver estado:** `lms status`
-   **Listar modelos descargados:** `lms ls`

## ⚠️ Requisitos

-   Procesador **ARM64 (aarch64)**.
-   Mínimo **8GB de RAM** recomendados para modelos pequeños (3B/8B).
-   Suficiente espacio de almacenamiento para los modelos.

---
Adaptado por @Kuromi04 para la comunidad de termux