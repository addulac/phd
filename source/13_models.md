
# Latent Variable Models
\label{sec:network_model}

Machine Learning can be though of as inferring plausible models to explain observed data. A major difficulty of this task is that the data can be consistent with many models and choosing an appropriate models is uncertain. Therefore, being able to model the uncertainty play a key role in order to build flexible yet powerful model [@ghahramani15_nature]. 
For networks analysis, one can think about a clustering task such as the *community detection* for instance; Does the clusters to detect should satisfy the *regular equivalence* or the *structural equivalence*? Does the node memberships to clusters should be soft or strict? How many clusters should be detected? The Answers to those questions can either be known or uncertain and therefore, one should be able to incorporate various kind of prior knowledges and with different level of confidence.
In this direction, a well grounded framework to control the uncertainty is the probability theory and in particular the Bayesian inference, which is the actual learning procedure behind probabilistic models.

In this chapter, we introduce the probabilistic framework upon which are based the models studied in this thesis.
In particular, we expose the key distributions and processes harnessed within the models considered throughout the manuscript, before reviewing the class of latent models used for network analysis and some fundamental result justifying their constructions.


## Bayesian inference
\label{sec:network_inference}

Bayesian modeling is a probabilistic framework used to formalize causal theory. Given a set of observable data $X$, let $\Pi$ be a set of random variables $\Pi$ and $\Omega$ set of hyper-parameters, a Bayesian model defines the conditional relations between those variables whom describe how the data are generated. In a nutshell, the generative process consists firstly to generate random parameters from the *prior distribution* $\Pi \sim P(\Pi | \Omega)$, then the data are generated from the *data likelihood distribution* given the parameter $X \sim P(X|\Pi)$. The model can be represented as a Directed Acyclic Graph (DAG), called Bayesian Network or just Graphical model, where the conditional relations between the different variables are illustrated in Fig. \ref{fig:bayes_net}. The graphical model is a means of expressing the causal relations underlying a model in a visual and synthetic way.

\begin{figure}[h]
    \centering
    \input{source/figures/draw/bnet.tex}
    \caption{A simple Bayesian network. The circled nodes represents random variables, and the non-circled one represent constant generally called hyper-parameter. The grey circles represent the observed data and the white circles are for the model parameters. The directed edges represent causal relations between the variables.}
    \label{fig:bayes_net}
\end{figure}

Bayesian inference is an inversion procedure that consists of estimating the model parameters $\Pi$ given the observable data. This inversion is realized through the Bayes' law who expresses the distribution of the model parameters given the observable data, called the *posterior distribution*, as
$$
P(\Pi | X, \Omega) = \frac{P(X|\Pi)P(\Pi| \Omega)}{P(X|\Omega)}
$$
where $P(X | \Omega)=\sum_{\Pi} P(X, \Pi|\Omega)$ is referred to as the *marginal likelihood* or model *evidence*. For simple model, inference methods for the posterior are generally based on the Maximum Likelihood Estimation (MLE) or the Maximum a Posteriori (MAP). These methods are called *point estimation* as they give single value that tries to maximize the posterior distribution. However, for more complex model, the posterior cannot be computed directly, due to non-closed form expression of the evidence, and one must resort to approximate inference methods. Two main concurrent approaches have been developed to approximate the posterior distribution. The first rely on sampling techniques grounded by Markov Chain Monte Carlo (MCMC) theory [@neal1993probabilistic][@geyer2011introduction]; MCMC based methods are stochastic procedures where successive sampling step are performed to approximate the true posterior distribution. The second rely on Variational Inference (VI) methods; In this inference scheme, one tries to minimize the divergence between the true posterior and a given proxy distribution. A major advantage of this approach is that it allows to develop deterministic inference procedure and thus, open the door to the framework of gradient descent based algorithms. Nevertheless, the price to pay is that the proxy distribution incorporate a bias often hard to evaluate [@blei2017variational]. As a final note on approximate inference, it is worth to mention the Expectation-Maximization (EM) algorithm which can be viewed as special case of VI but is used to estimate model parameters that lack of prior distribution.

The estimation of the posterior distribution is achieved through a fitting procedure that, for approximate inference, consists of iterative updates of an objective towards a maximizer.
The (approximate) posterior can then be used to "answer questions" through the prediction of future outcomes as
$$
P(x_{new} | X, \Omega) = \int  P(x_{new} | \Pi, X) P(\Pi|X) d\Pi
$$
And $P(x_{new} | X, \Omega)$ is refer to as the predictive distribution of the outcome $x_{new}$.

## Exponential family
\label{sec:expofamily}

The Exponential family represents a class of parametric distribution that subsumes many common distributions. It includes the Normal, Poisson, Bernoulli, Multinomial, Beta, Dirichlet, Gamma, Exponential, Pareto etc. Briefly, a distribution in the exponential family can be expressed in its canonical form by:
$$
P(X|\eta) = \exp(\eta^T S(X) -A(\eta) - H(X))
$$
where $S(X)$ is a measurable map, $A$, called the log-partition function, and $H$ are two known measurable real-valued functions.

Distributions in the Exponential family have convenient properties that make them theoretically appealing and hence, constitute a core topic in the Bayesian framework [@orbanz2009functional]. For instance, they convey the key notion of *sufficient statistic* regarding the measure of the information of data samples. There are also at the basis of the *generalized linear model* whose allow generalization of simple model to work in different context. Another very useful property of the exponential family, that we shall highlight in this section, is the existence of *conjugate priors*.
More Precisely, let $P(X|\eta)$ be a model with parameter space $\Omega_\eta$, and let $\mathcal{H}$ be a set of prior distribution on $\Omega_\eta$. Then the model $P(X|\eta)$ and the set $\mathcal{H}$ are said to be conjugate if for every prior $P_\eta \in \mathcal{H}$ and observation set $X=x$, the corresponding posterior $P(\eta|X)$ is an element of $\mathcal{H}$.

Conjugate prior, as well as the notion of sufficient statistics, are inextricably linked to the exponential family [@halmos1949application]. Notably, it has been showed that an exponential family representation always implies the existence of a sufficient statistic and a conjugate prior. Furthermore, under mild regularity conditions, the converse is also true.

