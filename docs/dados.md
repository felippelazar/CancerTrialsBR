---
title: "Dados"
output: 
  md_document:
    variant: gfm  # GitHub-flavored Markdown (for better rendering on GitHub)
    preserve_yaml: true  # Keep YAML metadata in the output
---

<script async src="https://scripts.simpleanalyticscdn.com/latest.js"></script>

## 🗄️ Banco de Dados

O banco de dados do projeto **CancerTrialsBR** está disponível neste
repositório para uso de pesquisadores e médicos no Brasil.

🔗 [Acesse o banco de dados
aqui](https://github.com/felippelazar/CancerTrialsBR/blob/main/data/cancer_trials_db.xlsx)

## 📚 Dicionário de Dados

Aqui está um guia detalhado das variáveis em nosso banco de dados:

### 📝 Informações do Estudo

| Variável                     | Descrição                                              |
|------------------------------|--------------------------------------------------------|
| **estudo_id**                | 🆔 Identificador do estudo no *clinicaltrials.gov*     |
| **estudo_acronimo**          | 🏷️ Acrônimo do estudo                                  |
| **estudo_patrocinador**      | 💼 Patrocinador do estudo                              |
| **estudo_titulo**            | 📰 Título oficial do estudo                            |
| **estudo_desenho**           | 🎨 Desenho do estudo                                   |
| **estudo_resumo_ia**         | 🤖 Resumo do estudo gerado por Inteligência Artificial |
| **estudo_sentenca_ia**       | 🖋️ Título em formato de sentença gerado por IA         |
| **estudo_paciente_ideal_ia** | 👤 Perfil do paciente ideal gerado por IA              |

### 🩺 Tipos de Câncer

A variável **estudo_tipo_cancer** indica o(s) tipo(s) de câncer
estudado(s), separados por ‘\|’.

📋 Lista completa de acrônimos de tipos de câncer

| Acrônimo | Tipo de Câncer          |
|----------|-------------------------|
| LEUKE    | Leucemia                |
| BRATU    | Sistema Nervoso Central |
| COLRC    | Colorretal              |
| ANALC    | Canal Anal              |
| NEUTU    | Neuroendócrino          |
| LYMPH    | Linfoma                 |
| MELAN    | Melanoma                |
| BLADC    | Bexiga                  |
| BTCCC    | Via Biliar              |
| ENDOC    | Endométrio              |
| CERVC    | Colo de Útero           |
| GYNCN    | Ginecológicos           |
| LUNGC    | Pulmão                  |
| OTHSO    | Outro                   |
| THYRC    | Tireoide                |
| HEANC    | Cabeça e Pescoço        |
| MYELO    | Mieloma                 |
| PROSC    | Próstata                |
| NTUMD    | Não-Câncer              |
| BREAC    | Mama                    |
| ESOPC    | Esôfago                 |
| HEPCC    | Fígado                  |
| CUTNM    | Pele Não Melanoma       |
| GASTC    | Gástrico                |
| SFTTS    | Sarcoma Partes Moles    |
| GISTT    | GIST                    |
| OSTES    | Ósseos                  |
| OVARC    | Ovário                  |
| OTHHT    | Outros Hematológicos    |
| RECAL    | Rim                     |
| PANCR    | Pâncreas                |
| ANYCA    | Múltiplos Tumores       |

### 🏥 Informações do Centro

| Variável            | Descrição                            |
|---------------------|--------------------------------------|
| **centro_nome**     | 🏫 Nome do centro                    |
| **centro_estado**   | 🗺️ Estado do centro                  |
| **centro_endereco** | 📍 Endereço do centro (Cidade e CEP) |
| **centro_status**   | 🚦 Status do centro                  |

------------------------------------------------------------------------

💡 **Dica**: Para uma análise mais eficiente, recomendamos o uso de
ferramentas como Python (com pandas) ou R para manipulação e
visualização destes dados.
