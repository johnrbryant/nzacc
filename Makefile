
N_BURNIN = 10000
N_SIM = 10000
N_CHAIN = 4
N_THIN = 40


.PHONY: all
all: out/model.est


## Prepare data

data/census.rds : src/census.R \
                  data-raw/QuickStatsPopulationandDwellings.xls
	Rscript $<

data/net_undercount.rds : src/net_undercount.R
	Rscript $<

data/reg_births.rds : src/reg_births.R \
                      data-raw/VSB355801_20181004_081753_17.csv
	Rscript $<

data/reg_deaths.rds : src/reg_deaths.R \
                      data-raw/VSD349201_20181004_082014_77.csv
	Rscript $<

data/arrivals.rds : src/arrivals.R \
                    data-raw/ITM525401_20181004_082501_59.csv
	Rscript $<

data/departures.rds : src/departures.R \
                      data-raw/ITM525401_20181004_082501_59.csv
	Rscript $<


## Set up model

out/account.rds : src/account.R \
                  data/census.rds \
                  data/reg_births.rds \
                  data/reg_deaths.rds \
                  data/arrivals.rds \
                  data/departures.rds
	Rscript $<

out/system_models.rds : src/system_models.R
	Rscript $<

out/datasets.rds : src/datasets.R \
                   data/census.rds \
                   data/reg_births.rds \
                   data/reg_deaths.rds \
                   data/arrivals.rds \
                   data/departures.rds
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

