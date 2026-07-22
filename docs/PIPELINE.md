# Pipeline técnica

Este documento descreve o processo reproduzível. Ele não distribui as entradas
necessárias: use somente arquivos obtidos legalmente e uma voz com autorização.

## 1. Estrutura local

```text
projeto/
  dados/grlt.lines.csv
  private/referencia_voz.wav
  private/referencia_voz.txt
  trabalho/
  saida/wav_bruto/
  saida/wav_final/
  correcoes.csv
```

`private/`, `dados/`, `trabalho/` e `saida/` são ignorados pelo Git. Copie
`correcoes.example.csv` para `correcoes.csv` e preencha somente decisões que
tenham sido revisadas.

## 2. Metadados originais

```powershell
py -3 extrair_metadados_w3speech.py `
    --game-root "C:\caminho\The Witcher 3" `
    --lines ".\dados\grlt.lines.csv" `
    --output ".\trabalho\duracoes_originais.csv"
```

O indexador percorre 34 pacotes oficiais do jogo-base e DLCs. Pacotes vazios ou
incompatíveis são tratados de forma conservadora.

## 3. Limpeza, correções e JSONL

```powershell
py -3 preparar_dataset.py `
    --lines ".\dados\grlt.lines.csv" `
    --corrections ".\correcoes.csv" `
    --durations ".\trabalho\duracoes_originais.csv" `
    --ref-audio ".\private\referencia_voz.wav" `
    --ref-text-file ".\private\referencia_voz.txt" `
    --jsonl ".\trabalho\omnivoice.jsonl" `
    --report ".\trabalho\manifesto_preparacao.csv" `
    --require-durations
```

Por padrão, `duration` não é enviado ao OmniVoice. A duração original permanece
no manifesto apenas para o tratamento posterior. Isso evita que o modelo corte
a última palavra para caber em um limite rígido.

As ações em `correcoes.csv` são:

- `gerar`: substitui o texto daquele ID pela versão revisada;
- `usar_original`: não gera nem inclui o ID no pacote do mod.

Não faça correções globais de gênero. Uma palavra masculina pode descrever
outra pessoa, objeto ou situação e deve ser avaliada no contexto.

## 4. Amostra antes do lote

```powershell
py -3 selecionar_amostra_jsonl.py `
    --jsonl ".\trabalho\omnivoice.jsonl" `
    --manifest ".\trabalho\manifesto_preparacao.csv" `
    --output ".\trabalho\amostra_20.jsonl" `
    --report ".\trabalho\amostra_20.csv" `
    --count 20 `
    --include-id 0x000f4f9c
```

```powershell
py -3 executar_omnivoice.py `
    --jsonl ".\trabalho\amostra_20.jsonl" `
    --output ".\saida\wav_bruto_amostra" `
    --executable "C:\caminho\omnivoice-infer-batch.exe" `
    --items-per-batch 20 `
    --num-step 32 `
    --guidance-scale 1.8 `
    --nj-per-gpu 1 `
    --batch-size 1 `
    --no-normalize-duration
```

Escute a amostra antes de iniciar milhares de sínteses.

## 5. Lote completo e retomada

```powershell
py -3 executar_omnivoice.py `
    --jsonl ".\trabalho\omnivoice.jsonl" `
    --output ".\saida\wav_bruto" `
    --executable "C:\caminho\omnivoice-infer-batch.exe" `
    --items-per-batch 250 `
    --num-step 32 `
    --guidance-scale 1.8 `
    --nj-per-gpu 1 `
    --batch-size 1 `
    --no-normalize-duration
```

O runner pula WAVs existentes válidos. Para somente conferir a retomada:

```powershell
py -3 executar_omnivoice.py `
    --jsonl ".\trabalho\omnivoice.jsonl" `
    --output ".\saida\wav_bruto" `
    --check-only
```

## 6. Pós-processamento adaptativo

