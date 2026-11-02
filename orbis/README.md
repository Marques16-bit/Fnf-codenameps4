# Codename Engine no PS4 (orbis)

Tudo desta pasta e novo. Nada do que ja existia foi renomeado; os arquivos do engine so ganharam
guardas `#if orbis`, entao o build para PC continua igual.

## O que mudou no repositorio
- `project.xml`: define `orbis` (use `lime build linux -Dorbis`), janela 1920x1080 em tela cheia,
  saida em `export/orbis`, e desliga o que nao existe no PS4 (Discord RPC, video hxvlc,
  checagem de update, GitHub API, NDLLs).
- `source/funkin/backend/assets/ModsFolder.hx`: mods em `/data/FNF/Mods/` no PS4.
- `source/funkin/backend/system/Main.hx`: pasta de trabalho `/data/FNF/` e `autoload.txt` lido de `Mods/`.
- `SystemInfo.hx`, `CoolUtil.hx`, `MemoryUtil.hx`: pulam codigo de Linux (`/proc`, `/etc/os-release`,
  `xdg-open`, processos filhos) que o PS4 nao tem.
- A resolucao interna do jogo continua 1280x720 (`Main.hx`); so a janela e 1080p. Mudar isso quebraria o layout dos mods.

## Pastas no PS4 (o PS4 diferencia maiusculas de minusculas)
```
/data/FNF/assets/   <- conteudo de export/orbis/bin/assets (ou a pasta assets/ do repo)
/data/FNF/Mods/     <- seus mods (FTP porta 2121 ou pendrive)
/data/FNF/hello.log <- so no teste da fase 1
```

## Ordem de teste
1. `source env.sh` e `scripts/00` ate `03`: valida hxcpp + OpenOrbis + .pkg com um "hello" (ver abaixo).
2. `scripts/04-build-game.sh`: build do engine. **Vai falhar ate existir o backend nativo do Lime para orbis.**

## O que ainda NAO existe (por isso nao da para garantir que o FNF abre)
- Backend nativo do Lime para PS4 (janela, GLES2, audio, entrada). Caminho em estudo: SDL2 para PS4 +
  GLES2 pelo modulo de sistema Piglet. Sem isso o engine compila no maximo ate o link.
- Bibliotecas nativas compiladas para orbis (lime, OpenAL, freetype etc.).
- Teclado: o engine ja funciona so com teclado, mas o PS4 precisa entregar os eventos de teclado USB
  pela camada nativa.
- Saves: o Lime usa `applicationStorageDirectory`; no PS4 precisa apontar para `/data/FNF/`.
- Nada aqui foi compilado ou rodado (sem Haxe/hxcpp/PS4 no ambiente onde foi preparado).

## Fase 1 (hello) em detalhe
Valida GC, excecoes, thread e arquivos do hxcpp no PS4 antes do engine:
`scripts/00-check.sh`, `01-install-toolchain.sh`, `02-build-hxcpp-libs.sh`, `03-build-hello.sh`,
depois `scripts/send-ftp.sh pkg/dist/<arq>.pkg /data/pkg/` (ou Remote Package Sender), instale, abra,
e leia `/data/FNF/hello.log` por FTP. Esperado: `[1] inicio`, `[2] gc ok`, `[3] excecao ok`, `[4] thread ok`, `[5] fim`.
Se `/data/FNF` nao existir o teste cria a pasta.

Ajustes quando der erro: `hxcpp/orbis-toolchain.xml` (rode `01-install...` de novo), `-D HXCPP_VERBOSE`
em `tests/hello/build.hxml`, e o `pkg/Makefile` (libc.prx, libSceFios2.prx e right.sprx vem do seu OpenOrbis).
Troca rapida do executavel sem reinstalar: `scripts/send-ftp.sh <eboot.bin> /user/app/<TITLE_ID>/eboot.bin`.

## Workflows do GitHub (pelo celular)
- `.github/workflows/extrair-zip.yml`: suba um zip chamado `repo.zip` na raiz (use o zip "alterados").
  Ele extrai por cima, apaga o zip e faz o commit sozinho. O GitHub nao aceita arquivo acima de 100 MB,
  entao o zip do repositorio inteiro nao serve para isso.
- `.github/workflows/orbis-pkg.yml`: Actions > Gerar PKG (PS4) > Run workflow. Escolha `hello` (funciona
  como teste) ou `jogo` (falha ate existir o backend do Lime). Baixe o .pkg em Artifacts (`fnf-ps4-pkg`).
  O pacote leva so o executavel; assets e mods vao por FTP em `/data/FNF/`.
- Os dois arquivos .yml precisam ser criados no GitHub na mao (Add file > Create new file), porque o
  token padrao nao pode criar workflow por extracao.
