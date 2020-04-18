---
title: COVID19 Projection for Bangladesh (Run 1)
authors: []
date: '2020-04-17'
slug: 'covid19-projection-bangladesh-run1'
subtitle: ''
summary: 'An SEIR model was fitted to Bangladesh COVID19 incidence data with 5-day and 100-day initial projection. This initial model suggets the peak will occur in early to mid June. The pandemic will likely tapper off by early August.'
categories: ["COVID19"]
tags: ["COVID19"]
lastmod: '2020-04-18'
draft: false

featured: false

image:
  placement: 1
  caption: ""
  focal_point: "Center"
  preview_only: true
projects: ["covid19"]
---




In this post I fit an SEIR model to the COVID19 data for Bangladesh. In this run, we fit the data available up to April 17, 2020. 

## Methodology

This projection is based on an SEIR model. Here, the **S** stands for Susceptible, **E** stands for Exposed/infected but asymptomatic, **I** stands for Infected **and** symptomatic, and **R** stands for Recovered. N is the population size.

Assuming there is no births or deaths in a population, (known as a closed population), the model is formulated by the following differential equations.


$$
\\begin{align}
\\frac{\\partial S}{\\partial t} & = -\\frac{\\beta I S}{N} \\\\
\\frac{\partial E}{\\partial t} &= \\frac{\\beta I S}{N} -\\sigma E \\\\
\\frac{\partial I}{\\partial t} &= \\sigma E - \\gamma I \\\\
\\frac{\partial R}{\\partial t} &= \\gamma I
\\end{align}
$$

Here the parameters \$\\beta\$ controls the transmission rate, which is the product of contact rate and the probability of transmission given contact betwen S and E compartments. \$\\sigma\$ controls the transition from E to I, and \$\\gamma\$ controls the transition from I to R.

The reproduction rate, \$R\_0\$ can be approximated by 
$$
R_0 = \\frac{\\beta}{\\gamma}
$$

In plain language, \$R\_0\$ tells us how many people are infected from one patient. An \$R\_0>1\$ indicates the epidemic is at the grotwh phase. \$R\_0<1\$ means the epidemic is slowing or decaying. 

Model was fitted using all but the last two day's incidences to obtain the estimated \$\\beta\$ and \$\\gamma\$. The fitted model was used for prediction. This post was inspired by [^1].

### Ascertainment Rate

Not all the cases are reported or tested. Usually a fraction of the actual cases are detected. This is known as ascertainment rate. We consider 25\%, 50\%, 75\% amd 90\% ascertainment rate when fitting the model. 

Simply, the incidences are inflated by the inverse of the ascertainment rate.


### R code for fitting SEIR

Please let me know if you find any error in it. The code was adapted from [^1].



```r
library(deSolve)
library(grid)
library(gridExtra)
```

```
## 
## Attaching package: 'gridExtra'
```

```
## The following object is masked from 'package:dplyr':
## 
##     combine
```

```r
######################################
## SIER Modeling -------
######################################
# Parameters
# beta = rate of expusore from susceptible infected contact 
# sigma = rate at which exposed person becomes infected
# gamma = rate at which infected person recovers
# S = Initial susceptible population
# E = Initial exposed population
# I = Initial infected population
# R = Recovered population

fit_seir <- function(country_name='Bangladesh(unoff)', 
                     N=170000000, af=0.5, npast=2, nfuture=10){
  # country = Country name
  # N = population size of the country
  # af = ascertainment factor, default = 0.5
  # country = "Bangladesh(unoff)"
  # npast = number of days in the past to exclude when fitting the model
  # default is npast = 5
  # nfuture = number of days in the future the algorithm to predict to
  # default is nfuture=10
  
  
  SEIR <- function(time, state, parameters) {
    par <- as.list(c(state, parameters))
    with(par, {
      dS <- -beta * I * S/N
      dE <- beta * I * S/N - sigma * E
      dI <- sigma * E - gamma * I
      dR <- gamma * I
      list(c(dS, dE, dI, dR))
    })
  }
  
  
  # define a function to calculate the residual sum of squares
  # (RSS), passing in parameters beta and gamma that are to be
  # optimised for the best fit to the incidence data
  
  RSS <- function(parameters) {
    names(parameters) <- c("beta", "sigma", "gamma")
    out <- ode(y = init, times = Day, func = SEIR, parms = parameters)
    fit <- out[, 4]
    sum((infected - fit)^2)
  }
  
  
  country = enquo(country_name)
  run0_date = ymd("2020-04-17")
  df <- bd_unoff %>% filter(country == !!country, 
                            cum_cases>0, date <= run0_date)
  infected <- df %>% filter(date >= min(date), 
                            date <= today() - 1 - npast) %>% 
    pull(cum_cases)
  
  R = 0; E=0; I = infected[1]; S = N - E - I - R
  
  seir_start_date <- df %>% pull(date) %>% min()
  
  # Ascertainment factor
  infected = infected * 1/af

  
  # Create an incrementing Day vector the same length as our
  # cases vector
  Day <- 1:(length(infected))
  
  # now specify initial values for S, I and R
  init <- c(S = S, E=E, I=I, R=R)
  
  # now find the values of beta and gamma that give the
  # smallest RSS, which represents the best fit to the data.
  # Start with values of 0.5 for each, and constrain them to
  # the interval 0 to 1.0
  
  opt <- optim(c(.5, .5, .5), RSS, method = "L-BFGS-B", 
               lower = c(0.01,0.01,0.01), upper = c(.999, .999, .999), 
               control=list(maxit = 1000))
  
  # check for convergence
  opt_msg = opt$message
  opt_par <- setNames(opt$par, c("beta", "sigma", "gamma"))

  beta = opt_par["beta"]
  gamma = opt_par["gamma"]
  sigma = opt_par["sigma"]
  R0 = as.numeric(beta/gamma)
  
  
  # time in days for predictions
  t <- 1:(as.integer(today() - seir_start_date)  + nfuture)
  
  # get the fitted values from our SEIR model
  
  odefit = ode(y = init, times = t, func = SEIR, parms = opt_par)
  fitted_cases <- data.frame(odefit)
  
  # add a Date column and join the observed incidence data
  fitted_cases <- fitted_cases %>% 
    mutate(date = seir_start_date + days(t - 1)) %>% 
    left_join(df %>% filter(cum_cases>0) %>% ungroup() %>%
                select(date, cum_cases))
  
  
  # Return
  list(country=country_name, infected = infected,
       opt_msg=opt_msg, opt_par = opt_par, R0=R0, opt_msg=opt_msg, 
       fitted_cases=fitted_cases, N=N, af=af)
  
}
```