A conjugate prior of $P(X|\eta)$ has the following representation
$$
P(\eta|\tau, \eta_0) = \exp(\tau^T\eta - \eta_0A(\eta) - H(\tau, \eta_0))
$$ {#eq:conjugate_prior}

The practical advantage of using conjugate prior is that it leads to closed from update for inference applications. This is in particular, often the case for predictive distribution in conjugate model which is of great interest to develop efficient inference scheme. Note, that the use of conjugate prior is further justified by its mathematical convenience than for its epistemological meaning [@blei2003latent].
To conclude on exponential family, we recall a theorem proved in [@diaconis1979conjugate], that characterise the predictive distribution in a conjugate model, and that highlight its linear form that the reader will be able to rediscover at different parts of this manuscript.
\begin{theorem}[Diaconis-Ylvisaker characterization of conjugate priors]
Let $P_X(.|\Theta)$ be a natural exponential family model dominated by Lebesgue measure, with open parameter space $\Omega_\theta \subset \Re^d$. Let $P_\Theta$ be a prior on $\Theta$ which does not concentrate on a singleton. Then $P_\Theta$ has a density of the form (\ref{eq:conjugate_prior}) w.r.t Lebesgue measure on $\Re^d$ if and only if [81]
$$
\Er_{P_\Theta(\Theta|X_1=x_1,\dotsc,\X_n=x_n)}[\Er_{P_X(X|\Theta=\theta)}[X]] = \frac{a+n\hat x}{b+n} \ .
$$
\end{theorem}
That is, given observation $x_1,\dotsc,x_n$ the expected value of new draw $x$ under unknown value of the parameter is linear in the sample average $\hat x=\frac{1}{n}\sum x_i$.


## Nonparametric processes
\label{sec:non_parametric}

When modeling natural phenomena, we mentioned the importance of having flexible model able to adapt to the complexity of the data. 
Flexibility can be obtain trough Bayesian nonparametric that refers to Bayesian models that use nonparametric processes as prior knowledge. The class of nonparametric process can be though as the generalization of parametrized distributions^[Such as distributions in the exponential family.] to an infinite dimensional parameter space. Hence, the dimension of the model become itself a random parameter that can be learnt from the data.

Nonparametric processes include major models that is worth to mention. The Gaussian Process, that generalize the multivariate Normal distributions [@rasmussen2004gaussian], is particularly adapted for modeling continuous data such as time series and image processing [@lawrence2007hierarchical]. The Poisson process  can be defined as a counting process on a measurable space, where each region is associate to a finite-dimensional Poisson distribution. It is ubiquitous in queuing theory [@nelson2013probability], and has been used in a wide range of application, from earthquake occurrence modeling [@ogata1988statistical], to the photon emission analysis [@jager2009analysis]. In this work, we are particularly interested in the two others following nonparametric processes:

* The *Dirichlet Process* is the generalization of the Dirichlet distribution in the infinite case. It is adapted for categorical data and often used as a prior for infinite mixture models and clustering applications.
* The *Indian Buffet Process* is a prior over categorical matrix with infinite columns. It has been used for sparse matrix factorisation, overlapping community detection and model selection.

In the rest of this section, we introduced the Dirichlet Process, its extension the Hierarchical Dirichlet Process and the Indian Buffet Process.


### Dirichlet Process

A Dirichlet process (DP) is a random probability measure $G$ over a measurable space $(\X, P(\X))$, with base measure $H$, and concentration prameter $\alpha_0 \in \mathbb{R}_+^*$, if for any partition $(A_1,\dotsc, A_k$) of $\X$
$$
(G(A_1),\dotsc, G(A_k)) \sim \Dir(\alpha_0 H(A_1),\dotsc, \alpha_0 H(A_k))
$$
and we write $G \sim \DP(\alpha_0, H)$ and where $\Dir$ is the Dirichlet distribution, with parameters $(\alpha_1,\dotsc,\alpha_k)$, which is defined by a degenerate density on simplex $\Delta_k = \{p_1,\dotsc, p_k\}\in \Re_+^k$ such that $P(p_1,\dotsc, p_k) \propto p_1^{\alpha_1-1}\dotsm p_k^{\alpha_k-1}$ and $\sum_i p_i=1$.

The existence of the DP was established by Ferguson [@ferguson_dp] and has the following properties [@yyt_dp]:

* The expectation of a DP for any sets $A, B \subset \X$ is: $$\Er[G(A)] = H(A),$$
sometimes simply noted $\Er G=H$. This result is analogous to the expectation of a Dirichlet distribution where $\Er[p_i] = \alpha_i / \alpha_{\pt}$. Further, the variance of $G$ is $\Vr[G(A)]= \frac{H(A)(1-H(A))}{1+\alpha_0}$ and its covariance is $\text{Cov}(G(A), G(B)) = \frac{H(A\cap B) - H(A)H(B)}{1+\alpha_0}$.
* The marginal distribution of G(A) is Beta such that $G(A) \sim \Beta(\alpha_0 H(A), \alpha_0 (1-H(A)))$. One can again recognize the analogy with the Dirichlet distribution.
* The posterior distribution of i.i.d. draws $(X_1,\dotsc,X_n)$ from a DP $G$ is:
\begin{equation} \label{eq:cond_dp}
\pr(G \mid X_1,\dotsc, X_n) = \DP\left(\alpha_0 +n, \frac{1}{\alpha_0 + n}\left( \alpha_0 H + \sum_{i=1}^n \delta_{X_i} \right)\right)
\end{equation}
where $\delta_{X_i}$ represents the point mass located at $X_i$^[$\delta$ is the Dirac operator.]. This result directly follows from the  conjugacy between Dirichlet and Multinomial distributions.
* The predictive distribution of a new draw $X_{n+1}$ for a measurable set $A \subset \X$ is:
\begin{align*}
\pr(X_{n+1} \in A \mid G, X_1,\dotsc, X_n) &= \Er[G(A) \mid X_1,\dotsc,X_n] \\
&= \frac{1}{\alpha_0 + n}\left( \alpha_0 H(A) + \sum_{i=1}^n \delta_{X_i}(A)\right)
\end{align*}
Finally by marginalizing out $G$, we obtain:
\begin{equation} \label{eq:bm}
X_{n+1} \mid X_1,\dotsc, X_n \sim \left(\frac{\alpha_0}{\alpha_0 + n}H + \frac{n}{\alpha_0+n}\frac{\sum_{i=1}^n \delta_{X_i}}{n}\right)
\end{equation}

Figure \ref{fig:dp} represents the graphical model of the DP for the simple sampling scheme described.

The predictive distribution for $X_{n+1}$ is therefore equal to the base measure of the posterior distribution of $G$. This sequence of predictive distributions refers to the Blackwell-MacQueen urn scheme which has been used to show the existence of the DP [@blackwell1973ferguson]. Furthermore it emphasizes several important properties of the DP:

\begin{figure}[h]
	\centering
	\scalebox{1}{
		\input{source/figures/draw/dp}}
	\caption{Graphical model of a sequence generated through the Dirichlet Process.}
	\label{fig:dp}
\end{figure}

\noindent
**Exchangeability**

Using the predictive distributions, Eq. \eqref{eq:bm}, one can construct the distribution over the sequence $X_1,X_2,\dotsc$ by iteratively drawing each $X_i$ given $X_1,\dotsc,X_{i-1}$ such that
$$
P(X_1,\dotsc,X_n) = \prod_{i=1}^n P(X_i|X_1,\dotsc,X_{i-1}).
$$
It is straightforward to show that this joint distribution is infinitely exchangeable, meaning that the probability of the sequence $X_1,\dotsc,X_n$ is the same for any other order of that sequence. Or said differently, the probability of that sequence doe not depend on the order in which we draw samples. Formally, given any permutation $\sigma$ over natural number, one has
$$
P(X_1,\dotsc,X_n) = P(X_{\sigma(1)},\dotsc,X_{\sigma(n)}).
$$
On the other hand, de Finetti's theorem states that for any infinitely exchangeable sequence $X_1,X_2,\dots$ there is a random measure G such that the sequence is composed of  i.i.d draws from it^[Or say differently, that draws are conditionally independant given $G$.]:
$$
P(X_1,\dotsc,X_n) = \int \prod_{i=1}^n G(X_i) dP(G).
$$

In the Blackwell-MacQueen urn scheme, the prior over the random measure $P(G)$ is precisely the Dirichlet Process $DP(\alpha_0, H)$, and therefore justify its existence.


\noindent
**Discrete Distribution and clustering property**

A characteristic of the predictive distribution of the DP is that its draws belongs to some points mass (or atoms) and that there is a positive probability that new draws will take the value of a preceding atom. Therefore, the sequence $(X_1,\dots,X_n)$ will take values in a set $(X_1^*,\dots,X_T^*)$ with $T\leq n$. Hence, the posterior distribution is a weigted average sum of new draw from the base measure $H$ and the empirical distribution. Let $(n_1,\dotsc, n_T)$ be the counts associated to uniques atom values, one can rewrite the empirical distribution of draws as
$$\sum_{i=1}^n \frac{\delta_{X_i}}{n}=\sum_{k=1}^T n_k \frac{\delta_{X_k^*}}{n}.$$ 
From Eq. \ref{eq:bm}, it appears a rich-get-richer phenomenon over the atoms, as the probability to draws an element equal to a given atom value $X_k^*$ increase (is proportional) with the number of atoms having this value $n_k$. This clustering effect of the DP leads to Chinese Restaurant Process metaphor while the discrete aspect of the DP leads to another construction of it called the Stick Breaking Process. Note that this discrete aspect of the DP is true whether the base measure is discrete or continuous.

It is worth to mention that the DP has other interesting properties such as being self-similar (fractal property) and tail-free. We refer the interested reader to [@ferguson1992bayesian] for further details. 

### Chinese Restaurant Process

The discreteness and clustering properties of DP, as mentioned previously, makes repeated draws $(X_1,\dotsc, X_n)$ a particular partition taking values into $(X_1^*,\dotsc, X_T^*)$. 
The predictive distribution can then be rewritten as:
\begin{equation} \label{eq:crp}
X_{n+1} \mid X_1,\dotsc, X_n \sim \frac{1}{\alpha_0 + n}\left( \alpha_0 H + \sum_{k=1}^T n_k \delta_{X_k^*}\right)
\end{equation} 
With $n_k$ the number of atoms for cluster k such that $n_k = \sum_{i=1}^n \delta_{X_i}(A_k)$.

The Chinese Restaurant Process (CRP) is the process associated to the predictive distribution of the DP where $G$ has been marginalized out (Eq. \eqref{eq:crp}). It illustrate the infinite mixture model induced by the DP. It is defined as follows: 

* Assume a Chinese Restaurant with an infinite number of table, each table can welcome an unlimited number of customers and table $k$ serves dish $X_k^*.$
* First customer sit at first table.
* Suppose there are $T$ tables occupied when the $i$-th customer comes. He can either:
  * sit a table $1\leq k \leq T$ with probability $\frac{n_k}{\alpha_0+i-1}$,
  and set $X_i=X_k^*$.
  * sit at a new table with probability $\frac{\alpha_0}{\alpha_0+i-1}$, 
  and increase $T$ to $T+1$, draw $X_T^* \sim H$ and set $X_i= X_T^*$.

Figure \ref{fig:crp} gives an illustration of the CRP.

\begin{figure}[h]
	\centering
	\scalebox{1}{
		\input{source/figures/draw/crp}}
	\caption{Illustrution of a Chinese Restaurant Process. Each customer (X) can seat at a table $k$ or start on new one according to a rich-get-richer phenomenon.}
	\label{fig:crp}
\end{figure}

In addition, the CRP gives hint about the distribution of the number of clusters (=tables) depending on the number of data $n$ (=customers); Let $m$ be the number of tables generated by the DP. From the CRP, one know that the probability of generating a new table for each draw is $\frac{\alpha_0}{\alpha_0+i-1}$, and so is independent of the previous number of tables. Thus, the mean and variance of the number of tables for $n$ draws are
\begin{align*}
    \quad\Er[m | n] &= \sum_{i=1}^n \frac{\alpha_0}{\alpha_0 + i -1} = \alpha_0 (\psi(\alpha_0 + n) - \psi(\alpha_0)) \\
    \quad       &\approx \alpha_0\log(1+\frac{n}{\alpha_0}) \quad\qquad \text{ for } N,\alpha_0 \gg 0\\
    \\
    \quad\Vr[m | n] &= \sum_{i=1}^n \frac{\alpha_0}{\alpha_0 + i -1} = \alpha_0 (\psi(\alpha_0 + n) - \psi(\alpha_0)) + \alpha_0^2 (\psi'(\alpha_0+n) - \psi'(\alpha_0) )  \\
    \quad       &\approx \alpha_0\log(1+\frac{n}{\alpha_0}) \quad\qquad \text{ for } N>\alpha_0 \gg 0
\end{align*}
where $\psi$ is the Digamma function.

A final note about the CRP, is that this process is useful to construct Gibbs Sampler of models that use DP prior, in particular, the CRP equations relate to the Collapse Gibbs Sampling updates for DPs based model as the base measure is marginalized out [@antoniak1974mixtures].

### Stick Breaking Process

The Stick-Breaking Construction go beyond the previous definition of predictive distribution of the DP. It provides a more general generative process to make explicit the random measure $G$. As mentioned, the DP is a discrete distribution made of weighted sum of point mass such that
$$
  G = \sum_{k=1}^{\infty} \pi_k \delta_{X_k^*} \ .
$$
The stick proportion $\pi_k$ for each cluster is then build in a way which can be seen as if one recursively broke a proportion of a stick, according to the following process:
\begin{align*}
 \beta_k &\sim \mathrm{Beta}(1, \alpha_0) \qquad\qquad X_k^* \sim H  \\
 \pi_k &= \beta_k \prod_{l=1}^{k-1}(1-\beta_l)
\end{align*}
Then $G \sim \DP(\alpha_0, H)$ and we write the Stick-Breaking construction of proportions as $\mat{\pi} \sim \mathrm{GEM}(\alpha_0)$. This name stand for Griffiths, Engen and McCloskey who discovered it. The Stick-Breaking process has been used to develop and improve inference techniques via variational inference and MCMC sampling methods.


<!--
To conclude on the DP, here some assertion found in the literature:
\begin{itemize}
{\footnotesize
\item "[The Dirichlet process] is a distribution over distributions, i.e. each draw from a Dirichlet process is itself a distribution." (Teh, 2010)
\item "The Dirichlet process defines a distribution on random probability measures..." (Sudderth, 2006)
\item "Dirichlet processes (DP) define a distribution over distributions..." (Neal 2000, Ghahramani 2005, Gershman and Blei 2012)
}
\end{itemize}
-->

### Hierarchical Dirichlet Process

The Hierarchical Dirichlet Process (HDP) is a two-stage DP process [@HDP]. It allows to share the same mixture components^[The term component is used in a general case here but depending on the context, the component may be called differently. For instance the term of latent topic is common for text analysis and block, class or communities for network modeling.] across the data which is not possible with a unique DP (i.e. all tables have a different dishes in the CRP metaphor.). By overcoming this limitation, the HDP constitute a flexible prior to build hierarchical model able to capture complex semantic patterns in the data. In his canonical form, the HDP assumes that the observed data are compose of $J$ instances, and each instance is composed of $N$ data point occurrence. For example, in text analysis,  the instances typically represent documents and the data point occurrence the words. In network analysis instances would be the nodes and data occurrence the edges.]. 
The generative process of the HDP is as follows:
\begin{align*}
 G_0 \mid \alpha_0, H &\sim \DP(\gamma, H) \\
 G_j \mid \gamma, G_0 &\sim \DP(\alpha_0, G_0) \\
 \theta_{ji} \mid G_j &\sim G_j \\
 y_{ji} \mid \theta_{ji} &\sim F(\theta_{ji})
