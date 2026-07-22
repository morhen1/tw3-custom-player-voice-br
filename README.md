# Custom Player Voice BR — pipeline de voz

**Português** | [English](README_EN.md)

Ferramentas usadas para produzir uma voz feminina em português brasileiro para
as falas normalmente associadas ao Geralt quando o jogador utiliza uma
personagem feminina no mod **Custom Player Characters**, em *The Witcher 3:
Wild Hunt* 4.04 para PC.

Este repositório contém somente código, testes, exemplos e documentação. O mod
instalável é distribuído separadamente no Nexus Mods.

## Estado da versão

- versão do projeto: `1.0.0`;
- jogo: *The Witcher 3* 4.04 para PC;
- idioma: português brasileiro (`brpc.w3speech`);
- corpus: 19.376 IDs;
- falas sintéticas: 19.359;
- entradas que preservam o áudio oficial: 17;
- WEM: Opus `0x3041`, 48 kHz, mono ou estéreo conforme o original;
- pacote validado: 1.263.663.568 bytes.

Ao ser ativado, o arquivo substitui globalmente as falas de Geralt em português
brasileiro. Portanto, ele deve ser desativado quando o usuário voltar a jogar
com o Geralt original.

## Transparência sobre IA e voz

A voz foi sintetizada com OmniVoice a partir da gravação de uma **intérprete
adulta que autorizou a clonagem e a distribuição para este mod**. A referência
não imita nem utiliza a voz de uma atriz ou dubladora de *The Witcher 3*.

A gravação de referência e o consentimento assinado permanecem privados. Eles
não são incluídos no GitHub, no Nexus ou no pacote instalável.

Os scripts e a documentação foram desenvolvidos com assistência de Claude,
Gemini e ChatGPT/Codex, sob direção humana, edição de dados, execução dos lotes
e validação auditiva e dentro do jogo.

## Aviso de trabalho de fã

Este é um trabalho de fã não oficial e não é aprovado nem endossado pela
CD PROJEKT RED. *The Witcher*, seus personagens e os arquivos originais do jogo
pertencem aos respectivos titulares. Consulte as
[Fan Content Guidelines da CD PROJEKT RED](https://www.cdprojektred.com/en/fan-content).

O mod é gratuito e não pode ficar atrás de paywall. A versão `1.0.0` deve ser
publicada sem Donation Points ou monetização até que esse uso esteja coberto
explicitamente pelo consentimento da intérprete.

## Compatibilidade do mod instalável

Requer:

- *The Witcher 3* 4.04 para PC;
- idioma das vozes configurado como português brasileiro;
- Custom Player Characters instalado e configurado separadamente.

É incompatível com outros mods que substituam o mesmo `brpc.w3speech` ou as
falas de Geralt em português brasileiro.

Estrutura do arquivo do Nexus:

```text
modCustomPlayerVoiceBR/
  content/
    brpc.w3speech
```

## Conteúdo do repositório

- preparação e limpeza conservadora dos textos;
- correções por ID e preservação de sons não verbais;
- execução em lotes do OmniVoice com retomada;
- pós-processamento adaptativo com FFmpeg;
- conversão em lote para WEM Opus com Wwise;
- indexação dos 34 pacotes oficiais de voz;
- montagem compacta de `brpc.w3speech`, preservando os CR2W originais;
- auditorias de formato, mapeamento e cobertura;
- testes automatizados da pipeline.

O repositório **não contém** áudio de referência, áudio do jogo, CSV comunitário,
WAV, WEM, `w3speech`, modelos, caches ou documentos assinados.

## Reproduzir a pipeline

Consulte [docs/PIPELINE.md](docs/PIPELINE.md). O processo exige que o usuário
obtenha legalmente as próprias entradas e configure:

- Python 3.11 ou mais recente;
- OmniVoice funcional;
- FFmpeg;
- Wwise 2021.1.7.7796;
- uma referência vocal própria e autorizada;
- instalação local de *The Witcher 3* 4.04.

Os scripts do repositório usam apenas a biblioteca padrão do Python. Para rodar
os testes:

```powershell
py -3 -m unittest discover -s tests -v
```

## Documentação

- [Pipeline técnica](docs/PIPELINE.md)
- [Histórico técnico sanitizado](docs/HISTORICO_TECNICO.md)
- [Descrição pronta para o Nexus](docs/NEXUS_DESCRIPTION.md)
- [Políticas de publicação consultadas](docs/POLITICAS_PUBLICACAO.md)
- [Publicação segura no GitHub](docs/PUBLICAR_GITHUB.md)
- [Checklist de publicação](docs/RELEASE_CHECKLIST.md)
- [Política de voz e ativos](ASSET_LICENSE.md)
- [Histórico de versões](CHANGELOG.md)

Para transformar exatamente uma pasta já testada no pacote público, use
`preparar_release_nexus.ps1`. O script confere o tamanho, copia com o nome final,
calcula SHA-256 e, opcionalmente, cria um `.7z` quando o 7-Zip está instalado.

## Licenças

O código-fonte original deste repositório está sob a licença MIT. Essa licença
não se estende ao jogo, aos ativos da CD PROJEKT RED, à voz da intérprete nem ao
pacote de áudio distribuído no Nexus. Veja [ASSET_LICENSE.md](ASSET_LICENSE.md).
