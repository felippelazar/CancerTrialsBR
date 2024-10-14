---
title: "Início"
output: 
  md_document:
    variant: gfm  # GitHub-flavored Markdown (for better rendering on GitHub)
    preserve_yaml: true  # Keep YAML metadata in the output
---

Bem-vindo a página do repositório do projeto **CancerTrialsBR** -
Plataforma Colaborativa de Estudos Clinicos em Oncologia.

Neste página você irá encontrar informações sobre o projeto, o banco de
dados (**aberto**), dicionário de dados, como ajudar, contatos, entre
outras informações. Para acessar a aplicação web:
<https://www.cancertrials.com.br>

**NOTA**: A página é atualizada diariamente, porém as vezes o navegador
pode manter em cache a versão anterior. Caso você encontre alguma
informação desatualizada, tente limpar o cache do seu navegador ou abre
essa página em navegação privada.

## 📑 **Índice**

1.  [📋 Sobre o Projeto](#sobre-o-projeto)  
2.  [🚀 Como Funciona](#como-funciona)
3.  [🙌 Como Ajudar](#como-ajudar)
4.  [📄 Relatórios Disponíveis](#relatórios-disponíveis)  
5.  [📦 Estrutura do Repositório](#estrutura-do-repositório)  
6.  [🛠️ Tecnologias Utilizadas](#tecnologias-utilizadas)  
7.  [📝 Licença](#licença)

## 📋 **Sobre o Projeto**

Este projeto têm como objetivo facilitar a busca de estudos clínicos
disponíveis em oncologia no Brasil. A ideia é que esta plataforma seja:

- **Colaborativa**: Pesquisadores ou médicos dos centros participantes
  podem sugerir alterações de status de recrutamento dos estudos que são
  automaticamente atualizados no banco de dados.

- **Transparente**: Todos as sugestões realizadas serão disponibilizadas
  nesse repositório e atualizadas na base diariamente, assim como o
  próprio banco de dados final para fins de pesquisa e consulta.

- **Independente**: O projeto não apresenta vínculo formal com nenhuma
  instituição e não prioriza centros ou estudos na disponibilização dos
  dados.

## 🚀 **Como Funciona**

1.  Os dados são baixados diariamente do *clinicaltrials.gov* (via API)
    com os filtros de estudos com **recrutamento ativo** e localidade no
    **Brasil**
2.  Os dados são pré-processados com ferramentas de **grandes modelos de
    linguagem (*Large Language Models*)** para criar os textos em
    português com otimização de *prompts* otimizados
3.  Os centros são localizados no google e retornados com a sua
    localização mais precisa. É realizado uma verificação da localização
    encontrada e localidade descrita com uso novamente de modelos de
    LLM.
4.  Os dados com incompatibilidade ou dúvidas, são revisados
    manualmente.
5.  Novos centros ou alterações de status de recrutamento são
    atualizados diariamente conforme sugestão dos usuários
6.  Um banco de dados formatado é então disponibilizado neste
    repositório para uso de pesquisadores e médicos no Brasil.
7.  São criados PDFs com os estudos e localidades diariamente para
    facilitar o compartilhamento e acesso

## 🙌 Como Ajudar

A **qualidade desse banco de dados** depende da sua ajuda! Muitos status
de recrutamento e informações de identificação de localidades são
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

Em breve disponibilizaremos uma aba na página desse repositório para
facilitar a identificação de centros.

## 📄 **Relatórios Disponíveis**

- Você poderá consultar relatórios disponíveis na aba estatísticas (*em
  produção ainda*).

## 📦 Estrutura do Repositório

O repositório é organizado da seguinte maneira: - Na pasta `raw_data`
estão os *logs* de sugestões dos usuários para atualização dos dados. -
Na pasta `data` encontra-se o banco de dados propriamente dito em
formato excel. Nesta mesma pasta encontra-se o dicionário dos dados.

## 🛠️ Tecnologias Utilizadas

- O site, todo o código de atualização dos dados e o código de geração
  dos PDFs foi escrito na linguagem **R** com uso do **Rmarkdown** e
  **RShiny**.
- No momento, o código **não** se encontra disponível publicamente,
  apenas os dados gerados por ele.

## 📜 Licença

Os dados neste repositório estão licenciados sob a [Licença CC BY-NC
4.0](http://creativecommons.org/licenses/by-nc/4.0/).

### ✔️ Citação

Ao usar os dados deste repositório, cite da seguinte forma:

    @misc{cancertrialsBR,
      author       = {{CancerTrialsBR}},
      title        = {Plataforma Colaborativa de Estudos Clínicos em Oncologia},
      howpublished = {\url{https://github.com/felippelazar/CancerTrialsBR}},
      year         = {2024},
      note         = {Licenciado sob a Licença CC BY-NC 4.0}
    }

NOTA: Essa citação pode ser facilmente importada para programas de
gerenciamento de referências (como Zotero, Mendeley ou EndNote) permite
que você importe arquivos BibTeX. Copie o código abaixo, salve em uma
arquivo de texto com o final `.bib` e **importe** diretamente nos
programa que utiliza.

### 🔒 Uso Não Comercial

Os dados fornecidos aqui não podem ser usados para fins comerciais.
