
SEX_RATIO = 106
N_BURNIN = 2000
N_SIM = 2000
N_CHAIN = 4
N_THIN = 20


.PHONY: all
all: out/model.est


## Prepare data

data/census.rds : src/census.R \
                  data-raw/Age_by_sex/TABLECODE8001_Data_e35fb0f7-8ed5-4d62-86c4-269454dd04f4.csv
	Rscript $<

data/net_undercount.rds : src/net_undercount.R
	Rscript $<

data/reg_births.rds : src/reg_births.R \
                      data-raw/VSB355801_20181209_055056_66.csv
	Rscript $<

data/reg_deaths.rds : src/reg_deaths.R \
                      data-raw/VSD349201_20181209_054420_13.csv
	Rscript $<

data/arrivals_1216.rds : src/arrivals_1216.R \
                         data-raw/ITM525401_20181209_055319_42.csv
	Rscript $<

data/departures_1216.rds : src/departures_1216.R \
                           data-raw/ITM525401_20181209_055319_42.csv
	Rscript $<

data/arrivals_plt.rds : src/arrivals_plt.R \
                        data-raw/ITM340201_20181209_055538_93.csv
	Rscript $<

data/departures_plt.rds : src/departures_plt.R \
                              data-raw/ITM340201_20181209_055538_93.csv
	Rscript $<


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
	Rscript $<

out/data_models.rds : src/data_models.R \
                      data/net_undercount.rds
	Rscript $<

out/model.est : src/model.R \
                out/account.rds \
                out/system_models.rds \
                out/datasets.rds \
                out/data_models.rds
	Rscript $< --n_burnin $(N_BURNIN) --n_sim $(N_SIM) --n_chain $(N_CHAIN) --n_thin $(N_THIN)



## Clean up

.PHONY: clean
clean:
	rm -rf data
	rm -rf out
	mkdir -p data
	mkdir -p out

