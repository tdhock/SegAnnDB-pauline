server.list <- list(
  "ec2-52-16-111-3.eu-west-1.compute.amazonaws.com"=c(
    'None',
    'tdhock5@gmail.com',
    'toby.hocking@mail.mcgill.ca',
    'valentina.boeva@curie.fr',
    'valeyo@ya.ru',
    'x.abhishek.flyhigh@gmail.com'),
  "ec2-54-229-56-221.eu-west-1.compute.amazonaws.com"=c(
    'None',
    'pauline.depuydt@ugent.be',
    'tdhock5@gmail.com',
    'valentina.boeva@curie.fr',
    'valeyo@ya.ru'))

for(server.ip in names(server.list)){
  u.prefix <- paste0("http://", server.ip)
  u.csv <- paste0(u.prefix, "/csv_profiles/")
  profiles <- read.csv(url(u.csv))
  for(row.i in 1:nrow(profiles)){
    one <- profiles[row.i, ]
    u.profile <- paste0(u.prefix, "/secret/", one$name, "/", one$name, ".bedGraph.gz")
    data.dir <- file.path("data", server.ip, one$name)
    dir.create(data.dir, showWarnings=FALSE, recursive=TRUE)
    profile.path <- file.path(data.dir, "probes.bedGraph.gz")
    if(!file.exists(profile.path)){
      cat(sprintf(
        "%4d / %4d %s -> %s\n",
        row.i, nrow(profiles),
        u.profile, profile.path))
      download.file(u.profile, profile.path)
    }
    for(user in server.list[[server.ip]]){
      for(data.type in "regions"){
        file.csv <- file.path(data.dir, data.type, paste0(user, ".csv"))
        if(!file.exists(file.csv)){
          u <- sprintf(
            "%s/export/%s/%s/%s/csv/",
            u.prefix, user, one$name, data.type)
          cat(sprintf(
            "%4d / %4d %s -> %s\n",
            row.i, nrow(profiles),
            u, file.csv))
          dir.create(dirname(file.csv), showWarnings=FALSE)
          download.file(u, file.csv)
        }
      }
    }
  }
}
