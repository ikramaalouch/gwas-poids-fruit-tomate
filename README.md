# Architecture génétique du poids du fruit chez la tomate (GWAS et haplotypes)

> **Projet personnel en cours** (depuis novembre 2026). Analyse menée sous R à partir de données publiques.

## Objectif

Reproduire, sur des données publiques, une démarche classique en génétique d'association :
partir d'une région QTL connue, y détecter un signal d'association en tenant compte de la
structure de population, puis aller au-delà du meilleur SNP grâce à une analyse des haplotypes.

Le caractère étudié est le **poids moyen du fruit**, et la région ciblée est celle du **QTL fw2.2**
(chromosome 2), un QTL majeur de la domestication de la tomate.

## Données

| Type | Source |
|---|---|
| Phénotypes (163 accessions, 55 variables) | Fichiers supplémentaires de Mata-Nicolás et al. (2020), *Horticulture Research* 7:66 |
| Passeport (groupe, pays, coordonnées) | Même article, fichier supplémentaire |
| Génotypes (SNP, génome de référence SL2.50) | Solanaceae Genomics Network (SGN), projet Varitome |

La collection comprend trois taxons :

* **SP** : *Solanum pimpinellifolium* (forme sauvage), 27 accessions
* **SLC** : *S. lycopersicum* var. *cerasiforme* (forme intermédiaire), 121 accessions
* **SLL** : *S. lycopersicum* var. *lycopersicum* (tomate cultivée), 15 accessions

Les fichiers de données ne sont pas redistribués ici. Ils peuvent être téléchargés aux sources ci-dessus.

## Démarche et résultats

### 1. Phénotypes et structure de population ✅

* Le poids du fruit va de 0,6 à 144 g (6 valeurs manquantes). Sa distribution est très asymétrique,
  donc il est transformé en log.
* Le poids suit un gradient net entre taxons : SP < SLC < SLL. SLC est très variable selon l'origine
  géographique. Cette forte structure doit être prise en compte dans le GWAS.

![Poids du fruit par espèce](figures/boxplot_espece.png)
![Poids du fruit par groupe](figures/boxplot_groupe.png)

### 2. Génotypes et contrôle qualité ✅

* Extraction de la région 49 à 53 Mb du chromosome 2 : 27 168 variants, dont 22 010 SNP,
  et 21 814 SNP conservés après contrôle qualité.
* 159 accessions ont à la fois un génotype et un phénotype (153 avec un poids du fruit).

### 3. GWAS en modèle mixte ✅

* Modèle mixte (`rrBLUP::GWAS`) avec matrice d'apparentement et composantes principales.
* Le SNP le plus associé se trouve à 50 932 309 pb (−log10(p) = 10,9), dans la région du QTL fw2.2.
* Le signal est stable avec 0, 3 ou 5 composantes principales.
* L'allèle alternatif est surtout porté par des accessions SLL (10 sur 13). Son effet persiste
  après correction par l'espèce (+0,75 en log par copie) puis par les 7 groupes (+0,95).

### 4. Haplotypes ✅

* Un bloc de 4 SNP en fort déséquilibre de liaison (r² ≥ 0,8) couvre environ 0,6 Mb.
* À groupe égal, l'haplotype H7 (13 accessions) est associé à des fruits environ 5,7 fois plus
  lourds que l'haplotype majoritaire H1 (124 accessions).

### 5. Prochaines étapes 🔄

* Recalculer l'apparentement et les composantes principales à partir de SNP situés **hors** de
  la région étudiée (autres chromosomes), pour éviter que la correction n'absorbe une partie du signal.
* ACP et classification des accessions à partir des caractères morphologiques.
* Script d'analyse de qPCR (quantification absolue par courbe étalon, et quantification relative ΔΔCt)
  sur des données **simulées**, clairement identifiées comme telles.

## Limites

* Seule une région de 4 Mb du chromosome 2 est analysée. L'apparentement et la structure sont
  estimés sur cette même région, ce qui peut réduire la puissance de détection (point corrigé à l'étape 5).
* Peu d'accessions portent l'allèle alternatif, et elles sont surtout cultivées (SLL) :
  l'effet du SNP est en partie confondu avec la domestication.
* Les 5 accessions SLC porteuses viennent toutes du Mexique et de Mésoamérique.
* Les haplotypes H2 à H6 ne sont portés que par une seule accession chacun et ne sont pas interprétables.
* Le meilleur SNP n'est pas en fort déséquilibre de liaison avec celui rapporté dans l'article
  (r² = 0,13) : l'analyse retrouve la **région** du QTL, pas le même SNP.

## Organisation du dépôt

```
├── README.md
├── scripts/
│   ├── 01_phenotypes.R    # import, transformation log, structure de population
│   └── 02_genotypes.R     # contrôle qualité, GWAS, haplotypes (en cours d'ajout)
└── figures/
```

## Outils

R (base R, rrBLUP).

## Référence

Mata-Nicolás E. et al. (2020). Exploiting the diversity of tomato: the development of a phenotypically
and genetically detailed germplasm collection. *Horticulture Research*, 7, 66.

## Auteure

Ikram Aalouch, élève-ingénieure en génétique et production de semences et plants, IAV Hassan II (Rabat, Maroc).
