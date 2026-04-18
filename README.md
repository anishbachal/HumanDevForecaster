# 🌍 Human Development Forecaster

Predicting national Human Development Index (HDI) for **168 countries from 2022–2026** using machine learning on World Bank data.

![Python](https://img.shields.io/badge/Python-3.10-blue)
![XGBoost](https://img.shields.io/badge/Model-XGBoost-orange)
![R²](https://img.shields.io/badge/R²-0.9849-green)
![Streamlit](https://img.shields.io/badge/App-Streamlit-red)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📌 Project Overview

The Human Development Index (HDI) measures a country's average achievement in health, education, and standard of living. This project builds an **end-to-end ML pipeline** to forecast HDI trajectories 5 years into the future, helping identify which nations are improving fastest and which are falling behind.

**Key Findings:**
- 144 out of 168 countries are projected to **improve** by 2026
- Norway holds the **highest forecasted HDI**
- Cambodia shows the **fastest rate of improvement**
- XGBoost outperforms LSTM with an R² of **0.9849**

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Data Storage** | SQL Server (SSMS) |
| **Analysis & Modeling** | Python (Pandas, XGBoost, LSTM/Keras) |
| **Visualization** | Power BI |
| **Web App** | Streamlit |
| **Deployment** | AWS EC2 |

---

## 📂 Project Structure

```
HumanDevForecaster/
├── app/                    # Streamlit web application
│   └── streamlit_app.py
├── data/                   # Raw and cleaned datasets
│   ├── country_panel.csv
│   ├── country_panel_clean.csv
│   └── country_panel_full_clean.csv
├── models/                 # Trained model artifacts
│   ├── xgboost_model.pkl
│   ├── lstm_model.keras
│   ├── label_encoder.pkl
│   ├── feature_scaler.pkl
│   └── target_scaler.pkl
├── notebooks/              # Jupyter notebooks (full pipeline)
│   ├── 01_eda.ipynb
│   ├── 02_cleaning.ipynb
│   ├── 03_xgboost.ipynb
│   └── 04_lstm.ipynb
├── outputs/                # Forecasts and dashboard data
│   ├── xgboost_forecasts.csv
│   ├── lstm_forecasts.csv
│   ├── combined_hdi.csv
│   └── dashboard_forecasts.csv
├── sql/                    # SQL scripts for data ingestion
├── HumanDevForecaster.pbix # Power BI dashboard
├── .gitignore
└── README.md
```

---

## 🔄 Pipeline

### Phase 1 — SQL (Data Ingestion)
- Loaded 4 World Bank datasets (WDI, GFDD, HNP, Education)
- Unpivoted wide-format tables into long format
- Built a master `country_panel` table: **229 countries × 32 years × 25 indicators**

### Phase 2 — EDA
- Missing value analysis, distributions, correlations
- Trend analysis and country-level spotlights

### Phase 3 — Data Cleaning
- Dropped 7 redundant columns, removed 61 sparse countries
- Capped outliers, log-transformed skewed features
- Forward/backward fill + median imputation
- Engineered **HDI proxy score** as the target variable

### Phase 4 — XGBoost Model
- Temporal train/test split (1990–2012 train, 2013–2016 test)
- **MAE: 0.0148 | RMSE: 0.0197 | R²: 0.9849**
- Top features: `hdi_proxy` (66.9%), `secondary_enrollment` (22.7%)
- Generated 2022–2026 forecasts for 168 countries

### Phase 5 — LSTM Model
- 10-year sequence length
- MAE: 0.0307 | RMSE: 0.0405 | R²: 0.9359
- XGBoost selected as primary model due to superior performance

### Phase 6 — Power BI Dashboard
- Page 1: Global forecast map, Top 10 bar chart, KPI cards
- Page 2: Country deep dive with HDI trend line (1990–2026)

### Phase 7 — Streamlit App
- Interactive country selector with KPI metrics
- HDI trend & forecast chart (Plotly)
- Feature importance visualization
- Key indicator summary panel

---

## 🚀 Run Locally

```bash
# Clone the repo
git clone https://github.com/anishbachal/HumanDevForecaster.git
cd HumanDevForecaster

# Create virtual environment
python -m venv venv
source venv/bin/activate        # Mac/Linux
venv\Scripts\activate           # Windows

# Install dependencies
pip install -r requirements.txt

# Run the app
streamlit run app/streamlit_app.py
```

---

## 📊 Model Performance

| Model | MAE | RMSE | R² |
|-------|-----|------|-----|
| **XGBoost** | **0.0148** | **0.0197** | **0.9849** |
| LSTM | 0.0307 | 0.0405 | 0.9359 |

---

## 📈 Sample Output

| Country | HDI 2021 | Forecast 2026 | Change |
|---------|----------|---------------|--------|
| Norway | 0.961 | 0.968 | +0.7% |
| India | 0.644 | 0.670 | +4.0% |
| Cambodia | 0.539 | 0.583 | +8.2% |

---

## 👤 Author

**Anish Bachal**
- GitHub: [@anishbachal](https://github.com/anishbachal)

---

## 📄 License

This project is open source under the [MIT License](LICENSE).
