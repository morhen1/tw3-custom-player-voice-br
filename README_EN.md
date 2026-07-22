# Custom Player Voice BR — voice pipeline

[Português](README.md) | **English**

Tools used to produce a Brazilian Portuguese female voice for dialogue normally
assigned to Geralt when the player uses a female character through the **Custom
Player Characters** mod in *The Witcher 3: Wild Hunt* 4.04 for PC.

This repository contains only source code, tests, examples, and documentation.
The installable mod is distributed separately through Nexus Mods.

## Version status

- project version: `1.0.0`;
- game: *The Witcher 3* 4.04 for PC;
- language: Brazilian Portuguese (`brpc.w3speech`);
- corpus: 19,376 IDs;
- synthetic voice lines: 19,359;
- entries preserving official audio: 17;
- WEM: Opus `0x3041`, 48 kHz, mono or stereo according to the original;
- validated package size: 1,263,663,568 bytes.

When enabled, the file globally replaces Geralt's Brazilian Portuguese voice
lines. It should therefore be disabled when the player returns to the original
Geralt.

## AI and voice transparency

The voice was synthesized with OmniVoice from a recording provided by an
**adult voice performer who authorized the cloning and distribution of her
voice for this mod**. The reference neither imitates nor uses the voice of any
*The Witcher 3* actress or voice actor.

The reference recording and signed consent document remain private. They are
not included on GitHub, Nexus Mods, or in the installable package.

The scripts and documentation were developed with assistance from Claude,
Gemini, and ChatGPT/Codex, under human direction, data editing, batch execution,
listening review, and in-game validation.

## Fan work disclaimer

This is an unofficial fan project and is not approved or endorsed by CD
PROJEKT RED. *The Witcher*, its characters, and the original game assets belong
to their respective rights holders. See the
[CD PROJEKT RED Fan Content Guidelines](https://www.cdprojektred.com/en/fan-content).

The mod is free and may not be placed behind a paywall. Version `1.0.0` must be
published without Donation Points or monetization until that use is explicitly
covered by the voice performer's consent.

## Installable mod compatibility

Requirements:

- *The Witcher 3* 4.04 for PC;
- in-game voice language set to Brazilian Portuguese;
- Custom Player Characters installed and configured separately.

It is incompatible with other mods that replace the same `brpc.w3speech` file
or Geralt's Brazilian Portuguese voice lines.

Nexus archive structure:

```text
modCustomPlayerVoiceBR/
  content/
    brpc.w3speech
```

## Repository contents

- conservative text preparation and cleanup;
- per-ID corrections and preservation of non-verbal sounds;
- resumable OmniVoice batch execution;
- adaptive post-processing with FFmpeg;
- batch conversion to WEM Opus with Wwise;
- indexing of all 34 official voice packages;
- compact `brpc.w3speech` assembly while preserving the original CR2W data;
- format, mapping, and coverage audits;
- automated pipeline tests.

The repository **does not contain** reference recordings, game audio, community
CSV data, WAV, WEM, `w3speech`, models, caches, or signed documents.

## Reproducing the pipeline

See [docs/PIPELINE.md](docs/PIPELINE.md). The process requires users to obtain
their own input data legally and configure:

- Python 3.11 or newer;
- a working OmniVoice installation;
- FFmpeg;
- Wwise 2021.1.7.7796;
- their own authorized voice reference;
- a local installation of *The Witcher 3* 4.04.

The repository scripts use only the Python standard library. To run the tests:

```powershell
py -3 -m unittest discover -s tests -v
```

## Documentation

The detailed technical documents are currently written in Brazilian Portuguese:

- [Technical pipeline](docs/PIPELINE.md)
- [Sanitized technical history](docs/HISTORICO_TECNICO.md)
- [Nexus Mods description](docs/NEXUS_DESCRIPTION.md)
- [Reviewed publication policies](docs/POLITICAS_PUBLICACAO.md)
- [Safe GitHub publishing guide](docs/PUBLICAR_GITHUB.md)
- [Publication checklist](docs/RELEASE_CHECKLIST.md)
- [Voice and asset policy](ASSET_LICENSE.md)
- [Version history](CHANGELOG.md)

To turn an already-tested folder into the public package, use
`preparar_release_nexus.ps1`. The script checks the size, copies the final
folder under the public name, calculates its SHA-256 checksum, and optionally
creates a `.7z` archive when 7-Zip is installed.

## Licenses

The original source code in this repository is licensed under the MIT License.
That license does not extend to the game, CD PROJEKT RED assets, the voice
performer's voice, or the audio package distributed through Nexus Mods. See
[ASSET_LICENSE.md](ASSET_LICENSE.md).
