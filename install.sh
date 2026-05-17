#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
#  🌌 LM STUDIO TERMUX ADAPTER
#  Adaptación automática para correr LM Studio en Android
# ============================================================

# Colores
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         🌌 LM STUDIO - TERMUX ADAPTATION             ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"

# 1. Verificar Arquitectura
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ]; then
    echo -e "${RED}[!] Error: Esta adaptación solo soporta arquitectura ARM64 (aarch64).${NC}"
    exit 1
fi

# 2. Instalar dependencias en Termux
echo -e "\n${YELLOW}[*] Actualizando paquetes e instalando dependencias...${NC}"
pkg update && pkg upgrade -y
pkg install proot-distro curl git -y

# 3. Configurar Ubuntu (entorno glibc)
if ! proot-distro list | grep -q "ubuntu.*Installed"; then
    echo -e "${YELLOW}[*] Instalando Ubuntu (entorno de compatibilidad)...${NC}"
    proot-distro install ubuntu
else
    echo -e "${GREEN}[✓] Ubuntu ya está instalado.${NC}"
fi

# 4. Instalar LM Studio dentro de Ubuntu
echo -e "${YELLOW}[*] Ejecutando instalación oficial de LM Studio dentro de Ubuntu...${NC}"
proot-distro login ubuntu -- bash -c "
    apt update && apt upgrade -y
    apt install curl bash -y
    echo 'Descargando binarios oficiales...'
    curl -fsSL https://lmstudio.ai/install.sh | bash
"

# 5. Crear el comando puente 'lms' en Termux
echo -e "${YELLOW}[*] Creando acceso directo 'lms' en Termux...${NC}"
cat <<EOF > $PREFIX/bin/lms
#!/data/data/com.termux/files/usr/bin/bash
# Script puente para LM Studio en PRoot
proot-distro login ubuntu -- bash -c "export HOME=/root && /root/.lmstudio/llmster/0.0.12-1/.bundle/lms \"\$@\""
EOF
chmod +x $PREFIX/bin/lms

# 6. Finalización
echo -e "\n${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   [V] ¡INSTALACIÓN COMPLETADA CON ÉXITO!             ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo -e "\nAhora puedes usar el comando ${CYAN}'lms'${NC} directamente en Termux."
echo -e "Ejemplos:"
echo -e "  ${WHITE}lms search llama${NC}    - Buscar modelos"
echo -e "  ${WHITE}lms status${NC}          - Ver estado"
echo -e "  ${WHITE}lms server start${NC}    - Iniciar servidor API OpenAI"
echo -e "\n${YELLOW}Nota: La primera vez que corras un modelo, el sistema detectará el hardware.${NC}\n"
