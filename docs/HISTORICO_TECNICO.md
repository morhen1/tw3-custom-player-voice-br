# Histórico técnico sanitizado

**Início do projeto:** 16 de julho de 2026.

Este documento registra tentativas e aprendizados sem publicar voz, dataset,
áudio de jogo ou referência não autorizada.

## Exploração dos dados

Um CSV comunitário foi usado localmente para estudar a relação entre IDs de
diálogo e mídia de voz. IDs decimais foram convertidos para hexadecimal e os
primeiros testes percorreram `content0` a `content12`. A indexação final passou
a considerar 34 pacotes oficiais entre jogo-base e DLCs.

WEMs foram convertidos para WAV com `vgmstream-cli` apenas para comparação e
prototipagem local. Nenhum desses arquivos integra o repositório.

## Tentativa com RVC/Applio

A primeira abordagem foi conversão voz-a-voz com Applio/RVC. Foram testados
pretrained models, `contentvec`, `index rate`, `protect`, formantes e tratamento
prévio no Audacity. Uma macro com redução de graves diminuiu parte do `vocal
fry`, mas o resultado manteve características demais da voz de origem e não
ficou consistente para milhares de falas.

Essa rota também dependia de material sem autorização adequada para
distribuição. Foi abandonada integralmente; nenhum modelo, dataset ou áudio
derivado dessa fase pertence à versão pública.

## Pivô para TTS direto

O OmniVoice passou a gerar a fala diretamente do texto. Os principais
aprendizados foram:

- áudio e texto de referência precisam corresponder;
- um worker por GPU e `batch-size 1` estabilizam GPUs de 8 GB;
- 32 passos apresentaram entonação mais consistente;
- lotes de 250 com validação permitem retomada segura;
- UTF-8 precisa ser preservado do CSV ao JSONL;
- enviar `duration` ao modelo pode cortar a palavra final;
- duração deve ser tratada depois da síntese, sem ultrapassar 1,20x.

## Voz definitiva e consentimento

A versão publicável utiliza uma referência original de uma intérprete adulta
que autorizou a clonagem e a distribuição no mod. A gravação e o documento
assinado permanecem privados.

## Integração correta com o jogo

Foram descartadas hipóteses de Wwise 2013/Vorbis, recompilação pelo REDkit,
Strings DB Editor e alteração de `.w3strings`. A solução validada usa:

- Wwise 2021.1.7.7796;
- WEM Opus 48 kHz;
- 35 IDs estéreo e os demais mono;
- indexação de 34 `brpc.w3speech` oficiais;
- expansão de IDs duplicados pelos metadados superiores;
- preservação dos CR2W originais;
- pacote compacto validado byte a byte.

## Divisão transparente das contribuições

### Trabalho humano

- concepção, escopo e decisões éticas;
- organização e edição dos dados;
- captação consentida da referência;
- execução dos lotes e controle operacional;
- testes auditivos e dentro do jogo;
- identificação de falhas e aprovação da qualidade.

### Assistência por IA

Claude e Gemini auxiliaram na exploração e nos rascunhos iniciais. ChatGPT/
Codex auxiliou na implementação dos scripts, testes, diagnóstico e
documentação. O projeto não atribui ao responsável uma autoria manual de código
que não corresponde ao processo real.
