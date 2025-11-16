# 📊 Data Analysis Using MySQL — Layoff Dataset

This repository contains the complete **Data Cleaning** and **Exploratory Data Analysis (EDA)** process performed on a real-world **Layoff Dataset** using **MySQL**.  
The goal is to clean raw data, fix inconsistencies, and run SQL-based analysis to understand global layoff patterns across companies, industries, and countries.

---

## 📁 Project Overview

In this project, the following steps were performed:

### 🧹 1. Data Cleaning (MySQL)
The raw dataset contained duplicates, missing values, inconsistent formatting, and invalid entries.  
Steps performed:

- Removed duplicate rows using `ROW_NUMBER()`
- Standardized text fields using `TRIM()`, `LOWER()`, and `REPLACE()`
- Fixed inconsistent industries, countries, and date formats
- Handled `NULL` values
- Created a cleaned **staging table**
- Deleted incorrect data and reinserted corrected values
- Recreated derived columns such as:
  ```sql
  UPDATE layoff_staging2
  SET row_num = ROW_NUMBER() OVER (
      PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
  );