\end{align*}
 

\begin{figure}[h]
	\centering
	\minipage{0.3\textwidth}
	a)
	\scalebox{0.9}{
		\input{source/figures/draw/hdp}}
	\endminipage
	\minipage{0.3\textwidth}
	b)
	\scalebox{0.9}{
		\input{source/figures/draw/hdp1}}
	\endminipage
	\minipage{0.3\textwidth}
	c)
	\scalebox{0.9}{
		\input{source/figures/draw/hdp2}}
	\endminipage
	\caption{Graphical models for the HDP: a) The most compact way of representing  the generative model. b) the first DP level is unwrap using the Stick-Breaking construction. c) both DPs level are unwrap.}
	\label{fig:hdp}
\end{figure}


In order to capture in a more constructive way the distributions of the variables involved in the process, the levels of DPs can be decomposed, or unwrap, by using their Stick-Breaking constructions. The first level of DP is rewritten as follows:
\begin{align*}
&\beta^0 \sim \gem(\gamma) \qquad  \phi_k \sim H \\
&\quad G_0 = \sum_{k=1}^{\infty} \beta_k^0 \delta_{\phi_k} 
\end{align*}
This first DP level represents the shared components $\phi_k$ across the observed data of the HDP with the proportion $\beta^0$. Then, one can expess the data instance's distribution of components using $\pi_j$ as a function of a DP parametrized by $\beta^0$. Thus the generative process at the instance level becomes:
\begin{align*}
\pi_j &\sim \DP(\alpha_0, \beta^0) \\
z_{ji} &\sim \Mult(\pi_j)  \\
y_{ji} &\sim F(\phi_{z_{ji}})
\end{align*}
The second level of DP corresponds to $\pi_j$. It defines the mixture of the shared component at the instance level of the data. The latent variables can again be expressed using the Stick-Breaking construction of the DP:
\begin{align*}
&k_{jt} \sim \Mult(\beta^0) \qquad \beta_j^1 \sim \gem(\alpha_0) \\
&t_{ji} \sim \Mult(\beta_j^1)  \qquad \quad z_ {ji} = k_{j_{t_{ji}}} 
\end{align*}