```powershell
$ffmpeg=(Get-Command "ffmpeg.exe" -ErrorAction Stop).Source

py -3 processar_wavs_adaptativo.py `
    --manifest ".\trabalho\manifesto_preparacao.csv" `
    --input ".\saida\wav_bruto" `
    --output ".\saida\wav_final" `
    --report ".\trabalho\pos_processamento_final.csv" `
    --ffmpeg "$ffmpeg" `
    --workers 2
```

Tratamento validado:

- detecção de bordas sustentadas e 80 ms de margem;
- aceleração apenas quando necessária, limitada a 1,20x;
- high-pass em 90 Hz;
- −4 dB em 300 Hz e +3 dB em 3,5 kHz;
- compressor 3:1 com `makeup=1`;
- normalização em −23 LUFS e limiter de segurança;
- PCM16 mono, 48 kHz.

Diferenças em relação à duração oficial são `aviso_curta` ou `aviso_longa` por
padrão. Use `--duration-audit strict` somente para uma investigação específica.
Arquivo ausente, WAV inválido, ausência de voz ou falha do FFmpeg continuam
bloqueando o lote.

## 7. WEM Opus

Crie no Wwise 2021.1.7.7796 dois Conversion ShareSets chamados
`WEMOpusSpeech` e `WEMOpusSpeechStereo`, ambos Opus/48 kHz e configurados para
um e dois canais, respectivamente.

```powershell
py -3 converter_wav_para_wem_opus_lote_v2.py `
    --input ".\saida\wav_final" `
    --output ".\saida\wem_opus_mono" `
    --wwise-console "C:\caminho\WwiseConsole.exe" `
    --project "C:\caminho\projeto.wproj" `
    --shareset "WEMOpusSpeech" `
    --expected-channels 1
```

```powershell
py -3 converter_wav_para_wem_opus_lote_v2.py `
    --input ".\saida\wav_final" `
    --output ".\saida\wem_opus_stereo" `
    --wwise-console "C:\caminho\WwiseConsole.exe" `
    --project "C:\caminho\projeto.wproj" `
    --ids-file ".\ids_wem_opus_estereo.txt" `
    --shareset "WEMOpusSpeechStereo" `
    --expected-channels 2
```

A pasta estéreo é uma sobreposição dos 35 IDs; a pasta mono continua contendo
uma cópia de todos os IDs para facilitar a auditoria de cobertura.

## 8. Mapeamento e pacote compacto

Audite antes de criar qualquer arquivo:

```powershell
py -3 montar_brpc_w3speech_compacto_v4.py `
    --game-root "C:\caminho\The Witcher 3" `
    --wem-dir ".\saida\wem_opus_mono" `
    --wem-override-dir ".\saida\wem_opus_stereo" `
    --report ".\trabalho\relatorio_mapeamento_w3speech.csv"
```

Depois confira cobertura:

```powershell
py -3 auditar_cobertura.py `
    --manifest ".\trabalho\manifesto_preparacao.csv" `
    --wav-dir ".\saida\wav_final" `
    --wem-dir ".\saida\wem_opus_mono" `
    --processing-report ".\trabalho\pos_processamento_final.csv" `
    --mapping-report ".\trabalho\relatorio_mapeamento_w3speech.csv" `
    --output ".\trabalho\auditoria_final.csv"
```

Somente após ambas aprovarem, monte o mod:

```powershell
py -3 montar_brpc_w3speech_compacto_v4.py `
    --game-root "C:\caminho\The Witcher 3" `
    --wem-dir ".\saida\wem_opus_mono" `
    --wem-override-dir ".\saida\wem_opus_stereo" `
    --report ".\trabalho\relatorio_mapeamento_w3speech.csv" `
    --output ".\saida\modCustomPlayerVoiceBR\content\brpc.w3speech" `
    --force
```

Os pacotes originais nunca são modificados. O utilitário copia os CR2W
associados, preserva IDs duplicados e valida o resultado byte a byte.
