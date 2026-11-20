# =============================================================
# 01_phenotypes.R
# Import des phénotypes et du passeport, transformation du poids
# du fruit, visualisation de la structure de population
# Données : Mata-Nicolás et al. (2020), Horticulture Research
# =============================================================

# ---- 1. Chemins des fichiers (à adapter) ----
fichier_pheno     <- "data/csv quantitative.csv"
fichier_passeport <- "data/41438_2020_291_moesm4_esm(Hoja 1).csv"
dir.create("figures", showWarnings = FALSE)

# ---- 2. Import des phénotypes ----
# Séparateur point-virgule, virgule décimale -> read.csv2
pheno <- read.csv2(fichier_pheno)
names(pheno)[1] <- "Accession"

# Suppression des colonnes entièrement vides
pheno <- pheno[, colSums(!is.na(pheno)) > 0]
dim(pheno)                    # 163 accessions

# ---- 3. Poids du fruit : distribution et transformation log ----
summary(pheno$mean_weight)    # 0,6 à 144 g, 6 valeurs manquantes
pheno$log_weight <- log(pheno$mean_weight)

png("figures/histogrammes_poids.png", width = 900, height = 400)
par(mfrow = c(1, 2))
hist(pheno$mean_weight, main = "Poids du fruit (g)", xlab = "g")
hist(pheno$log_weight,  main = "log(poids du fruit)", xlab = "log(g)")
dev.off()

# ---- 4. Fusion avec le passeport ----
passeport <- read.csv2(fichier_passeport)
pheno2 <- merge(pheno, passeport[, c("Accession", "Group")], by = "Accession")
dim(pheno2)
table(pheno2$Group)

# Espèce = préfixe du groupe (SP, SLC, SLL)
pheno2$Species <- sub("_.*", "", pheno2$Group)
table(pheno2$Species)

# ---- 5. Structure de population : boxplots ----
png("figures/boxplot_groupe.png", width = 800, height = 500)
par(mar = c(9, 4, 2, 1))
boxplot(log_weight ~ Group, data = pheno2, las = 2, cex.axis = 0.8,
        xlab = "", ylab = "log(poids du fruit)")
dev.off()

png("figures/boxplot_espece.png", width = 700, height = 450)
boxplot(log_weight ~ Species, data = pheno2,
        xlab = "Espèce", ylab = "log(poids du fruit)")
dev.off()

# ---- 6. Sauvegarde pour le script suivant ----
saveRDS(pheno2, "pheno2.rds")
