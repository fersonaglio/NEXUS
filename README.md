# NEXUS

```
███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗
████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝
██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗
██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║
██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║
╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
```

Wrapper local para [OpenCode](https://github.com/anomalyco/opencode) com suporte nativo a **Ollama**.

## Características

- **100% Local** — Usa apenas Ollama em `localhost:11434`
- **Compatível com OpenCode** — Mantém todas as funcionalidades do OpenCode
- **CLI Simples** — Uso: `nexus --model qwen2.5-coder:7b-instruct`
- **Wrapper Inteligente** — Adiciona prefixo `ollama/` automaticamente

## Pré-requisitos

- [Bun](https://bun.sh/) instalado
- [Ollama](https://ollama.ai/) instalado e rodando
- Modelo local (ex: `qwen2.5-coder:7b-instruct`)

```bash
# Baixar modelo Ollama
ollama pull qwen2.5-coder:7b-instruct

# Verificar Ollama está rodando
ollama list
```

## Instalação

```bash
# Clone ou entre no diretório NEXUS
cd NEXUS

# Execute o script de build
powershell -ExecutionPolicy Bypass -File build.ps1
```

## Uso

```bash
# Usar modelo específico (com prefixo automático ollama/)
nexus --model qwen2.5-coder:7b-instruct
nexus -m llama3

# Sem prefixo - adiciona automaticamente
nexus --model codellama

# Todos os argumentos do OpenCode são suportados
nexus --help
nexus --agent build
nexus --prompt "Hello"
```

### Exemplos

```bash
# Iniciar sessão interativa com modelo local
nexus --model qwen2.5-coder:7b-instruct

# Com agente específico
nexus --agent build --model llama3

# Non-interactive mode
nexus --prompt "Liste os arquivos deste diretório"

# Com contexto maior
nexus --model qwen2.5-coder:14b --context 16384
```

## Configuração

A configuração é criada automaticamente em `~/.config/nexus/config.json`.

```json
{
  "provider": {
    "ollama": {
      "api": "http://localhost:11434/v1"
    }
  }
}
```

Para modelos Ollama, use o formato:
- `--model qwen2.5-coder:7b-instruct`
- `--model llama3`
- `--model codellama:34b`

O wrapper adiciona automaticamente o prefixo `ollama/` se não especificado.

## Diferenças do OpenCode Original

| Aspecto | NEXUS |
|---------|-------|
| Provider padrão | Ollama (local) |
| Model default | qwen2.5-coder:7b-instruct |
| API externa | Apenas localhost |
| Instalação | Build local |

## Troubleshooting

### Ollama não responde
```bash
# Verificar Ollama está rodando
ollama list

# Iniciar Ollama
ollama serve
```

### Modelo não encontrado
```bash
# Baixar modelo
ollama pull qwen2.5-coder:7b-instruct

# Listar modelos disponíveis
ollama list
```

## Créditos

- [OpenCode](https://github.com/anomalyco/opencode) — Projeto original
- [Ollama](https://ollama.ai/) — Modelos locais

## Licença

MIT