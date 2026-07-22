# Publicação segura no GitHub

Use uma pasta limpa criada a partir do ZIP público. Não transforme a pasta de
produção, que contém `private/`, `dados/`, `trabalho/` e `saida/`, diretamente
no repositório público.

## 1. Conferência local

No PowerShell, dentro da pasta pública:

```powershell
Get-ChildItem -Recurse -File |
    Where-Object {
        $_.Extension -in ".wav", ".wem", ".w3speech", ".bnk", ".zip", ".7z"
    } |
    Select-Object FullName,Length
```

O comando não deve encontrar nada. Procure também caminhos pessoais:

```powershell
Get-ChildItem -Recurse -File -Include *.py,*.md,*.toml,*.csv,*.txt,*.ps1 |
    Select-String -Pattern "C:\\Users\\","Downloads\\","Program Files\\" |
    Select-Object Path,LineNumber,Line
```

Exemplos genéricos podem mencionar `Program Files`; nomes de usuário ou pastas
reais do computador não podem aparecer.

## 2. Testes

```powershell
py -3 -m unittest discover -s tests -v
```

## 3. Primeiro commit

```powershell
git init
git branch -M main
git add .
git status
git commit -m "Publica pipeline v1.0.0"
```

Leia a lista de `git status` antes do commit. Ela não pode conter áudio, arquivos
do jogo, relatórios de produção ou documentos privados.

## 4. Repositório remoto

Crie um repositório vazio no GitHub, sem adicionar README ou licença pela
interface, e então use o endereço exibido pela plataforma:

```powershell
git remote add origin https://github.com/USUARIO/REPOSITORIO.git
git push -u origin main
git tag -a v1.0.0 -m "Versão 1.0.0"
git push origin v1.0.0
```

O `brpc.w3speech` não deve ser anexado ao histórico Git. O instalável fica no
Nexus Mods.
