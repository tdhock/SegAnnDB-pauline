library(data.table)
server.vec <- c(
  "ec2-54-229-56-221.eu-west-1.compute.amazonaws.com",
  "ec2-52-16-111-3.eu-west-1.compute.amazonaws.com")
for(server in server.vec){
  data.dir <- file.path("data", server)
  dir.create(data.dir, showWarnings=FALSE, recursive=TRUE)
  profiles.csv <- file.path(data.dir, "profiles.csv")
  if(!file.exists(profiles.csv)){
    u <- sprintf("http://%s/csv_profiles/", server)
    download.file(u, profiles.csv)
  }
  profiles.dt <- fread(profiles.csv)
  for(profile.i in 1:nrow(profiles.dt)){
    pro <- profiles.dt[profile.i]
    cat(sprintf("%4d / %4d %s\n", profile.i, nrow(profiles.dt), pro$name))
  }
}
