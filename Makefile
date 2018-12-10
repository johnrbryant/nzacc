
SEX_RATIO = 106
N_BURNIN = 200000
N_SIM = 200000
N_CHAIN = 4
N_THIN = 500
N_BURNIN_LEX = 400000
N_SIM_LEX = 400000
N_CHAIN_LEX = 4
N_THIN_LEX = 1000


.PHONY: all
all: out/model_lex.est


## Prepare data

data/census.rds : src/census.R \
                  data-raw/QuickStatsPopulationandDwellings.xls
	Rscript $<

data/net_undercount.rds : src/net_undercount.R
	Rscript $<

data/reg_births.rds : src/reg_births.R \
                      data-raw/VSB355801_20181014_082447_13.csv
	Rscript $< --add_lexis FALSE

data/reg_births_lex.rds : src/reg_births.R \
                          data-raw/VSB355801_20181014_082447_13.csv
	Rscript $< --add_lexis TRUE

data/reg_deaths.rds : src/reg_deaths.R \
                      data-raw/VSD349201_20181014_082255_47.csv
	Rscript $< --add_lexis FALSE

data/reg_deaths_lex.rds : src/reg_deaths.R \
                          data-raw/VSD349201_20181014_082255_47.csv
	Rscript $< --add_lexis TRUE

data/arrivals_1216.rds : src/arrivals_1216.R \
                         data-raw/ITM525401_20181014_082741_1.csv
	Rscript $< --add_lexis FALSE

data/arrivals_1216_lex.rds : src/arrivals_1216.R \
                             data-raw/ITM525401_20181014_082741_1.csv
	Rscript $< --add_lexis TRUE

data/departures_1216.rds : src/departures_1216.R \
                           data-raw/ITM525401_20181014_082741_1.csv
	Rscript $< --add_lexis FALSE

data/departures_1216_lex.rds : src/departures_1216.R \
                               data-raw/ITM525401_20181014_082741_1.csv
	Rscript $< --add_lexis TRUE

data/arrivals_plt.rds : src/arrivals_plt.R \
                        data-raw/ITM340201_20181014_083122_44.csv
	Rscript $< --add_lexis FALSE

data/departures_plt_lex.rds : src/departures_plt.R \
                              data-raw/ITM340201_20181014_083122_44.csv
	Rscript $< --add_lexis TRUE




## Set up model

out/account.rds : src/account.R \
                  data/census.rds \
                  data/reg_births.rds \
                  data/reg_deaths.rds \
                  data/arrivals_plt.rds \
                  data/departures_plt.rds
	Rscript $< --sex_ratio $(SEX_RATIO)

out/system_models.rds : src/system_models.R
	Rscript $<

out/datasets.rds : src/datasets.R \
                   data/census.rds \
                   data/reg_births.rds \
                   data/reg_deaths.rds \
                   data/arrivals_1216.rds \
                   data/departures_1216.rds \
                   data/arrivals_plt.rds \
                   data/departures_plt.rds
	Rscript $< --add_lexis FALSE

out/datasets_lex.rds : src/datasets.R \
                       data/census.rds \
                       data/reg_births.rds \
                       data/reg_deaths.rds \
                       data/arrivals_1216.rds \
                       data/departures_1216.rds \
                       data/arrivals_plt.rds \
                       data/departures_plt.rds
	Rscript $< --add_lexis TRUE

out/data_models.rds : src/data_models.R \
                      data/net_undercount.rds
	Rscript $<

out/model.est : src/model.R \
                out/account.rds \
                out/system_models.rds \
                out/datasets.rds \
                out/data_models.rds
	Rscript $< --n_burnin $(N_BURNIN) --n_sim $(N_SIM) --n_chain $(N_CHAIN) --n_thin $(N_THIN) --add_lexis FALSE


out/model_lex.est : src/model.R \
                    out/account.rds \
                    out/system_models.rds \
                    out/datasets_lex.rds \
                    out/data_models.rds
	Rscript $< --n_burnin $(N_BURNIN_LEX) --n_sim $(N_SIM_LEX) --n_chain $(N_CHAIN_LEX) --n_thin $(N_THIN_LEX) --add_lexis TRUE



## Clean up

.PHONY: clean
clean:
	rm -rf data
	rm -rf out
	mkdir -p data
	mkdir -p out

