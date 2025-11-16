-- -- Exploratory Data Analysis -- --

select * from layoff_staging3;

select max(total_laid_off) 
from layoff_staging3;
# 12000 layoff in one day

select max(percentage_laid_off) 
from layoff_staging3;
# 100 % laid off

select * 
from layoff_staging3 
where percentage_laid_off=1 order by total_laid_off desc;

select company, sum(total_laid_off) 
from layoff_staging3 
group by company
order by 2 desc;

select min(`date`), max(`date`)
from layoff_staging3;
# after the pendemic (CORONA) time

select industry, sum(total_laid_off) 
from layoff_staging3 
group by industry
order by 2 desc;
# consumer industry has the highest laid offs 45182

select country, sum(total_laid_off) 
from layoff_staging3 
group by country
order by 2 desc;
# 256559 people in United States laid off, then INDIA at the second position

select year(`date`), sum(total_laid_off) 
from layoff_staging3 
group by year(`date`)
order by 2 desc;
# Highest laid off in year 2022: 160661
# then 2023: 125677

select stage, sum(total_laid_off) 
from layoff_staging3 
group by stage
order by 2 desc;
# Post-IPO has the highest number: 204132

select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoff_staging3 
group by `month` 
order by 2 desc; 
# there is a null entry of date too


select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoff_staging3 
where substring(`date`,1,7) is not null
group by `month` 
order by 2 desc; 

# CTE
with rolling_total as
(
select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off
from layoff_staging3 
where substring(`date`,1,7) is not null
group by `month` 
order by 1 asc
)
select `month`,total_off,sum(total_off) over(order by `month`)
from rolling_total;
# first 3 months of 2023 is very bad 125000+ people 

select company,year(`date`), sum(total_laid_off)
from layoff_staging3
group by company,year(`date`)
order by 3 desc ;

with company_year (company, years, total_laid_off) as
(
select company,year(`date`), sum(total_laid_off)
from layoff_staging3
group by company,year(`date`)
)
select *, dense_rank() over(partition by years order by total_laid_off desc)
from company_year;
# company Blackbaud has null years, so ignoring it

with company_year (company, years, total_laid_off) as
(
select company,year(`date`), sum(total_laid_off)
from layoff_staging3
group by company,year(`date`)
),company_year_rank as
(
select *, 
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select * 
from company_year_rank
where ranking<=5;
# all years top 5 layoff companies 
