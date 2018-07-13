#' @export
tutorialplots <- function(text){
    all_data <- read.csv("/home/opencpu/tutorial/data/spending_with_drug_class_indic_10k.tsv", header = TRUE, sep = "\t")
    all_data["log_nb_beneficiaries"] <- log(all_data$nb_beneficiaries)
    all_data["log_spending"] <- log(all_data$spending)
    head(all_data)
    partial_spending_df <- subset(all_data, specialty %in% c("INTERNAL MEDICINE", "EMERGENCY MEDICINE", "PSYCHIATRY"))
    partial_spending_df
    spending_psych <- subset(all_data, specialty == "PSYCHIATRY")
    subset_df <- subset(partial_spending_df, indication_flag == 'antibiotic' | indication_flag == 'antipsychotic')
    subset_df
    head(spending_psych)
    par(mfrow = c(2, 2))

    boxplot(nb_beneficiaries ~ specialty,
            data = subset_df,
            main = "NB Benenficiaries vs Speciality",
            xlab = "NB Beneficiaries",
            ylab = "Specialty",
            horizontal = TRUE)

    boxplot(nb_beneficiaries ~ indication_flag,
            data = subset_df,
            main = "Log NB Benenficiaries vs Log Spending",
            xlab = "Log NB Beneficiaries",
            ylab = "Log Spending",
            horizontal = TRUE)
}