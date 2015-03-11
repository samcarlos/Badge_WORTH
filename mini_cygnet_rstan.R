library(rstan)

badge_worth="
data{
real cygnet;
real iq;
real mini;
real miniR;
}

parameters{
real pcygnet;
real piq;
real pmini;
real pminiR;

real<lower=0,upper=1> beta_ratio;
}
transformed parameters{
real interior_premium;
interior_premium <- pminiR-pmini;

}

model{
  pcygnet~normal(cygnet,500);
  piq~normal(iq,1500);
  pmini~normal(mini,1000);
  pminiR~normal(miniR,1500);

  beta_ratio~normal(.6,.1);
  }
generated quantities{
real badge_premium;

badge_premium<-pcygnet-piq-beta_ratio*interior_premium;

}

"

car.price.list=list(cygnet=23950,iq=7990, mini=17000, miniR=28990)

stan.out=stan(model_name="badge_worth", model_code=badge_worth,data=car.price.list, iter=5000, chains=1, verbose=TRUE)

stan.mat=as.matrix(stan.out)
h = hist(stan.mat[,7], breaks = 50, plot=FALSE)
h$counts=h$counts/sum(h$counts)
plot(h, ylab="Empirical Probability", xlab="Estimated Badge in English Pounds", main="Histogram of Aston Martin Badge Worth on Toyota IQ")


hist(stan.mat[,7])
