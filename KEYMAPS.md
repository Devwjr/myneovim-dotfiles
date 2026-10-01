# Keymaps e Comandos — Salar Neovim

Configuração Neovim (lazy.nvim) com LSP, DAP, Telescope, Treesitter, Obsidian e tools.

> Leader padrão: `Espaço`

---

## 🧭 Navegação Geral

| Atalho | Ação |
|--------|------|
| `<C-u>` | Scroll up com cursor centralizado |
| `<C-d>` | Scroll down com cursor centralizado |
| `<C-n>` | Toggle file explorer (Ex / NvimTree) |
| `<Tab>` | Próximo buffer |
| `<Shift-Tab>` | Buffer anterior |

---

## 🪟 Janelas / Splits

| Atalho | Ação |
|--------|------|
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Igualar tamanho dos splits |
| `<leader>sx` | Fechar split atual |
| `<C-Up>` | Aumentar altura |
| `<C-Down>` | Diminuir altura |
| `<C-Left>` | Diminuir largura |
| `<C-Right>` | Aumentar largura |

---

## 📑 Buffers / Tabs

| Atalho | Ação |
|--------|------|
| `<leader>x` | Fechar buffer atual |
| `<leader>n` | Novo tab |
| `<leader>h` | Mover buffer para esquerda |
| `<leader>l` | Mover buffer para direita |
| `J` (visual) | Mover bloco para baixo |
| `K` (visual) | Mover bloco para cima |

---

## 🔍 Telescope (busca)

| Atalho | Ação |
|--------|------|
| `<leader>ff` | Achar arquivos |
| `<leader>fw` | Buscar texto no diretório (live grep) |
| `<leader>fs` | Símbolos do documento |
| `<leader>fc` | Buscar string sob o cursor |

---

## ⚡ LSP (linguagens)

| Atalho | Ação |
|--------|------|
| `gd` | Ir para definição |
| `gD` | Ir para declaração |
| `gi` | Implementações |
| `gR` | Referências |
| `gt` | Definição de tipo |
| `K` | Hover / documentação |
| `<leader>ca` | Code actions |
| `<leader>rn` | Renomear símbolo |
| `<leader>D` | Diagnostics do buffer (Telescope) |
| `<leader>d` | Diagnostics da linha (float) |
| `[d` | Diagnostic anterior |
| `]d` | Próximo diagnostic |
| `<leader>rs` | Restart LSP |
| `<leader>ci` | LSP incoming calls |
| `<leader>co` | LSP outgoing calls |
| `<leader>ch` | LSP implementações (via Telescope) |
| `<leader>cu` | LSP referências |

---

## 🐛 Debug — DAP (`<leader>d`)

### C / C++ / Rust
Adapter: `codelldb` (Mason). Configs: Launch, Launch with args, Attach to process.

### Outras linguagens
| Linguagem | Adapter | Config |
|-----------|---------|--------|
| Python | debugpy | Launch file |
| Go | dlv | Debug program |
| JavaScript/TypeScript | js-debug-adapter | Launch file |
| Java | java-debug-adapter | Remote attach |
| C# / .NET / F# / VB | netcoredbg | Launch dll |

### Atalhos de debug
| Atalho | Ação |
|--------|------|
| `<leader>dc` | Continue |
| `<leader>db` | Toggle breakpoint |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dr` | Restart |
| `<leader>dt` | Terminate |
| `<leader>du` | Toggle DAP UI |
| `<leader>dw` | Adicionar watch |
| `<leader>dW` | Remover watch |
| `<leader>dC` | Limpar watches |

---

## 📝 Obsidian (vault)

| Atalho | Ação |
|--------|------|
| `<leader>ob` | Backlinks |
| `<leader>oc` | Toggle checkbox |
| `<leader>od` | Nota diária (today) |
| `<leader>ol` | Links da nota |
| `<leader>om` | Toggle render markdown |
| `<leader>oo` | Abrir em Obsidian |
| `<leader>oq` | Quick switch |
| `<leader>os` | Buscar notas |
| `<leader>ot` | Inserir template |
| `<leader>oT` | Table of contents |
| `<C-x>` (picker) | Nova nota |
| `<C-l>` (picker) | Inserir link |

---

## 🎨 Temas

| Atalho | Ação |
|--------|------|
| `<leader>ts` | Selecionar tema |
| `<leader>tn` | Próximo tema |
| `<leader>tp` | Tema anterior |

---

## 🛠️ Comandos Customizados (`:`)

| Comando | Descrição |
|---------|-----------|
| `:Theme [nome]` | Selecionar ou definir tema (com autocompletar) |
| `:ThemeNext` | Ciclar para o próximo tema |
| `:ThemePrev` | Ciclar para o tema anterior |
| `:LspRestart` | Reiniciar LSP |
| `:Skel` | Inserir skeleton de arquivo |
| `:TypstPreview` | Compilar e abrir PDF Typst (zathura) |
| `:CppTrvCtr` | Gerar constructor trivial C++ |
| `:CppExtractDefinitions` | Extrair definições C++ |
| `:CppExtractFunctionDefinition` | Extrair definição de função C++ |

Comandos padrão úteis: `:Lazy` (gerenciar plugins), `:Mason` (instalar LSP/DAP), `:TSInstall`, `:LspInfo`, `:NvimTreeToggle`, `:Telescope`.

---

## 🗂️ Como descobrir atalhos

- `<leader>` (espaço) mostra o menu de prefixos de keymaps definidos
- `:map <leader>` lista todos os atalhos com o leader
- `:Telescope keymaps` navega pelos atalhos
- `:nmap <tab>` ver bindings de um atalho específico
