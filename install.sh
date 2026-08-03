#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# ============================================================
#  🌌 LM STUDIO TERMUX ADAPTER
#  Instalador de LM Studio Headless/CLI para Android + Termux
# ============================================================

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m'

log() { echo -e "${CYAN}[*]${NC} $*"; }
ok() { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
fail() { echo -e "${RED}[x]${NC} $*" >&2; exit 1; }

require_termux() {
    if [[ -z "${PREFIX:-}" || "${PREFIX}" != */com.termux/files/usr ]]; then
        fail "Este instalador debe ejecutarse dentro de Termux."
    fi
}

check_arch() {
    local arch
    arch="$(uname -m)"
    if [[ "${arch}" != "aarch64" ]]; then
        fail "Arquitectura no soportada: ${arch}. Esta adaptación requiere ARM64/aarch64."
    fi
}

install_termux_deps() {
    log "Actualizando paquetes de Termux e instalando dependencias..."
    pkg update -y
    pkg upgrade -y
    pkg install -y proot-distro curl ca-certificates git
}

install_ubuntu() {
    if proot-distro list | grep -qi '^ *ubuntu.*installed'; then
        ok "Ubuntu ya está instalado en proot-distro."
        return
    fi

    log "Instalando Ubuntu como entorno de compatibilidad glibc..."
    proot-distro install ubuntu
}

install_lmstudio_in_ubuntu() {
    log "Instalando LM Studio CLI dentro de Ubuntu..."
    proot-distro login ubuntu -- bash -lc '
        set -Eeuo pipefail
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y curl ca-certificates bash findutils
        curl -fsSL https://lmstudio.ai/install.sh | bash
    '
}

create_lms_bridge() {
    log "Creando comando puente lms en Termux..."
    cat > "${PREFIX}/bin/lms" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

exec proot-distro login ubuntu -- bash -lc '
    set -Eeuo pipefail
    export HOME=/root
    export PATH="$HOME/.lmstudio/bin:$HOME/.local/bin:$PATH"

    if command -v lms >/dev/null 2>&1; then
        exec lms "$@"
    fi

    lms_bin="$(find "$HOME/.lmstudio" -type f -name lms -perm -111 2>/dev/null | sort -V | tail -n 1 || true)"
    if [[ -n "$lms_bin" ]]; then
        exec "$lms_bin" "$@"
    fi

    echo "No se encontró el binario lms dentro de Ubuntu." >&2
    echo "Prueba reinstalar con: curl -fsSL https://raw.githubusercontent.com/kuromi04/lm-studio-termux/main/install.sh | bash" >&2
    exit 127
' -- "$@"
EOF
    chmod +x "${PREFIX}/bin/lms"
    ok "Comando lms instalado en ${PREFIX}/bin/lms"
}

print_success() {
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   [✓] ¡INSTALACIÓN COMPLETADA CON ÉXITO!             ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
    echo -e "\nAhora puedes usar el comando ${CYAN}lms${NC} directamente en Termux."
    echo -e "Ejemplos:"
    echo -e "  ${WHITE}lms search llama${NC}     - Buscar modelos"
    echo -e "  ${WHITE}lms status${NC}           - Ver estado"
    echo -e "  ${WHITE}lms server start${NC}     - Iniciar servidor API compatible con OpenAI"
    echo -e "\n${YELLOW}Nota:${NC} La primera ejecución puede tardar mientras LM Studio detecta el hardware.\n"
}

main() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         🌌 LM STUDIO - TERMUX ADAPTATION             ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"

    require_termux
    check_arch
    install_termux_deps
    install_ubuntu
    install_lmstudio_in_ubuntu
    create_lms_bridge
    print_success
}

main "$@"
