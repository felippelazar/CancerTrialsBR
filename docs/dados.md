---
title: "Dados"
output: 
  md_document:
    variant: gfm  # GitHub-flavored Markdown (for better rendering on GitHub)
    preserve_yaml: true  # Keep YAML metadata in the output
---

### Banco de Dados

O banco de dados do projeto **CancerTrialsBR** é disponibilizado neste
repositório para uso de pesquisadores e médicos no Brasil. Para acessar
o banco, [clique
aqui](https://github.com/felippelazar/CancerTrialsBR/data).

### Dicionário de Dados

- **estudo_id**: Identificador do estudo no *clinicaltrials.gov*
- **estudo_acronimo**: Acrônimo do estudo
- **estudo_patrocinador**: Patrocinador do estudo
- **estudo_titulo**: Título oficial do estudo
- **estudo_desenho**: Desenho do estudo
- **estudo_resumo_ai**: Resumo do estudo gerado por Inteligência
  Artifical
- **estudo_sentenca_ai**: Título em formato de sentença do estudo gerado
  por Inteligência Artifical
- **estudo_paciente_ideal_ai**: Paciente ideal do estudo gerado por
  Inteligência Artifical
- **estudo_tipo_cancer**: Tipo de câncer estudado, separado por ‘\|’. Os
  acrônimos referem-se a:
  - LEUKE = Leucemia
  - BRATU = Sistema Nervoso Central
  - COLRC = Colorretal
  - ANALC = Canal Anal
  - NEUTU = Neuroendócrino
  - LYMPH = Linfoma
  - MELAN = Melanoma
  - BLADC = Bexiga
  - BTCCC = Via Biliar
  - ENDOC = Endométrio
  - CERVC = Colo de Útero
  - GYNCN = Ginecológicos
  - LUNGC = Pulmão
  - OTHSO = Outro
  - THYRC = Tireoide
  - HEANC = Cabeça e Pescoço
  - MYELO = Mieloma
  - PROSC = Próstata
  - NTUMD = Não-Cancer
  - BREAC = Mama
  - ESOPC = Esôfago
  - HEPCC = Fígado
  - CUTNM = Pele Não Melanoma
  - GASTC = Gástrico
  - SFTTS = Sarcoma Partes Moles
  - GISTT = GIST
  - OSTES = Ósseos
  - OVARC = Ovário
  - OTHHT = Outros Hematológicos
  - RECAL = Rim
  - PANCR = Pâncreas
  - ANYCA = Múltiplos Tumores
- **centro_nome**: Nome do centro
- **centro_estado**: Estado do centro
- **centro_endereco**: Endereço do centro (Cidade e CEP)
- **centro_status**: Status do centro