<img src="/post/2020-04-17-covid19Projection/index_files/figure-html/projection-bangladesh-graph-1.png" width="960" />

It turns out that the bottom left one fits the current data best. So lets put that figure on a bigger canvas.


<img src="/post/2020-04-17-covid19Projection/index_files/figure-html/projection-bangladesh-graph-best-1.png" width="960" />

### Projection for the next 5 days

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>Table 1: Predicted new cases for the next 5 days</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:left;"> Date </th>
   <th style="text-align:right;"> Actual daily cases </th>
   <th style="text-align:right;"> Projected daily cases </th>
   <th style="text-align:right;"> Actual cumulative cases </th>
   <th style="text-align:right;"> Projected cumulative cases </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 36 </td>
   <td style="text-align:left;"> 2020-04-12 </td>
   <td style="text-align:right;"> 139 </td>
   <td style="text-align:right;"> 142 </td>
   <td style="text-align:right;"> 621 </td>
   <td style="text-align:right;"> 840 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 37 </td>
   <td style="text-align:left;"> 2020-04-13 </td>
   <td style="text-align:right;"> 182 </td>
   <td style="text-align:right;"> 172 </td>
   <td style="text-align:right;"> 803 </td>
   <td style="text-align:right;"> 1012 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 38 </td>
   <td style="text-align:left;"> 2020-04-14 </td>
   <td style="text-align:right;"> 209 </td>
   <td style="text-align:right;"> 206 </td>
   <td style="text-align:right;"> 1012 </td>
   <td style="text-align:right;"> 1218 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 39 </td>
   <td style="text-align:left;"> 2020-04-15 </td>
   <td style="text-align:right;"> 219 </td>
   <td style="text-align:right;"> 248 </td>
   <td style="text-align:right;"> 1231 </td>
   <td style="text-align:right;"> 1466 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 40 </td>
   <td style="text-align:left;"> 2020-04-16 </td>
   <td style="text-align:right;"> 341 </td>
   <td style="text-align:right;"> 298 </td>
   <td style="text-align:right;"> 1572 </td>
   <td style="text-align:right;"> 1764 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 41 </td>
   <td style="text-align:left;"> 2020-04-17 </td>
   <td style="text-align:right;"> 266 </td>
   <td style="text-align:right;"> 359 </td>
   <td style="text-align:right;"> 1838 </td>
   <td style="text-align:right;"> 2123 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 42 </td>
   <td style="text-align:left;"> 2020-04-18 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 433 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 2556 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 43 </td>
   <td style="text-align:left;"> 2020-04-19 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 521 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 3077 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 44 </td>
   <td style="text-align:left;"> 2020-04-20 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 626 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 3703 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 45 </td>
   <td style="text-align:left;"> 2020-04-21 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 754 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 4457 </td>
  </tr>
</tbody>
</table>

### Projection for 100 days into the future

Assuming the situation will remain like this including the interventions currently in place, the 100 day projection suggests that the the peak of the epidemic will be around the middle of June. The trajectory also suggests that the epidemic will end by end of July or early August. 

<img src="/post/2020-04-17-covid19Projection/index_files/figure-html/projection-bangladesh-graph-100-1.png" width="960" />


## References

[^1]: Churches (2020, Feb. 18). Tim Churches Health Data Science Blog: Analysing COVID-19 (2019-nCoV) outbreak data with R - part 1. Retrieved from https://timchurches.github.io/blog/posts/2020-02-18-analysing-covid-19-2019-ncov-outbreak-data-with-r-part-1/


