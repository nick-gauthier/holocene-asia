cmfd <- list.files('~/Downloads/CMFD', full.names = TRUE) %>% map(~read_ncdf(., eps = 0.001, var = 'temp') %>%
                                                                    mutate(temp = units::set_units(temp, degree_C) %>% units::drop_units()) %>%
                                                                    transmute(gdd0 = if_else(temp > 0, temp, 0) - 0,
                                                                              gdd5 = if_else(temp > 5.5, temp, 5.5) - 5.5) %>%
                                                                    st_apply(1:2, sum) %>%
                                                                    merge()) %>%
  do.call(c, .)%>%
  merge(name = 'time') %>%
  st_set_dimensions('time', values = 1979:2018) %>%
  split('attributes')

# The code chunk requires an external download, so the results are saved and loaded by default instead
gc()
saveRDS(cmfd, 'cmfd.rds')