The graphical models for the three representations of HDP are shown in figure \ref{fig:hdp}. As for the DP, one can obtain closed form expression for the predictive distribution of the HDP by marginalizing out the base measures. We discuss this approach in the next section.
	
#### Chinese Restaurant Franchise
\label{sec:CRF}

The Chinese Restaurant Franchise (CRF) is a metaphor to describe the process behind draws from the HDP and the form of the associated predictive distributions which generalize the CRP. The HDP is composed of two level of DPs. The draws from the first level are associated to dishes shared across a restaurants franchise. At the second level, each restaurant is composed by a possibly infinite number of tables with infinite capacity, and each table is assigned to one dish. Finally customers who sit at a table, share the same dish. 
The CRF aims at writing the predictive distribution that a customer sit at a particular table, and that a particular table will serve a specific dish. The indexes $k, t, i$ index respectively the dishes, the tables and the customers of the restaurant. What we called the instance level in the previous section, corresponds to the restaurants of the franchise, and are indexed by $j$. Table \ref{tab:crf} presents the different variables involved in the CRF.

\begin{table}[h]
\resizebox{\textwidth}{!}{
\begin{tabular}{p{5em}||p{20em}|p{20em}}
\hline
\hline
\textbf{Random} \textbf{Variables} & \ \textbf{Description} & \ \textbf{CRF metaphor} \\ 
\hline
\hline
$\theta_{ji}$ & Draws from $G_j$ & Customer $i$ in restaurant $j$. \\
\hline
$\psi_{jt}$ & Draws from $G_0$, which represent a component for values in $\theta_j$. & Table $t$ in restaurant $j$. \\
\hline
$\phi_k$ & Draw from base measure $H$. Represent the distinct values for $\psi_{jt}$. & Dish $k$, shared in all restaurants. \\
\hline
$t_{ji}$ & Index of $\psi_{jt}$ associated to $theta_{ji}$. & The table taken by customer i in restaurant j. \\
\hline
$k_{jt}$ & Index of $\phi_k$ associated to $\psi_{jt}$. & Dish ordered by table $t$ in restaurant $j$. \\
\hline
$m_{jk}$ & The number of times $\psi_{jt}$ takes value in $\phi_k$. & Number of tables that ordered dish $k$ in restaurant $j$. \\
\hline
$n_{jtk}$ & The number of times $\theta_{ji}$ takes values in $\phi_k$ for $\psi_j$ index at $t$. & Number of customer in restaurant $j$, at table $t$, eating dish $k$. \\
\hline
\end{tabular}
}
\caption{Random variables involved in the Chinese Restaurant Franchise.}
\label{tab:crf}
\end{table}

