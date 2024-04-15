Unearthed Disparities: Exploring the Effects of Earthquakes on HIV Care
Accessibility in Latin America
================
Honors Thesis by Abby Draeger (Advised by Sarah Lotspeich)
Last Updated: 15 April 2024

``` r
# Load packages
library(dplyr) ## for data wrangling
```

## Setup

The data are saved as the `data.csv` file in the GitHub repository and
can be read in using the following code.

``` r
# Read in data
dat_url = "https://raw.githubusercontent.com/sarahlotspeich/unearthed_disparities/main/data.csv"
dat = read.csv(file = dat_url)
```

## Sample Size

The data are given to you in a long format, meaning that there is one
row per earthquake per week. With 22 earthquakes potentially impacting
CCASAnet sites and a time period of 24 weeks before and after each
(i.e., 6 months), the total number of rows in our dataset is 1078. We
can check that this is true with the following code.

``` r
## Check that the number of rows is equal to what we expect
nrow(dat)
```

    ## [1] 1078

In models like this where we have repeated measurements over time, the
true “sample size” is driven not by the number of rows in our data but
by the number of unique study units. In our case, the earthquakes are
the study units, and we have 22 of them. The `Earthquake_id` column
distinguishes these units, and we can view the 22 values using the code
below.

``` r
## View the unique earthquakes included in our dataset
dat |> 
  select(Earthquake_id) |> ## take just the Earthquake_id column
  unique() ## and keep only unique values of it
```

    ##                                      Earthquake_id
    ## 1       M 5.0 - 3 km WSW of Conchagua, El Salvador
    ## 50            M 5.1 - 4 km E of Anse-à-Veau, Haiti
    ## 99            M 5.3 - 4 km S of Anse-à-Veau, Haiti
    ## 148           M 5.3 - 6 km SSE of Marale, Honduras
    ## 197            M 5.4 - 9 km W of San Bartolo, Peru
    ## 246              M 5.6 - 1 km SSE of Tigwav, Haiti
    ## 295               M 5.6 - 5 km SE of Tigwav, Haiti
    ## 344            M 5.6 - 6 km NW of Cocachacra, Peru
    ## 393                           M 5.7 - Haiti region
    ## 442                           M 5.8 - Haiti region
    ## 491                M 5.9 - 11 km WSW of Mala, Peru
    ## 540              M 5.9 - 4 km ESE of Tigwav, Haiti
    ## 589            M 6.0 - 4 km SSW of Grangwav, Haiti
    ## 638                              M 6.1 - Nicaragua
    ## 687        M 6.4 - 53 km ESE of Puente Alto, Chile
    ## 736  M 6.7 - 22 km NW of Hacienda La Calera, Chile
    ## 785           M 6.9 - 40 km W of Valparaíso, Chile
    ## 834          M 6.9 - 61 km NW of Santa Cruz, Chile
    ## 883             M 7.0 - 10 km SE of Léogâne, Haiti
    ## 932          M 7.0 - 52 km NW of Santa Cruz, Chile
    ## 981              M 7.1 - 1 km S of Matzaco, Mexico
    ## 1030                         M 7.2 - Nippes, Haiti

## Column Names

The dataset contains 10 columns, defined as follows.

1.  `Earthquake_id`: A unique identifier for each earthquake, which
    includes information both about its location and intensity. This
    variable is a `string` and takes on 22 possible values.
2.  `Earthquake_Date`: The corresponding date of the earthquake. This
    variable is read in as a `string` and takes on 22 possible values.
    Note: You will likely need to convert it to a `Date` object for the
    analysis.
3.  `MMI`: The modified Mercalli intensity. This variable is `numeric`.
4.  `Clinic`: The name of the CCASAnet clinic that was potentially
    impacted by the earthquake. This variable is a `string` and takes on
    5 possible values.
5.  `Week_Of`: The starting date of the week of the data collection.
    This variable is read in as a `string` and takes on 1078 possible
    values. Note: You will likely need to convert it to a `Date` object
    for the analysis.
6.  `Patients`: The median number of patients in care at the clinic for
    the week starting on `Week_Of`. This variable is `numeric`.
7.  `Visits`: The number of visits at the clinic for the week starting
    on `Week_Of`. This variable is `numeric`.
8.  `CD4`: The number of CD4 labs completed at the clinic for the week
    starting on `Week_Of`. This variable is `numeric`.
9.  `ViralLoad`: The number of viral load (RNA) labs completed at the
    clinic for the week starting on `Week_Of`. This variable is
    `numeric`.
10. `ART`: The number of new antiretroviral therapy (ART) regimens
    prescribed at the clinic for the week starting on `Week_Of`. This
    variable is `numeric`.

``` r
## View the first six rows in our dataset
dat |> 
  head()
```

    ##                                Earthquake_id Earthquake_Date MMI
    ## 1 M 5.0 - 3 km WSW of Conchagua, El Salvador      2006-09-04   3
    ## 2 M 5.0 - 3 km WSW of Conchagua, El Salvador      2006-09-04   3
    ## 3 M 5.0 - 3 km WSW of Conchagua, El Salvador      2006-09-04   3
    ## 4 M 5.0 - 3 km WSW of Conchagua, El Salvador      2006-09-04   3
    ## 5 M 5.0 - 3 km WSW of Conchagua, El Salvador      2006-09-04   3
    ## 6 M 5.0 - 3 km WSW of Conchagua, El Salvador      2006-09-04   3
    ##                  Clinic    Week_Of Patients Visits CD4 ViralLoad ART
    ## 1 Tegucigalpa, Honduras 2006-03-20     1160     97  53        41   6
    ## 2 Tegucigalpa, Honduras 2006-03-27     1242    109  43        42   4
    ## 3 Tegucigalpa, Honduras 2006-04-03     1249    101  33        43   5
    ## 4 Tegucigalpa, Honduras 2006-04-10     1186    121  38        47   6
    ## 5 Tegucigalpa, Honduras 2006-04-17     1173    111  37        46   4
    ## 6 Tegucigalpa, Honduras 2006-04-24     1179     92  44        50   5
