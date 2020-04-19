# Sun Apr 19 11:22:59 2020 ------------------------------

# Weibull distribution

par(mfrow=c(2,2))
sh = c(0.5, 1, 1.5, 2)
for (a in 1:4) {
  a <- rweibull(500, shape=sh[a], scale=5)
  hist(a)

}

par(mfrow=c(2,2))
sc = c(3, 4, 5, 6)
for (a in 1:4) {
  a <- rweibull(500, shape=1.5, scale=sc[a])
  hist(a)

}