Let's denote the marginal count of indexes by a dot. For example the total number of tables is denoted by $m_{\bm{..}}$ and the total number of customers sitting at a table $t$ in restaurant $j$ by $n_{jt\bm{.}}$. In this setting, we can write the predictive distributions for $\theta_{ji}$ and $\psi{_{jt}}$, where respectively $G_j$ and $G_0$ are integrated out, following Eq. \eqref{eq:crp}, as:
$$
	\theta_{ji} \mid \theta_{j1},\dotsc,\theta_{j,i-1}, \alpha_0, G_0 \sim \frac{1}{i-1+\alpha_0} \left(\alpha_0 G_0 + \sum_{t=1}^{m_{j\bm{.}}} n_{jt\bm{.}}\delta_{\psi_{jt}} \right) 
$$

$$
    \psi_{jt} \mid \mathbf{\psi}_{-jt}, \gamma, H \sim \frac{1}{m_{\bm{..}}+\gamma} \left(\gamma H + \sum_{k=1}^K m_{\bm{.}k}\delta_{\phi_{k}} \right) 
$$


The predictive distribution of $\theta_{ji}$ and $\psi_{jt}$ have thus a closed form expression are constitute the starting point to develop inference scheme for a practical usage of the HDP.

#### Inference

Several inference methods have been proposed for the HDP in the literature that mostly, either rely on Markov Chain Monte Carlo method (MCMC) or Variational Inference. In their seminal paper [@HDP], the authors propose different sampling scheme. In this section we give the main results needed to derived the Gibbs updates for the model parameters.

\noindent
**Sampling by Direct Assignment**
\label{sec:DSA}

In this sampling scheme, based on the CRF, and who is akin to a Collapse Gibbs Sampling (CGS), we aims to sample iteratively, for the observation $(ij)$, the component assignement $z_{ij}$ (the dish chosen by the customer) given all the others data assignments.
Furthermore, one also need to concurrently sample potential new component, which is achieved through the sampling of the number of table $m_{jk}$ and auxiliary variable $\mat{\beta}$. The latter is used to make an explicit construction of the $G_0$. More precisely, as each $\psi_{jt}$ is a draw from $G_0$, by conditioning it by the $\psi_{jt}$ and expoitating Eq. \eqref{eq:cond_dp} one has
$$
	G_0 \mid \bm{\psi}, H, \gamma \sim \DP\left(\gamma+m_{\bm{..}}, \frac{\gamma H + \sum_{k=1}^K m_{\bm{.}k}\delta_{\psi_k}} {\gamma + m_{\bm{..}}}\right)
$$
To accomplish the construction of $G_0$, one can resort to an augmented representation in order th have an explicit construction of it [@HDP], written as
\begin{align*}
& \mat{\beta} = (\beta_1,\dotsc,\beta_K, \beta_u) \sim Dir(m_{\bm{.}1},\dotsc, m_{\bm{.}K}, \gamma) \qquad G_u \sim \DP(\gamma, H) \\
& \qquad\qquad\qquad\qquad  G_0 = \sum_{k=1}^K \beta_k \delta_{\phi_k} + \beta_u G_u
\end{align*}
Under this representation, by omitting the reference to $\alpha_0$ and $\gamma$, one can write the conditional distribution for a component $k$:
\begin{equation*} \label{eq:k_hdp}
    \pr(z_{ji}=k \mid \bm{y}, \bm{z}^{-ji}, \bm{m}, \mat{\beta} ) \propto
\begin{cases} 
    (n_{j\bm{.}k}^{-ji} + \alpha_0\beta_k) f_k^{-y_{ji}}(y_{ji}) \quad \mathrm{if \ } k  \mathrm{previously\ used,} \\ 
\alpha_0 \beta_u f_{k^{\mathrm{new}}}^{-y_{ji}}(y_{ji}) \qquad\qquad\quad \mathrm{if \ } k = k^{\mathrm{new}.} 
\end{cases}
\end{equation*}
where $f_k^{-y_{ji}}$ denotes the conditional likelihood of $y_{ij}$ under the component $k$ given all data except $y_{ij}$ such that $f_k^{-y_{ji}} = p(y_{ij}|\mat{z}^{-ij},z_{ji}=k)$ and $f_{k^{\mathrm{new}}}^{-y_{ji}}(y_{ji})=\int f(x_{ij}|\phi)h(\phi)d\phi$ is simply the prior density of $y_{ij}$ and $f(.|\phi)$ and $h(.)$ are respectively the density of $F(\phi)$ and $H$.

The sampling of the table configuration $\bm{m}$ can be done using the unsigned Stirling of the first kind $s(n,m)$ [@antoniak1974mixtures]:
$$
    \pr(m_{jk}=m \mid \bm{z}, \bm{m}^{-jk}, \mat{\beta} ) = \frac{\Gamma(\alpha_0 \beta_k)}{\Gamma(\alpha_0 \beta_k + n_{j\bm{.}k})} s(n_{j\bm{.}k}, m) (\alpha_0 \beta_k)^m
$$


We notice that if $h(.)$ and $f(.)$ are usually chosen to be conjugate because it allows then to obtain a closed form for equation \eqref{eq:k_hdp}.
This given updates complete the sampling procedure of the CRP since $\theta_{ji}$ and $\psi_{jt}$ can be reconstructed from their index variables.


\noindent
**Optimization of concentration parameter**

In the CRF, $G_0$ and $G_j$ have been integrated out, thus the component assignment are only conditioned on the base measure $H$ and the concentration parameters $\gamma$ and $\alpha_0$. One way to optimize those concentration parameters, proposed by [@HDP], is to used auxiliary variable sampling method [@escobar1995bayesian]. In this scheme, auxiliary variables $u$ and $v$ are introduced, and we assume that priors for concentration parameters are a gamma distributed. 

Keeping the CRF notations, given the tables configuration $m_j.$ and the clients configuration $n_{j\bm{..}}$ in the CRF, we have for the parameter $\alpha_0$, governing the number of tables $m_{\bm{..}}$, the following posterior distribution:
\begin{gather*}
    \alpha_0 \sim \mathcal{G}(a_\alpha, b_\alpha) \\
    u_j \sim \mathrm{Bernoulli}(\frac{n_{j\bm{..}}}{n_{j\bm{..}} + \alpha_0}), \quad v_j \sim \mathrm{beta}(\alpha_0 + 1, n_{j\bm{..}}) \\
     \alpha_0 \mid u_j, v_j \sim \mathcal{G}(a_\alpha + m_{\bm{..}} - \sum_j u_j, b_\alpha - \sum_j \log v_j)
\end{gather*}
And similarly, we get for the parameter $\gamma$ governing the number of classes $K$:
\begin{gather*}
    \gamma \sim \mathcal{G}(a_\gamma, b_\gamma) \\
    u \sim \mathrm{Bernoulli}(\frac{m_{\bm{..}}}{m_{\bm{..}} + \gamma}), \quad v \sim \mathrm{beta}(\gamma + 1, m_{\bm{..}}) \\
    \gamma \mid u, v \sim \mathcal{G}(a_\gamma + K - 1 + u, b_\gamma - \log v)
