#This is a helper function
#The purpose of this helper defined here is to take in the inputs, i.e. 
#the state, year range (from 1975 to 2017), and the level of study (undergrad, grad, professional, or total)
#and return a filtered out subset of the data relevant to the inputs. 
filter_data <- function(data, state, year_range, level) {
  data %>%
    dplyr::filter(State == state,
                  Year >= year_range[1],
                  Year <= year_range[2]) %>%
    dplyr::select(Year, all_of(level))
}