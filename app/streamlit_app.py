import streamlit as st
import pandas as pd
import numpy as np
import plotly.graph_objects as go
import pickle

# === PAGE CONFIG ===
st.set_page_config(
    page_title="Human Development Forecaster",
    page_icon="🌍",
    layout="wide"
)

# === LOAD DATA ===
@st.cache_data
def load_data():
    combined    = pd.read_csv('outputs/combined_hdi.csv')
    forecasts   = pd.read_csv('outputs/xgboost_forecasts.csv')
    historical  = pd.read_csv('data/country_panel_full_clean.csv')
    return combined, forecasts, historical

combined, forecasts, historical = load_data()

# === LOAD MODEL ===
@st.cache_resource
def load_model():
    with open('models/xgboost_model.pkl', 'rb') as f:
        model = pickle.load(f)
    with open('models/label_encoder.pkl', 'rb') as f:
        le = pickle.load(f)
    return model, le

model, le = load_model()

# === HEADER ===
st.title("🌍 Human Development Forecaster")
st.markdown("**Predicting national human development trajectories from 1990 to 2026**")
st.markdown("---")

# === SIDEBAR ===
st.sidebar.title("🔍 Select Country")
countries = sorted(forecasts['country_name'].unique().tolist())
selected_country = st.sidebar.selectbox("Choose a country:", countries)

st.sidebar.markdown("---")
st.sidebar.markdown("**About this project**")
st.sidebar.markdown("""
- 📊 Data: World Bank (168 countries)
- 🤖 Model: XGBoost (R² = 0.985)
- 📅 Forecast: 2022–2026
- 🛠️ Stack: SQL → Python → Power BI → AWS
""")

# === FILTER DATA FOR SELECTED COUNTRY ===
country_combined  = combined[combined['country_name'] == selected_country]
country_forecasts = forecasts[forecasts['country_name'] == selected_country]
country_historical = historical[historical['country_name'] == selected_country]

# === KPI METRICS ===
current_hdi  = country_historical[country_historical['year'] == 2021]['hdi_proxy'].values
forecast_hdi = country_forecasts[country_forecasts['forecast_year'] == 2026]['forecast_hdi'].values
hdi_change   = country_forecasts[country_forecasts['forecast_year'] == 2026]['hdi_change'].values
change_pct   = country_forecasts[country_forecasts['forecast_year'] == 2026]['change_pct'].values

col1, col2, col3, col4 = st.columns(4)

with col1:
    st.metric(
        label="🏳️ Country",
        value=selected_country
    )
with col2:
    st.metric(
        label="📊 Current HDI (2021)",
        value=f"{current_hdi[0]:.3f}" if len(current_hdi) > 0 else "N/A"
    )
with col3:
    st.metric(
        label="🔮 Forecast HDI (2026)",
        value=f"{forecast_hdi[0]:.3f}" if len(forecast_hdi) > 0 else "N/A",
        delta=f"{hdi_change[0]:.3f}" if len(hdi_change) > 0 else "N/A"
    )
with col4:
    st.metric(
        label="📈 Expected Change",
        value=f"{change_pct[0]:.1f}%" if len(change_pct) > 0 else "N/A"
    )

st.markdown("---")

# === LINE CHART ===
col_left, col_right = st.columns([2, 1])

with col_left:
    st.subheader(f"📈 HDI Trend & Forecast — {selected_country}")

    hist_data = country_combined[country_combined['data_type'] == 'Historical']
    fore_data = country_combined[country_combined['data_type'] == 'Forecast']

    fig = go.Figure()

    # Historical line
    fig.add_trace(go.Scatter(
        x=hist_data['year'],
        y=hist_data['hdi_value'],
        mode='lines',
        name='Historical',
        line=dict(color='#2196F3', width=3)
    ))

    # Forecast line
    fig.add_trace(go.Scatter(
        x=fore_data['year'],
        y=fore_data['hdi_value'],
        mode='lines+markers',
        name='Forecast',
        line=dict(color='#FF9800', width=3, dash='dash'),
        marker=dict(size=8)
    ))

    fig.update_layout(
        xaxis_title='Year',
        yaxis_title='HDI Score (0–1)',
        legend=dict(orientation='h', y=1.1),
        hovermode='x unified',
        height=400,
        plot_bgcolor='white',
        yaxis=dict(gridcolor='#f0f0f0'),
        xaxis=dict(gridcolor='#f0f0f0')
    )

    st.plotly_chart(fig, use_container_width=True)

with col_right:
    st.subheader("🔑 Key Indicators")

    life_exp = country_historical['life_expectancy'].mean()
    sec_enr  = country_historical['secondary_enrollment'].mean()
    gdp_log  = country_historical['log_gdp_per_capita'].mean()

    st.metric("❤️ Avg Life Expectancy", f"{life_exp:.1f} years")
    st.metric("🎓 Avg Secondary Enrollment", f"{sec_enr:.1f}%")
    st.metric("💰 Avg GDP per Capita (log)", f"{gdp_log:.2f}")

st.markdown("---")

# === FEATURE IMPORTANCE ===
st.subheader("🎯 What Drives HDI Forecasts?")

feature_cols = [
    'inflation', 'unemployment', 'trade_pct_gdp',
    'govt_expenditure', 'urban_pop_pct', 'internet_users',
    'liquid_liabilities_gdp', 'bank_zscore', 'bank_npl',
    'bank_capital_ratio', 'bank_roa', 'life_expectancy',
    'clean_water_access', 'primary_enrollment', 'secondary_enrollment',
    'edu_expenditure', 'log_gdp_per_capita', 'log_private_credit_gdp',
    'hdi_proxy', 'country_encoded', 'year'
]

importance_df = pd.DataFrame({
    'Feature':    feature_cols,
    'Importance': model.feature_importances_
}).sort_values('Importance', ascending=True).tail(10)

fig2 = go.Figure(go.Bar(
    x=importance_df['Importance'],
    y=importance_df['Feature'],
    orientation='h',
    marker_color='#2196F3'
))

fig2.update_layout(
    xaxis_title='Importance Score',
    yaxis_title='Feature',
    height=400,
    plot_bgcolor='white',
    xaxis=dict(gridcolor='#f0f0f0')
)

st.plotly_chart(fig2, use_container_width=True)

# === FOOTER ===
st.markdown("---")
st.markdown("Built with ❤️ using XGBoost, Python, SQL Server & Streamlit | Data: World Bank")