\end{gather*}


### Indian Buffet Process

The Indian Buffet Process (IBP) is a stochastic process analogous to the CRP but, instead of being a prior over exchangeable partition, the IBP is a prior over sparse binary matrix [@griffiths2011indian]. Let $F$ be a binary matrix of size $N\times K$ drawn from an IBP with an hyper-parmeters $\alpha$. The probability distribution of $F$ can be derived from the following process; Imagine a Indian restaurant with an infinite number of dishes, and where $N$ customers enter one after another, an let the entry $f_{ik}=1$ if customer $i$ select dish $k$:

* The first customer start selecting dishes, and stop after having selected $\Poisson(\alpha)$ dishes,
* The $i$-th customer comes, and start selecting dishes with probability $\frac{m_k}{i}$, where $m_k$ is the number of times dish $k$ has been selected $m_k=\sum_{i=1}^N f_{ik}$. When all previously sampled dished have been tried, he select $\Poisson(\frac{\alpha}{i})$ new dishes.

Each rows $i$ of the matrix $F$ obtained can be interpreted as the (latent) "features" of $i$, and in our settings, the distributions overs rows should depend on $i$. Nevertheless, in the sampling process, this not the case as the new features (dishes) are not ordered arbitrary and the number of active feature increase with $i$. Therefore, an operation on the matrix $F$ is required to make to matrix independent of the ordering of the rows as well as the columns. This operation consist to find a equivalence class of all the matrix equivalent for a permutation of the columns, and it is called the *left-ordering-form* (lof) of the matrix, that we don't further here. Under this transformation, the probability of any matrix $F$ of the exchangeable IBP is given by
$$ 
P(F \mid \alpha) = \frac{\alpha^{K_+}}{\prod_{h=1}^{2^N-1} K_h^!} \exp(-\alpha H_N) \prod_{k=1}^{K_+} \frac{(N - m_k)!(m_k - 1)!}{N!-1)}
$$ {#eq:ibp_density}
where $H_N$ is $N$-th harmonic number $H_N=\sum_{j=1}^N\frac{1}{j}$, $K_h$ denotes the number of features (dishes) having history $h$^[A feature $k$ has history $h$ if $\sum_{i=1}^N f_{ik}2^{i-1}=h$.] and $K_+=\sum_{h=1}^{2^N-1}K_h$ is the number of features for which $m_k>0$.

We mention some additional important properties of the IBP [@tutorial2012tutorials]:

* The IBP gives birth to a rich-get-richer phenomenon at the feature level; The more a feature is active, the more it will be. 
* The distribution of the number of active feature is $K_+\sim \Poisson(\alpha H_n)$.
* The distribution of total of non-zeros entry in $F$ is $\Poisson(\alpha N)$.

A constructive approach of the IBP is obtain through the infinite limit of a Beta-Bernoulli process. Let $F$ defined by the following process:
\begin{align*}
	\pi_k \sim \mathrm{Beta}(\frac{\alpha \beta}{K}, 1), \\
	f_{ik} \mid \pi_k \sim \mathrm{Bernoulli}(\pi_k)
\end{align*}
When $K\rightarrow \infty$ one can show, modulo the size of the equivalence classes, that $P(F|\alpha)$ is consistent with equation \ref{eq:ibp_density}.


\begin{figure}[h]
	\centering
	\scalebox{1}{
		\input{source/figures/draw/bernoulli-beta.tex}}
	\caption{Graphical model for beta-bernoulli process}
	\label{fig:bernoulli-beta}
\end{figure}

#### Inference
\label{sec:ibp_inference}

\noindent
**Gibbs Sampler**

Developing MCMC sampler for the IBP is much simpler than for the DP. Indeed, one can show that the update rules for the entries of the matrix $F$ are given by:
\begin{align*}
& P(f_{ik} = 1 \mid F^{-(ik)}) = \frac{m_{-i,k}}{N} \\
& P(f_{ik} = 0 \mid F^{-(ik)}) = 1 - \frac{m_{-i,k}}{N}
\end{align*}
After having sampled all the feature for given row $i$ of the matrix, one sample new feature from $\Poisson(\frac{\alpha}{N})$.

\noindent
**Optimizing $\alpha$**

In order to learn the hyper-parameter $\alpha$ of the IPB prior, controlling the speed of grow of the feature matrix, we can put an conjugate prior on it. A Gibbs sampling step can then be inserted in the sampling loop following the approach used by  [@gorur06].

We know from the IPB the probability of generating a matrix of feature F to be:
$$
    P(F \mid \alpha) \propto P(\alpha \mid F) P(F) 
$$
Then we can isolate the part of the equation depending only on $\alpha$ to be:
$$
    P(F \mid \alpha) \propto \alpha^{K_+ } \exp(-\alpha H_N) \propto \Gmma(1+K_+, 1/H_N) 
$$
where $\Gmma(x, y)$ the Gamma distribution with shape $x$ and scale $y$.
Finally, if we suppose that $\alpha \sim \Gmma(a, b)$, for given hyper-parameter $a$ and $b$,  we obtain the following posterior distribution for $\alpha$:
$$
    P(\alpha \mid F) = \Gmma(a + K_+, \frac{1}{b + H_N})
$$ {#eq:alpha_ibp}

\noindent
**Two-parameter extension**

A notable limitation of the standard IPB is that the dimensionality of the matrix $F$ and its sparsity are coupled through $\alpha$. The two-parameter extension of the IBP add a parameter $\beta$ to be able to control the dimensionality $K$ and the sparsity of $F$ independently. In the constructive process of the IBP, the beta terms is changed as $\pi_k \sim \mathrm{Beta}(\frac{\alpha \beta}{K}, \beta)$.
Therefore the two-parameter IBP sampler is impacted as follows:

* A feature is activated with probability $\frac{m_k}{\beta+N-1}$,
* New columns/features are draw from $\Poisson(\frac{\alpha\beta}{\beta+N-1})$.

It follows that the expected number of non-zeros entry per row is still $\Poisson(\alpha)$ but, the distribution of active feature becomes $K_+ \sim \Poisson(\alpha \sum_{i=1}^N \frac{\beta}{\beta+i-1})$.

## Random graph models
\label{sec:random_graph}

Graph theory is historically concerned by the study of graphs with well establish structure such as regular graphs or planar graphs [@albert2002statistical]. In random graph theory, the motivation is to discover properties satisfied by graphs of general types and with limited design assumptions. The field have been popularised by a series of papers [@erdds1959random][@erdos1960evolution][@erdHos1961strength]. They proposed a very simple model, namely the Erd\H{o}s-Rényi (ER) model, and yet discovered meaningful properties that largely inspired the community.

### ER Model

In the ER model, an undirected graph with $N$ nodes is generated by connecting each node with a probability $p$, thus one has $y_{ij} \sim \Bern(p)$ and the class of possible graph generated is referred to as $G_{N,p}$. It can be shown that the distribution of a degree $d$ of a randomly chosen node has a closed form expression such that
$$
P(d=n) = \dbinom{N}{n} p^n (1-p)^{N-n} \ .
$$
A case of interest is for the so-called large graph, when $N\rightarrow \infty$. In this case, the degree distribution converge to a Poisson law as $P(d=n)\approx \Poisson(n;z)$ where $z=p(N-1)$ is the mean degree^[Where self-loop are not considered.]. The class of graphs $G_{N,p}$ generated by the ER model are consequently sometimes referred to as *Poisson random graph*. This result leads to another interesting property of the ER model worth to mention; let's define a *component* as a maximal subset of nodes that can all be reached from another in the same subset (through edge traversal). There is a so called *phase transition*, from low value of $p$, where there are many small components with exponential size distribution, to high value of $p$ with very few small components and one, so-called, *giant component*.
A consequence of this, is that the ER model satisfy the small world effect as its typical distance between two nodes is $l=\frac{\log N}{\log z}$ [@bollobas1998random]. Nevertheless, the ER model do not satisfy all the other properties found in real world networks. Its degree distribution is Poisson and thus has exponential decay, it has random mixing pattern and no clustering structure. Though, it is not adapted for modeling real systems, the ER model still gives insight on the way network can behave and constitutes a baseline regarding the emergence of phase transitions and giant components that are also studied in other random graph models.

Among the many extensions of the ER model proposed in the literature, we focus here on the Stochastic Block Model that provides a very general framework to model graph with community structure.

### Stochastic Block Model

The Stochastic Block Model (SBM), orinally proposed in [@holland1983stochastic], has since been extensively covered in the literature^[See \url{http://bactra.org/notebooks/stochastic-block-models.html}]. It is a random graph model where nodes belongs to some latent blocks (or communities) and the probability that two nodes bind depends only on the membership of the nodes to blocks. Let $N$ be the total number of nodes and $K$ the total number of blocks. Let the model parameters $\mat{\pi}=(\pi_1, \dotsc,\pi_K)$ and $(\phi_{kk'})_{K\times K}$ be respectively a probability vector and a probability matrix. The generative process of the SBM is then as follows:
\begin{align*}
c_i &\sim \Cat(\mat{\pi})  \qquad \text{ for } i \in \{1,\dotsc,K\} \\
y_{ij} &\sim \Bern(\phi_{c_ic_j}) \qquad \text{ for } i,j \in \V\times\V
\end{align*}
As one can note, if $K=1$ the model reduce to the ER model, otherwise all the sub-networks restricting nodes to single a block interaction (inner block interaction if $k=k'$, and outer block interaction if $k\neq k'$) locally behave like the ER model. The main challenge in the SBM is to infer a "good" partition of the nodes with the corresponding matrix weight as the combination of possible assignments is $K^N$. The optimization of parameters is generally accomplished with variant of the EM algorithm [@latouche2012variational]. Recently, efficient inference based on MCMC has also been proposed, with revisited version of the SBM [@peixoto2017nonparametric].

While the SBM is a strong baseline, is has several limitations due to the lack of prior over its parameters. In particular, the assumption of a fixed number of blocks is difficult to justify and bad choice of $K$ can leads to sub-optimal solution. This problem has been addressed by using DP prior over the node assignment vector. The resulting model is referred to as the Infinite Relational model (IRM) [kemp2006learning]. Another limitation is the hard assignment of nodes to blocks which may not be adapted to capture the diversity of interaction in real-world networks. Those limitation have been addressed in several directions that we will explore in the rest of the manuscript.


### Mixed-Membership Models

As mentioned, a limitation of the SBM is that each nodes belongs to only one latent block. This assumptions is often considered too restrictive for modeling complex network and complex system in general. More expressive model can be built by relaxing the hard assignment and instead allowing the nodes to belong to several latent blocks. The edge likelihood can hence be view as a mixture model depending on the node membership (akin to overlapping communities and soft clustering topic). Mixture models have a long history that is related to matrix factorization in order to decompose a data matrix into latent factors [@DCA]. A whole framework, named *mixed-membership model*, has emerged to study and generalize mixture models in the case where the latent variables can themselves be shared among data instances, which have found many successful applications [@MMM]. In this settings, we are particularly interested in two subclass of mixed-membership model for networks analysis, referred to has *latent class model* and *latent feature model*.
Many models have been proposed in this direction, though we do not intent to go into the details of each of them as it may not be relevant, we provide in Table \ref{table:dyadic_model} a comprehensive comparison of these models regarding theirs modeling assumptions. Generally, in latent class model, one suppose that the nodes belong to some latent communities on which depends the mixing pattern of the graph. Whereas, for latent feature model, one suppose that the nodes own some latent feature which control the mixing pattern. Interestingly, models that combine both aspect have been proposed, following [@mackey2010mixed].

The two type of models can be expressed in a common framework. Let $\Theta = (\theta_{ik})_{N\times K}$ and $\Phi=(\phi_{kk'})_{K\times K}$ be two random matrix with $N$ be the number of nodes and $K$ the dimension of the latent space. The edge likelihood is then parametrized by a bilinear product such that
$$
    y_{ij} \sim \Bern(f(\theta_i^T \Phi \theta_j))
$$ {#eq:mmm}
where $f$ is a bijective function to map the support of the bilinear product to a probability space if necessary, otherwise $f$ is the identity.
One can easily see that model representation encompass the ER and SB models. Precisely, the only difference between those random graph model, including the difference between latent class and latent feature models, is the prior knowledge and  parameters space of $\Theta$ and $\Phi$:

* if $K=1$ one fall on the ER model,
* if $\theta_i\sim \Mult(1, \pi_k)$ and $\phi_{kk'}\sim \Uniform[0,1]$ with given hyper-parameter $\pi=(\pi_1,\dotsc,\pi_k)$ on fall on the SB model. Additionally, if $\pi_k \sim GEM(\gamma)$, the model is equivalent to the Infinite Relational Model (IRM), where the number of class $k$ can vary.
* if $\theta_i \sim \Dir((\alpha_1, \dotsc, \alpha_K))$ and $\phi_{kk'}\sim \Beta(a, b)$ the model is equivalent to the Mixed-Membership Stochastic Blockmodel (MMSB) ^[Proof: $P(y_{ij}|\Theta,\Phi)=\sum_{k_1=1}^K\sum_{k_2=1}^K P(y_{ij}|\Phi, \zij=k_1, \zji=k_2)P(\zij=k_1|\theta_i)P(\zji=k_2|\theta_j) = \sum_{k_1=1}^K\sum_{k_2=1}^K \phi_{k_1 k_2} \theta_{ik_1} \theta_{jk_2} = \theta_i^T \Phi \theta_j$.].
* if $\Theta \sim \IBP(\alpha)$ and $\phi_{kk'} \sim \Normal(0, \sigma)$ then the model is the Infinite Latent Feature Model (ILFM).
* etc.


\begin{table}[h]
    \resizebox{\textwidth}{!}{
    \begin{tabular}{c||l|c|c|c|c|c|}
        \hline
        \hline
        \textbf{Type} &\textbf{Model} & \textbf{Observations} & \textbf{Prior} & \textbf{Mixed-membership} & \textbf{Generalize}  \\ 
        \hline
        \hline
        \multirow{5}{*}{\shortstack[1]{Latent\\class}} &
           SB      [38] & Bernoulli & Multinomial           & no & ER \\
         & IRM     [59]                  & Bernoulli & DP                    & no & SB \\
         & IHRM    [160]                 & Bernoulli & DP                    & no & IRM \\
         & MMSB    [118]                 & Bernoulli & Multinomial-Dirichlet & yes & SB \\
         & IMMSB   [?;119]  & Bernoulli & HDP                   & yes & MMSB, IRM \\
        \hline
        \multirow{4}{*}{\shortstack[1]{Latent\\feature}} &
           LFL    [161]          & Bernoulli & -                     & no & softmax \\
         & ILRM   [117]                 & Bernoulli & IBP                   & yes & IRM \\
         & BPM    [116]                   & Bernoulli & IBP                   & yes & IRM \\
         & IMRM   [125]                  & Bernoulli & IBP                   & yes & ILFM \\
    \end{tabular}}
\caption{Comparison of latent class and feature models found in the literature.}
\label{table:dyadic_model}
\end{table}

<!--
[@goldenberg2010survey]
[@IRM]                 
[@IHRM]                
[@MMSB]                
[@iMMSB;@diMMSB]  & Ber
                       
[@menon2010log]         
[@ILFM]                 
[@BMF]                  
[@IMRM]                 
-->

In chapter \ref{sec:mmsb_prop}, we further explore and compare two general representative of latent class models and latent feature models. That is the IMMSB and ILFM model, that both allow overlapping communities with an infinite number, the former based on the HDP and the latter in the IBP. 

<!--**Earosheva theorem**-->


### Representation theorem for exchangeable graphs
\label{sec:random_graph_th}

In section \ref{sec:non_parametric}, we mentioned the concept of exchangeability of random sequences and illustrated how it is related to the construction of the Dirichlet Process.
What we have learned, is that the exchangeability assumptions over a sequence of observable data is equivalent to the existence of an integral decomposition (a mixture) of the probability density of this sequence under which the observation are i.i.d given a random probability measure.
This results is known as the de Finetti' theorem and constitute justification for the existence of a latent variable generative model under the exchangeability assumption.
An interesting question to ask though, is if an equivalent representation theorem exists for exchangeable random graph. The answer is yes, and it is know as the Aldous-Hoover theorem, that we will recall here. This theorem has a version adapted for bipartite but we will focus here on unipartite networks and thus symmetric adjacency matrix.

Let's consider an undirected graph an its adjacency matrix $Y$ (an array) of infinite size.
\begin{definition}[Jointly exchangeable array]
A random array $(y_{ij})_{i,j\in \Na}$ (denoted simply $(y_{ij})$ for short) is called jointly exchangeable if $$P((y_{ij})) = P((y_{\pi(i)\pi(j)})) $$
holds for every permutation $\pi$ of $\Na$.
\end{definition}
As for exchangeable sequence, exchangeable graphs means that the probability of such a graph (generated by a given model) should not depend on the order in which we observe data.

\begin{theorem}[Aldous-Hoover for jointly exchangeable array] \label{th:aldous_hoover}
Let $\mat{Y}$ be a sample space. A random array $(y_{ij})_{i,j\in \Na}$ is jointly exchangeable if and only if it can be represented as follows: There is a random measurable function $F : [0,1]^3\to \mat{Y}$ such that
$$
P((y_{ij})) = P((F(U_i, U_j, U_{\{i,j\}})))
$$
where $(U_i)_{i\in \Na}$ and $(U_{\{i,j\}})_{i,j \in \Na}$ are, respectively, a sequence and an array of i.i.d $\Uniform[0,1]$ random variable.
\end{theorem}
In Bayesian language, the theorem state that there is a prior distribution $\mu$ over measurable function a exchangeable graph is always generated by a model of the form
\begin{align*}
F &\sim \mu \\
U_i &\sim \Uniform[0,1] \qquad \forall i \in \Na \\
U_{\{i,j\}} &\sim \Uniform[0,1] \qquad \forall i,j \in \Na \\
&y_{ij} := F(U_i, U_j, U_{\{i,j\}})
\end{align*}

This powerful theorem gives again a justification for the use of latent variables and most important the form of theirs priors (and a model in entirely determined by the choice of the prior on $F$) for exchangeable graph. Although intuitive, it is not straitfoward to proove that the representation for mixed-membership model given in Eq. \ref{eq:mmm} generate exchangeable graph, it appears that it is a special case of theorem \ref{th:aldous_hoover}, which has been shown in [@aldous1981representations] and [@kallenberg2006probabilistic]. It derives from the fact the edges probabilities are conditionally independent and that the nodes are associated to i.i.d random variables. In particular, the exchangeability of IRM, IMMSB and ILFM models are also illustrated in [@orbanz2015bayesian].

An notable corollary of the theorem \ref{th:aldous_hoover} is that exchangeable graph are either dense (i.e the number of edges growth quadratically with $N$) or empty since their expected number of edges is independent of $N$. This may seem as a misspecification for the modeling of real-world network. In response to that, the study of representation for graph in the sparse regime has appears as an active and growing field of research [@veitch2015class][@caron2017sparse][@le2015sparse][@bollobas2011sparse][@borgs2014p].


<!--
### Mixed-Membership Models

#### Latent feature model

#### Latent class model
Point to MMSB and IBP in later presentation.


## Approximate inference
\label{sec:network_inference}

### Markov Chain Monte Carlo
\label{sec:mcmc}

### Variational Inference
\label{sec:vb}

### Alternative inference scheme

-->

## Summary

The chapter presented the mathematical framework underlying the latent variable model for complex networks. We recall some fundamental results of probability theory and exposed a flexible class of Bayesian nonparametric prior that will be use in later study. We also presented the class of latent variable studied, (Mixed-Membership model) that will be studied in the two next chapters and we provide a  modest literature survey. We finally presented the theoretical foundation (through representation theorem) that justify the construction and expose limitations of this class of model.
