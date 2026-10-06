# CancerTrialsBR

🏠 Bem-vindo a página do repositório do projeto **CancerTrialsBR** -
Plataforma Colaborativa de Estudos Clinicos em Oncologia.

Neste página você irá encontrar informações sobre o projeto, os scripts
em R utilizados para gerar o banco de dados, dados de exemplo, como
ajudar, entre outras informações. Para acessar a aplicação web:
<https://www.cancertrialsbr.com.br>

Para acessar o site do projeto, com o tutorial dos scripts e os
dashboards: <https://felippelazar.github.io/CancerTrialsBR>

## 📑 **Índice**

1.  [📋 Sobre o Projeto](#sobre-o-projeto)  
2.  [🚀 Como Funciona](#como-funciona)
3.  [🙌 Como Ajudar](#como-ajudar)
4.  [📊 Dashboards](#dashboards)  
5.  [📦 Estrutura do Repositório](#estrutura-do-repositório)  
6.  [🛠️ Tecnologias Utilizadas](#tecnologias-utilizadas)  
7.  [📝 Citação](#citação)

## **Sobre o Projeto**

Este projeto têm como objetivo facilitar a busca de estudos clínicos
disponíveis em oncologia no Brasil. A ideia é que esta plataforma seja:

- **Colaborativa**: Pesquisadores ou médicos dos centros participantes
  podem sugerir alterações de status de recrutamento dos estudos que são
  automaticamente atualizados no banco de dados.

- **Transparente**: O código utilizado para gerar o banco de dados e
  dados de exemplo estão disponíveis nesse repositório, e os dados
  atualizados podem ser consultados nos dashboards do projeto.

- **Independente**: O projeto não apresenta vínculo formal com nenhuma
  instituição e não prioriza centros ou estudos na disponibilização dos
  dados.

## **Como Funciona**

1.  Os dados são baixados diariamente do *clinicaltrials.gov* (via API)
    com os filtros de estudos com **recrutamento ativo** e localidade no
    **Brasil**.
2.  Os dados são pré-processados com ferramentas de **grandes modelos de
    linguagem (*Large Language Models*)** para criar os textos em
    português com *prompts* otimizados.
3.  Os centros são **localizados no google** e retornados com a sua
    localização mais precisa. É realizado uma verificação da localização
    encontrada e localidade descrita com uso novamente de modelos de
    LLM.
4.  Os dados com incompatibilidade ou dúvidas, são **revisados
    manualmente**.
5.  Novos centros ou alterações de status de recrutamento são
    **atualizados diariamente conforme sugestão dos usuários**.
6.  Um banco de dados formatado é então disponibilizado na aplicação web
    e nos dashboards para uso de pesquisadores e médicos no Brasil.

Para um passo a passo de cada etapa, acesse o
[tutorial](https://felippelazar.github.io/CancerTrialsBR/por/tutorial/).

## **Como Ajudar**

A **qualidade desse banco de dados** depende da sua ajuda! 🙌 Muitos
status de recrutamento e informações de identificação de localidades são
desatualizados na plataforma *clinicaltrials.gov* e a manutenção dessa
informação atualizada é chave na qualidade dos dados.

As duas principais formas de ajudar são:

1.  **Identificando Centros**: Muitos centros são difíceis de
    identificar pelas informações disponíveis. Nesses centros,
    disponibilizamos um ícone para sugestão de identificação. Caso você
    reconheça um centro participante pela descrição disponível, clique
    em **identificar centro** no próprio site.

2.  **Atualizando Status de Recrutamento**: Se você encontrar um centro
    de pesquisa com recrutamento desatualizado, clique em **reportar
    erro** ao lado do centro e sugira um novo status de recrutamento
    para esse centro.

## **Dashboards**

- O projeto disponibiliza dois dashboards: um com os **dados atuais**
  dos estudos e outro com os **acessos às páginas**. Para acessá-los,
  [clique aqui](https://felippelazar.github.io/CancerTrialsBR/por/dados.html).

## **Estrutura do Repositório**

O repositório é organizado da seguinte maneira:

- Na pasta `R` estão os scripts do *pipeline* (`00_functions.R` a
  `10_enriched_database.R`), executados em ordem a partir dessa pasta.

- Na pasta `R/data` estão os dados de exemplo gerados por cada etapa
  (`out_XX_*.json`) a partir de 5 estudos.

- O arquivo `index.Rmd`, as pastas `por` e `eng` e o `custom.scss`
  são o código do site em **Quarto**, gerado na pasta `docs`.

Para acessar o repositório, [clique
aqui](https://github.com/felippelazar/CancerTrialsBR)

## **Tecnologias Utilizadas**

- O site, todo o código de atualização dos dados e a aplicação web foram
  escritos na linguagem **R** com uso do **Quarto** e **RShiny**.
- Os scripts do *pipeline* estão disponíveis publicamente na pasta `R`.
  Para usar o LLM e o Google Maps, é preciso criar o arquivo
  `R/.Renviron` com as suas próprias chaves (veja o
  [tutorial](https://felippelazar.github.io/CancerTrialsBR/por/tutorial/)).

## **Citação**

Os dados desse projeto são baseados nos dados do *clinicaltrials.gov* e
foram processados e disponibilizados por esse repositório após
modificação e revisão, seguindo os termos de uso dos dados do
*clinicaltrials.gov*, que podem ser encontrados
[aqui](https://clinicaltrials.gov/about-site/terms-conditions).

Antes de utilizar os dados, leia os termos de uso do
*clinicaltrials.gov* e certifique-se de que está de acordo com eles.

Para citar o repositório, utilize a seguinte citação:

    @misc{cancertrialsBR,
      author       = {CancerTrialsBR},
      title        = {Plataforma Colaborativa de Estudos Clínicos em Oncologia Baseado no ClinicalTrials.gov},
      howpublished = {\url{https://github.com/felippelazar/CancerTrialsBR}},
      year         = {2024}
    }

NOTA: Essa citação pode ser facilmente importada para programas de
gerenciamento de referências (como Zotero, Mendeley ou EndNote) permite
que você importe arquivos BibTeX. Copie o código acima, salve em uma
arquivo de texto com o final `.bib` e **importe** diretamente nos
programa que utiliza.
