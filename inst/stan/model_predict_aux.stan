functions{
	

	real gd(real p){
		return(binomial_lpmf(1|1,p));
	}

	real h0d(int y, int J, real alpha, real beta){
		return(beta_binomial_lpmf(y|J,alpha,beta));
	}

	real h1d(int y, int J, real alpha, real beta){
		return(beta_binomial_lpmf(y|J,alpha,beta));
	}

	// normal link for continuous dv
	real fd_l(int y, real p){
		return(binomial_lpmf(y|1,p));
	}

  int group_size(array[] int ref, int value) {
    int count;
    count = 0;
    for (ii in 1:size(ref))
      if (ref[ii]==value)
        count = count + 1;
      return count;
   }

  matrix subset_matrix(matrix y, int k, array[] int ref, int value) {
    int jj;
    matrix[group_size(ref, value),k] res;
    jj = 1;
    for(ii in 1:size(ref)) {
      if (ref[ii] == value) {
      	for (kk in 1:k){
      		res[jj,kk] = y[ii,kk];	
      	}
        jj = jj+1;
      }
    }
    return res;
  }


}

data {
	int N;
	int J; //number of non sensitive item
	array[N] int<lower = 0> Y; // number of affirmative answers
	int K;
	matrix[N,K] X;
	array[N] int treat;
	array[N] int outcome;
	int G; // number of subgroups
	array[G] real h; // auxiliary information for subgroups
	array[N] int g; // subgroup indicators
}

transformed data{

}

parameters {
	vector[K] psi0; // coefficients of controls without treatment
	vector[K] psi2; // coefficients of controls on outcome
	vector[K] delta; // coefficients of controls on Z
	real gamma0; // coefficient of the sensitive item on outcome
	real phi; // coefficients of latent number of affirmative answers to controls on outcome
	real<lower = 0, upper = 1> rho0; //variance parameter without treatment
	real<lower = 0> sigma; //sd for the moment conditions of the auxiliary information
}



model{

	sigma ~ cauchy(0,2.5);
	delta ~ normal(0,10); // priors subject to modification
	psi0  ~ normal(0,10); // priors subject to modification
	psi2  ~ normal(0,10); // priors subject to modification
	gamma0 ~ normal(0,10);

	for (gg in 1:G){
		logit(h[gg]) ~ normal(mean(subset_matrix(X,K,g,gg) * delta), sigma); 
	}

	for (i in 1:N){
		if (treat[i] == 1 && Y[i] == 0) {
			target += fd_l(outcome[i], inv_logit(X[i,] * psi2 + Y[i] * phi + 0 * gamma0)) +  log(1 - exp(gd(inv_logit(X[i,] * delta)))) + h0d(0,J,inv_logit(X[i,]*psi0)*(1 - rho0)/rho0, (1 - inv_logit(X[i,]*psi0))*(1 - rho0)/rho0);
		} else if (treat[i] == 1 && Y[i] == J + 1){
			target += fd_l(outcome[i], inv_logit(X[i,] * psi2 + (Y[i] - 1) * phi + 1 * gamma0)) + gd(inv_logit(X[i,] * delta)) + h1d(J,J,inv_logit(X[i,]*psi0)*(1 - rho0)/rho0, (1 - inv_logit(X[i,]*psi0))*(1 - rho0)/rho0);
		} else if (treat[i] == 1){
			target += log(exp(fd_l(outcome[i], inv_logit(X[i,] * psi2 + (Y[i] - 1) * phi + 1 * gamma0))) * exp(gd(inv_logit(X[i,] * delta))) * exp(h1d(Y[i] - 1,J,inv_logit(X[i,]*psi0)*(1 - rho0)/rho0, (1 - inv_logit(X[i,]*psi0))*(1 - rho0)/rho0)) + exp(fd_l(outcome[i], inv_logit(X[i,] * psi2 + Y[i] * phi + 0 * gamma0)))  * (1 - exp(gd(inv_logit(X[i,] * delta)))) * exp(h0d(Y[i],J,inv_logit(X[i,]*psi0)*(1 - rho0)/rho0, (1 - inv_logit(X[i,]*psi0))*(1 - rho0)/rho0)));
		} else {
			target += log(exp(fd_l(outcome[i], inv_logit(X[i,] * psi2 + Y[i] * phi + 1 * gamma0))) * exp(gd(inv_logit(X[i,] * delta))) * exp(h1d(Y[i],J,inv_logit(X[i,]*psi0)*(1 - rho0)/rho0, (1 - inv_logit(X[i,]*psi0))*(1 - rho0)/rho0)) + exp(fd_l(outcome[i], inv_logit(X[i,] * psi2 + Y[i] * phi + 0 * gamma0))) * (1 - exp(gd(inv_logit(X[i,] * delta)))) * exp(h0d(Y[i],J,inv_logit(X[i,]*psi0)*(1 - rho0)/rho0, (1 - inv_logit(X[i,]*psi0))*(1 - rho0)/rho0)));
		}
	}




}