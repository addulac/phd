# Weighted Mixed Membership Stochastic Block Model and Scalable Inference
\label{sec:wmmsb}

## Introduction

From social networks to protein interactions, from physics to linguistics, networks are one of the key representations for objects interacting with one another. The interest for modeling such networks has naturally increased with the availability of large datasets, and people have tried to design generative models to describe the formation of links between nodes. Among such generative models, stochastic block models and their extensions through mixed-membership block models have received particular attention [@airoldi2009mixed,iMMSB,fan2015dynamic] as they can account for the underlying classes that structure real-world networks and in particular social networks. Nevertheless, most models proposed so far are devoted to unweighted networks. To our knowledge, only two models, in the stochastic block model family, have been proposed for weighted graphs: the latent block structure model of [@aicher2014learning] and the weighted stochastic block model of [@peixoto2018nonparametric]. These two models however suffer from the same drawback as standard stochastic block models, namely the fact that a node can belong to only one class, which is not realistic for many networks. Mixed-membership block models were specifically designed to overcome this limitation and we propose here a new mixed-membership block model adapted to weighted networks. One important aspect in designing a generative model for networks is to develop a scalable inference method so that the model can be applied on large networks. We rely in this study on collapsed variational inference coupled with stochastic variational inference to do so.

The remainder of the chapter is organized as follows: Section \ref{sec_5:rl} describes related work; Section \ref{sec_5:model} presents the weighted mixed-membership models and Section \ref{sec_5:inference} their inference; Section \ref{sec_5:exps} illustrates the behavior of the proposed models on several real-world networks. Finally, Section \ref{sec_5:concl} concludes the study.

<!--
Especially in the machine learning literature, that focused on link prediction, dimensionality reduction and data exploration tasks. One of the main challenge in this area is to be able to handle massive networks that emerge from the web. In this paper, we focus on networks that underpin some kind of social relationship such as collaboration or communication networks. In this context, we propose an online learning algorithm that we derived for both binary and count edge covariate, within the framework of Mixed-Membership Stochastic Blockmodel (MMSB).

%%%% The type of networks that exists
%%Complex networks are graphs that are used to represents real-world relationnal information. In computer science, a major network is the web that connects a large amount of data. There is a large diversity in the type of data that can be interconnected, which ca be a set of people in a social plateform, a set of documents linked with hyperlinks, communication networks of email or more recently a graph of transaction encoded in a blockchain. Outside the web an other important networks is the one made of the scientific collaborations.

%%%% The Scalability problem => Sparse Network E/N**2 << 1
The complexity (time and memory) of batch algorithm are polynomial for graph. Thus, the need of online algorithm, able to update a model as data become available is fundamental for scaling strategy. This can because of the temporality of the data or more simply because the data don't fit in memory. Another source of diversity in networks is the support for labelled and dynamic networks. In this paper we study and propose an algorithm based on latent models with rich priors who scale for complex and massive networks, with labeled edges (weighted networks), and that can be adapted to model the exchangeability of sequences of binary networks (temporal networks).
-->

## Related work
\label{sec_5:rl}


The original MMSB model was proposed in [@airoldi2009mixed] with a variational inference scheme. The inference process was later extended with stochastic variational inference in [@gopalan2013efficient] and structured variational inference in [@kim2013efficient] for scalability purposes. Stochastic variational inference has been applied with a collapsed variational objective for the latent Dirichlet allocation model [@foulds2013stochastic]. To our knowledge, it is the first time that stochastic and collapsed variational inference are coupled in the context of stochastic block models.

A weighted version of the stochastic block model has been proposed in [@aicher2014learning]; it can be seen as a special case of the WMMSB model proposed in this chapter in which nodes are constrained to belong to only one latent class. More recently, another type of weighted stochastic block models has been proposed [@peixoto2018nonparametric] in which different kernels can be used to model different types of weights. An efficient MCMC method is used for inference. If this type of models is interesting, it nevertheless relies again on the assumption that a node belongs to only one class, which may be inappropriate for real-world networks. Furthermore, unlike MMSB models, the lack of a hierarchical prior structure does not allow one to rely on efficient non-parametric extensions (hence the use of costly model selection techniques for non-parametric versions).

Similar to our model, count processes with Poisson distributions and Gamma conjugate priors have been studied by different authors [@zhou2012augment;@zhou2015negative]. The relation of such processes with Negative Binomial processes is well-known and is highlighted by these authors. Such processes can be used for topic modeling, as the Beta-Gamma-Gamma-Poisson model of [@zhou2012beta] that relies on MCMC inference. The main difference between this model and WMMSB is that the former factorizes counts as Poisson variables of a sum of latent factors while, in WMMSB, counts are factorized as a convex sum of Poisson variable depending on class memberships.

The main theoretical contribution of this chapter is two-fold: firstly, we propose a mixed-membership stochastic block model, called WMMSB-bg, for weighted networks allowing nodes to belong to several classes, and secondly we show how to efficiently learn this model on large networks with a stochastic collapsed variational inference algorithm.


## Weighted networks and the Poisson law

Most of the real networks exhibit a topology more complex than just binary relationship between nodes. Instead, the relations can be weighted and dynamic. For example, co-authorship networks can be constructed such that the edge covariates correspond to the number of collaborations between the underlying authors [@newman2001scientific]. In a communication network, the weight can be the number of messages sent from the sender to the receiver. In the web, documents are connected with hyperlinks where the counts of those are for example used to construct the PageRank algorithm. Finally, in a linguistic network, a network of words can be built where the weight between two words is the number of times where they follow each other. Another useful case where weighted networks can be useful is temporal networks. For instance, in communication networks, messages are sent at a specific time, thus taking into account the number of messages sent during a period of time allows to represent the strength of the relation over the time.

In this study, we consider the weighted relations as a measure for the number of times each node has interacted. Thus, a natural prior for count edge covariate is the Poisson distribution. Furthermore, it has several nice properties:

\begin{itemize}
\item{Additivity}: If $K_1 \sim \mathrm{Poi}(\alpha_1)$ and $K_2 \sim \mathrm{Poi}(\alpha_2)$ then,
    \begin{equation*}
        K_1 + K_2 = \mathrm{Poi}(\alpha_1 + \alpha_2)
    \end{equation*}
\item {Thinning}: The number of successes in a Poisson number of coin flips is Poisson, namely if $K \sim \mathrm{Poi}(\alpha)$ and $X_1,\dotsc,X_K \sim \mathrm{Bern}(p)$ then,
    \begin{equation*}
        \sum_{i=1}^K X_i = \mathrm{Poi}(p\alpha)
    \end{equation*}
\end{itemize}

<!--In the second case the weights can also be seen as a \emph{strength} of connection between individuals, since it represents a count/number of times they interacted together. There is a number of situations where such a case arise. One can think for example, to the count of clicks that an user makes during a web session. Or the number of time that a individual send a message to another in a communication network, such as email or online social networks. Or again, the number of transportation between two cities. Thus modeling weighted networks is a way to take into account the strength of relations that arise in a temporal context, but by keeping the exchangeability assumptions. Or says differently, we loose the time order in which each individual connections took place. That is the reason why we use the term \emph{time exchangeability}.-->

These two properties justify to build weighted networks datasets from sequence of either weighted graphs or binary graphs to feed a Poisson based model. This is convenient to exploit the network datasets that are often provided as a time sequence of binary or weighted interactions by summing up all node pairs interactions. 

<!-- nips comment....time exhvngbility (loose) but weighte win over binary. -->


As usual, we will consider that a network is represented by a graph $G=(\V,\E)$ where $\V$ is the set of nodes such that $N=|\V|$ and $\E$ the set of edges. We consider the adjacency matrix $Y=(y_{ij})_{ij\in N^2}$ such that $y_{ij}=0$ if $(i,j) \notin \E$ and $y_{ij} > 0$ otherwise.


## Mixed-Membership Stochastic Block Models and (un)weighted graphs
\label{sec_5:model}

Mixed-membership stochastic block (MMSB) models extend stochastic block models [@airoldi2009mixed] by allowing nodes to "belong" to several blocks (or classes) through a given (usually Dirichlet) probability distribution. Prior to generate a link between two nodes, a particular class is selected for each node. The link is then generated according to a probability distribution $F$, sometimes referred to as the \textit{kernel} distribution, that depends on the selected classes. The generative process behind such models can be summarized as:

1. For each node $i$, draw $$\theta_i \sim \textrm{Dir}(\alpha),$$ where $\theta_i$ and $\alpha$ are $K$-dimensional vectors, $K$ denoting the number of classes considered;
2. Generate two sets of latent class memberships for each possible interactions, $$Z_\rightarrow = \{z_{i\rightarrow j} \sim \textrm{Cat}(\theta_i), 1 \le i,j \le N\}$$ and $$Z_\leftarrow = \{z_{i\leftarrow j} \sim \textrm{Cat}(\theta_j), 1 \le i,j \le N\},$$ with categorical draws;
3. Generate or not a link between two nodes $(i,j)$ according to $$y_{ij} \sim F(\phi_{z_{i \rightarrow j}z_{i \leftarrow j}}),$$ where $F$ is a distribution in the exponential family and $\phi_{z_{i \rightarrow j}z_{i \leftarrow j}}$ an associated (usually drawn from a conjugate distribution) parameter that represents the relations between classes. For unweighted graphs, $F$ is usually Bernoulli and $\phi$ its conjugate Beta distribution.

Many real networks nevertheless rely on graphs in which edges are naturally weighted. In co-authorship networks, for example, it is standard to consider edges weighted according to the number of collaborations between authors [@newman2001scientific]. In communication networks, the weights are based on the number of messages sent from the sender to the receiver. In text mining and natural language processing applications, it is also common to use word graphs in which edges are weighted on the basis of the number of times the words co-occur (in a sentence, paragraph or document). In all these cases, weights are integers that can naturally be modeled with Poisson distributions. Relying on its conjugate Gamma distribution for $\phi$, one finally obtains the following models, denoted MMSB for unweighted graphs and WMMSB for weighted graphs:
$$
\theta_i \sim \textrm{Dir}(\alpha), \,\, z_{i\rightarrow j} \sim \textrm{Cat}(\theta_i), \,\, z_{i\leftarrow j} \sim \textrm{Cat}(\theta_j)
$$
and:
\begin{align*} \label{eq:generative}
y_{ij} &\sim \textrm{Bern}(\phi_{z_{i \rightarrow j}z_{i \leftarrow j}}), &\phi_{kk'} &\sim \textrm{Beta}(\lambda_0, \lambda_1), & \textrm{ \textit{for unweighted graphs}} \\
y_{ij} &\sim \textrm{Poi}(\phi_{z_{i \rightarrow j}z_{i \leftarrow j}}), &\phi_{kk'} &\sim \textrm{Gamma}(r, \frac{p}{1-p}), & \textrm{ \textit{for weighted graphs}} 
\end{align*}
The choice made here for the Poisson and Gamma distributions in WMMSB allows one to represent overdispersed count data as one has [@zhou2012beta]
$$y_{ij} \sim \textrm{NB}(r,p)$$
where $\textrm{NB}$ denotes the negative binomial distribution. Furthermore, the above models are valid for both directed and undirected graphs, the matrix $\Phi = (\phi_{kk'})_{k,k' \in \{1,\dotsc,K\}^2}$ being symmetric in the latter case.


### Beta-Gamma augmentation

The generative process for WMMSB defined above assumes that the parameters of the Poisson distributions used to generate links are drawn from the same Gamma distribution. Having a unique prior over these parameters however limits the ability of the model to capture the variance in the relations between the latent classes. Hierarchical extensions can be used here to have a better representation of the classes and the relations between them. Following the Beta-Gamma-Gamma-Poisson model [@zhou2012beta] and the Gamma-Negative Binomial process [@zhou2015negative], we model here the rate parameter of the Gamma distribution used in WMMSB with a Beta prior and its shape parameter with another Gamma distribution of the form:
\begin{gather*}
r_{kk'} \sim \textrm{Gamma}(c_0r_0, 1/c_0) \qquad p_{kk'} \sim \textrm{Beta}(c\epsilon, c(1-\epsilon)) \\
\phi_{kk'} \sim \textrm{Gamma}(r_{kk'}, \frac{p_{kk'}}{1-p_{kk'}})
\end{gather*}

The variable $y_{ij}$ is again distributed according to a negative binomial distribution, of the form:
$$y_{ij}|{Z} \sim \textrm{NB}(r_{z_{i \rightarrow j} z_{i \leftarrow j}},p_{z_{i \rightarrow j} z_{i \leftarrow j}}).$$
As one can note, and contrary to WMMSB, the parameters of the negative binomial distribution depend this time on the classes selected for each node, meaning that classes now play a prominent role in the model. We will denote this model as WMMSB-bg.

As for most hierarchical Bayesian model, exact inference is intractable and one must resort to approximate inference. In the next section we propose a stochastic collapsed variational inference algorithm for the above models (MMSB, WMMSB, WMMSB-bg).

## Inference
\label{sec_5:inference}

Standard inference method for MMSB models rely either on Gibbs sampling or variational approach [@airoldi2009mixed]. The former approach give generally better results than the latter as sampling methods approximate the true posterior distribution while variational ones makes stronger assumptions on the posterior distribution that leads to a biased estimation. On the other hand variational approach usually allow faster convergence due to its deterministic form.

Collapsed variational Bayes inference presents the advantage, over standard variational inference, to rely on weaker assumptions and has proven to be efficient on the latent Dirichlet allocation model [@teh2007collapsed]. Recent advances in stochastic variational inference [@hoffman2013stochastic], notably based on well-designed sampling techniques [@gopalan2013efficient;@kim2013efficient], have furthermore shown that it is possible to speed-up (collapsed) variational inference with online updates based on minibatches.
Coupling collapsed and stochastic variational inference thus leads here to an efficient inference method that can be used on large networks.

We first provide below the results obtained through collapsed variational inference for MMSB and its weighted counterparts. A detailed derivation of these results is given in the appendix \ref{annexe:wmmsb}. We then detail how stochastic variational inference is used on these models.

### Collapsed Variational Inference

In the remainder, we use the notation $n^{-ij}$ to indicate that the superscript $ij$ is excluded from the underlying count variable, and $n_{\bm{.}}$ to indicate a sum over the dotted subscript index. Furthermore, $\Pi$ will denote the model parameters ($\Pi = (\Theta,\Phi,Z)$ for MMSB and WMMSB and $\Pi = (\Theta,\Phi,Z,R,P)$ for WMMSB-bg) and $\Omega$ the hyper-parameters ($\Omega = (\alpha,\lambda_0,\lambda_1)$ for MMSB, $\Omega = (\alpha,r,p)$ for WMMSB and $\Omega = (\alpha, c_0, r_0, c, \epsilon)$ for WMMSB-bg). 

From Jensen's inequality, for any distribution $q$, one has: 
\begin{equation*}
\log p(Y | \Omega) \ge \Er_{q}[\log p(Y, \Pi\ | \Omega)] + \textrm{H}[q(\Pi)]
\end{equation*}
where $\textrm{H}$ denotes the entropy. The goal of variational inference is then to find $q$ that maximizes the right-hand side of the above inequality, usually referred to as the Evidence Lower BOund (ELBO). In its collapsed version, following [@teh2007collapsed], one weakens the mean-field assumption made over the variational distribution, leading to, for MMSB and WMMSB: 
\begin{equation*}
q(\Pi) = q(\Theta, \Phi | Z) q(Z)
\end{equation*}
with $q(z_{i \rightarrow j}, z_{i \leftarrow j}|\gamma_{ij})$ being multinomial with parameter $\gamma_{ij}$. The evidence is then lower bounded by:
\begin{equation*}
\log p(Y|\Omega) \geq \underbrace{\Er_{q}[\log p(Y, Z)] + \textrm{H}[q(Z)]}_{\L_Z}
\end{equation*}

Maximizing $\L_Z$ w.r.t $\gamma_{ijkk'}$ under a zero order Taylor expansion and a Gaussian approximation, following [@teh2007collapsed;@asuncion2009smoothing], yields the following updates:
\begin{equation} \label{eq:maximization}
\gamma_{ijkk'} \propto (N_{\rightarrow ik}^{\Theta^{-j}} + \alpha_k) (N_{\leftarrow jk}^{\Theta^{-i}} + \alpha_{k'}) p(y_{ij} | Y^{-ij}, Z^{- ij}, \zij=k, \zji=k',\Omega)
\end{equation}
where the elements $N^{\Theta}$ are defined in Eqs \ref{eq:sss}. Depending on the model considered, the predictive link distribution takes the following form:
\begin{align*}
&p(y_{ij} | Y^{-ij}, Z^{- ij}, \zij=k, \zji=k',\Omega) = \\
& \qquad \begin{cases}
    \left( \frac{ N^{\Phi^{-ij}}_{1 kk'} + \lambda_1}{N^{\Phi^{-ij}}_{\bm{.}kk'} + \lambda_{\bm{.}}}\right)^{y_{ij}} \left( 1- \frac{ N^{\Phi^{-ij}}_{1 kk'} + \lambda_1}{N^{\Phi^{-ij}}_{\bm{.}kk'} + \lambda_{\bm{.}}}\right)^{1-y_{ij}} & \textrm{\textit{for MMSB}} \\
    \mathrm{NB}\left(y_{ij}; N^{Y^{-ij}}_{kk'} + r, \frac{p}{p\,N^{\Phi^{-ij}}_{\bm{.}kk'} + 1} \right) & \textrm{\textit{for WMMSB}} % \\
%    \sim \mathrm{NB}\left(y_{ij}; N^{Y^{-ij}}_{kk'} + \Er_{q}[r_{kk'}], \frac{\Er_{q}[p_{kk'}]}{\Er_{q}[p_{kk'}]\,N^{\Phi^{-ij}}_{\bm{.}kk'} + 1} \right) & \textrm{ for WMMSB-bg}
\end{cases}
\end{align*}

The different count statistics $N^*$ are estimated from the variational parameters $\gamma_{ijkk'}$ by:
\begin{align} \label{eq:sss}
    N^{\Theta}_{\rightarrow ik} &= \sum_{j, k'} \gamma_{ijkk'}        & N^{\Theta}_{\leftarrow jk'} &= \sum_{i, k} \gamma_{ijkk'} \nonumber \\
    N^{\Phi}_{xkk'} &= \sum_{ij:y_{ij}=x} \gamma_{ijkk'} & N^{Y}_{kk'} &= \sum_{ij} y_{ij}\gamma_{ijkk'}
\end{align}

In this inference scheme, $\gamma_{ij}$ are the \emph{local} parameters while the count statistics $N^*$ represent the \emph{global} parameters (or global counts).

Finally, the model parameters can be recovered from their estimates as follows:
\begin{align*}
\hat \theta_{ik} = \frac{N^{\Theta}_{\rightarrow ik} + N^{\Theta}_{\leftarrow ik} + \alpha_k}{2N + \alpha_{\bm{.}}} \qquad 
\hat \phi_{kk'}=\begin{cases}
     \frac{N^{\Phi}_{1 kk'} + \lambda_1}{N^{\Phi}_{\bm{.}kk'} + \lambda_{\bm{.}}} & \textrm{ \textit{for MMSB}} \\
    \frac{p(N^Y_{kk'} + r)}{N^{\Phi}_{\bm{.}kk'} - p + 1} & \textrm{ \textit{for WMMSB}}
%    \frac{\Er_{q}[p_{kk'}](N^Y_{kk'} + \Er_{q}[r_{kk'}])}{N^{\Phi}_{\bm{.}kk'} - \Er_{q}[p_{kk'}] + 1} & \textrm{ for WMMSB-bg} 
    \end{cases}
\end{align*}

#### Beta-Gamma augmentation

For WMMSB-bg model, we consider the following collapsed variational distribution:
\begin{equation*}
q(\Pi) = q(\Theta, \Phi|Z, R, P)q(Z)q(R)q(P)
\end{equation*}
with $R=(r_{kk'}), P=(p_{kk'}), \, 1 \le k,k' \le K$. As before, $q(z_{i \rightarrow j}, z_{i \leftarrow j}|\gamma_{ij})$ is multinomial with parameter $\gamma_{ij}$. 

The same development as above applies for the parameters $\gamma_{ijkk'}$, given here also by Eq. \ref{eq:maximization}. Furthermore, the predictive link probability now take the form:
\begin{align*}
&p(y_{ij} | Y^{-ij}, Z^{- ij}, \zij=k, \zji=k',\Omega) \sim \\
&\qquad \mathrm{NB}\left(y_{ij}; N^{Y^{-ij}}_{kk'} + \Er_{q}[r_{kk'}], \frac{\Er_{q}[p_{kk'}]}{\Er_{q}[p_{kk'}]\,N^{\Phi^{-ij}}_{\bm{.}kk'} + 1} \right)
\end{align*}
and the block-block probability estimation takes the following form:
$$
\hat \phi_{kk'} = \frac{\Er_{q}[p_{kk'}](N^Y_{kk'} + \Er_{q}[r_{kk'}])}{N^{\Phi}_{\bm{.}kk'} - \Er_{q}[p_{kk'}] + 1}
$$

Setting $q(P) = p(P|Y,Z,\Omega)$ where $p$ is the true distribution and exploiting the conjugacy of the Beta and the negative binomial distributions leads to a Beta distribution for $p_{kk'}$: 
\begin{equation} \label{eq:pk_update}
  p_{kk'} \sim \textrm{Beta}(c\epsilon + N^Y_{kk'}, c(1-\epsilon) + N^\Phi_{kk'}\Er_{q}[r_{kk'}])
\end{equation}
so that: 
$$
\Er_{q}[p_{kk'}] = \frac{c\epsilon + N^Y_{kk'}}{c\epsilon + N^Y_{kk'} + c(1-\epsilon) + N^\Phi_{kk'}\Er_{q}[r_{kk'}]}
$$

Lastly, as for its true distribution, the variational distribution for $r_{kk'}$ is taken in the Gamma family: $q(r_{kk'}) \sim \textrm{Gamma}(a_{kk'},b_{kk'})$. Even though $a_{kk'}$ can not be estimated explicitly, one only needs to have access to the expectation of $r_{kk'}$, that takes the following form: 
\begin{equation} \label{eq:rk_update}
\Er_{q}[r_{kk'}] = \frac{r_0c_0+N^Y_{kk'}}{c_0 -N^\Phi_{kk'}\log(1-p_{kk'})}
\end{equation}


### Stochastic Variational Inference with Stratified Sampling

Stochastic variational inference aims at optimizing ELBO through noisy yet unbiased estimates of its natural gradient computed on sampled data points. Different sampling strategies [@gopalan2013efficient;@kim2013efficient] can be used. Following the study in [@gopalan2013efficient], we rely here on stratified sampling that allows one to control the number of links and non-links considered at each step of the inference process. For each node $i, \, 1 \le i \le N$, one first constructs a set, denoted $s_1^i$, containing all the nodes to which $i$ is connected to as well as $M$ sets of equal size, denoted $s_0^{i,m}, \, 1 \le m \le M$, each containing a sample of the nodes to which $i$ is not connected to^[The sampling is here uniform over the nodes not connected to $i$ with replacement; sampling without replacement led to poorer results in our experiments.]. We will denote by $S_0^i$ the set of all $s_0^{i,m}$ sets. Furthermore, we will denote by $S_0$ the union of all non-links set and $S_1$ the union of all links set. The sets thus obtained, for all nodes, constitute minibatches that can be sampled and used to update the global statistics in Eq. \ref{eq:sss}. The combined scheme is summarized below:

\begin{enumerate}
\item Sample a node $i$ uniformly from all nodes in the graph; with probability $\frac{1}{2}$, either select $s_1^i$ or any set from $S_0^i$ (in the latter case, the selection is uniform over the sets in $S_0^i$). We will denote by $s_i$ the set selected and by $|s_i|$ its cardinality.
\item For each node $j \in s_i$, compute $\gamma_{ijkk'}$ through Eq. \ref{eq:maximization} and intermediate global counts acc. to:
{\small \label{local_gradient_chap5}
\begin{align*} 
  &\hat N^{\Theta}_{\leftarrow jk'} = \frac{1}{Cg(s_i)} \sum_{k} \gamma_{ijkk'} \\
  &\hat N^{\Theta}_{\rightarrow ik} \mathrel{+}= \frac{1}{|s_i|} \frac{1}{Cg(s_i)} \sum_{k'} \gamma_{ijkk'} \\
  &\hat N^{\Phi}_{.kk'} \mathrel{+}= \frac{1}{|s_i|} \frac{1}{Cg(s_i)} \gamma_{ijkk'} \\
  &\hat N^{Y}_{kk'} \mathrel{+}= \frac{1}{|s_i|} \frac{1}{Cg(s_i)} \gamma_{ijkk'} y_{ij} 
\end{align*}
}
where $C$ is a constant that is $2$ for undirected graphs and $1$ for directed graphs and $g(s_i) = \frac{1}{Nm}$ if $s_i \in S_0^i$ and $\frac{1}{N}$ otherwise. Note that $Cg(s_i)$ correspond to the probability to observe the node $i$ depending on either $s_i$ belongs to $S_0$ or $S_1$.
\item Update of the global counts (online version of Eq. \ref{eq:sss}): \label{global_gradient_chap5}
\begin{align*} 
  &N^{\Theta}_{\rightarrow ik} \leftarrow (1 - \rho^{i,\Theta}_t) N^{\Theta}_{\rightarrow ik} + \rho^{i,\Theta}_t \hat N^{\Theta}_{\rightarrow ik} \\
  &N^{\Theta}_{\leftarrow jk'} \leftarrow (1 - \rho^{i,\Theta}_t) N^{\Theta}_{\leftarrow jk'} + \rho^{i,\Theta}_t \hat N^{\Theta}_{\leftarrow jk'}  \\
  &N^{\Phi}_{.kk'} \leftarrow (1 - \rho^{\Phi}_t) N^{\Phi}_{.kk'} + \rho^{\Phi}_t \hat N^{\Phi}_{.kk'} \\
  &N^{Y}_{kk'} \leftarrow (1 - \rho^{Y}_t) N^{Y}_{kk'} + \rho^{Y}_t \hat N^{Y}_{kk'}
\end{align*}
\item $\rho^*_t = \frac{1}{(\tau +t)^\kappa}$ with $\kappa \in (0.5, 1]$.
\item Go back to step 1 till convergence.
\end{enumerate}

As one can note, the intermediate global counts correspond to a restriction, on minibatches, of the complete computation given in Eq. \ref{eq:sss}. The value of $C$ is due to the fact that in undirected networks, each edge can be seen twice. The terms $\frac{1}{|s_i|}$ and $\frac{1}{Cg(s_i)}$ serve as a normalization in the gradient-like updates of the global counts (as there are more non-links than links, each non-link minibatch, representing a smaller fraction of the non-links, leads to more conservative updates). The "gradient steps" $\rho^*$ are discussed below (Robbins-Monro condition).

For \imb, the procedure is silghtly different. The parameter $N^Y$ does not exist for this model and the update coresponding to the count $N^\Phi_ {.kk'}$ is replaced by updates of $N^\Phi_{xkk'}$ where $x=1$ if the current point observed is a link as $\yij=1$ and $x=0$ if it is a non-link as $\yij=0$.

Lastly, to be able to efficiently compute such quantities as $N^{\Phi^{-ij}}$ used for the computation of the link probability, one needs to store in memory, for each pair of nodes $(i,j)$, a $K \times K$ matrix, which is not feasible for large networks. Thus, following [@foulds2013stochastic], we replace here $N^{\Phi^{-ij}}$ by $N^{\Phi}$ (and as well for $N^Y$ and $N^\Theta$), which amounts to assume that the contribution of each individual pair of nodes is negligible compared to all other pairs, a reasonable assumption when the network is large.

#### Robbins-Monro condition and implementation remarks

The convergence of stochastic variational inference is guaranteed under the Robbin-Monro condition [@robbins1951stochastic] that imposes constraints on the gradient step, $\sum \rho_t = \infty$ and $\sum \rho_t^2 < \infty$ which can be obtained with $\rho_t = \frac{1}{(\tau +t)^\kappa}$ with $\kappa \in (0.5, 1]$. Thus, we maintain a gradient step for each of the global statistics $\rho^\Phi$ and $\rho^Y$ accounting respectively for $N^\Phi$ and $N^Y$. For $N^\Theta$, we maintain individual gradient steps $\rho_i^{\Theta}$ for $1\leq i\leq N$, following [@miller2009nonparametric]; this improved both convergence and prediction performance. Furthermore, to increase the speed of the inference, we update the global statistic $N^\Phi$ and $N^Y$ only after a minibatch round. For the global statistic $N^\Theta$, we update it after a burn-in period $T_{burnin}$ such that $T_{burnin} \leq |S|$.
This heuristic provides a trade-off between updating the global statistics after each observation, which slows down the inference and may result in bad local optima, and updating them only after minibatches that are potentially large (proportional to the number of nodes).

<!--
%%% Two more point exists:
* the time step is increased with the minibatch size,
* the intermiatade graidnet is normalized by the minibatch size.
-->

Within a Stratified sampling scheme, the network dataset is divided into $N(1+m)$ minibatches. The sampling uniformly choose between the minibatches of links $S_1$ and non-links $S_0$, with the parameters $m$ controling the size of the non-links minibatch. The distribution of a minibatch $S$ has the following   distribution:
$$
S \sim h(S;m) = \frac{1}{2N}\delta_{S_1} + \frac{1}{2Nm}\delta_{S_0}
$$
where $\delta$ is the dirac operator, and $\delta_{S_1}=1$ if $S \in S_1$ and 0 otherwise.
One can see that the number of the non-link minibatches observed is in average $m$ times lower that the number of the link minibatches. This is particularly interesting for sparse networks where the number of non-links is predominant over the number of links. As, the model is update after each minibatch, one could expect that the inference converge much before the total number of minibatches is reached which represents a great interest to scale the inference process to large networks^[If all the $N(1+m)$ minibatches are observed during the inference, the time complexity will be in O(N^2).]. This is in fact what we observed in our experiments where the model converge in general after observing a small proportion of the total of minibatches (\ref{sec_5:exps}).

Our SCVI algorithm is summarized in the pseudo-code \ref{algo:scvb}.

\begin{algorithm}
\KwIn{Random initialization of $N^\Theta, N^\Phi, N^Y$.}
\KwOut{$\Thetah, \Phih$.}
\Begin{
$t \gets 0$ \\
\While{Convergence criteria not met}{
    Sample a minibatch $S$ from $h(S;m)$. \\
    \ForEach{$i,j \in S$}{
        Maximize local parameters $\gamma_{ij}$ from \ref{eq:maximization}.\\
        \If{burn-in finished}{
            Compute intermediate gradient $\hat N^\Theta$ from \ref{eq:sss}.\\
            Update global statistic $N^{\Theta}$.\\
            Update gradient step $\rho^\Theta_t$.\\
        }
    }

    Compute intermediate gradient $\hat N^\Phi$ and $\hat N^Y$  from \ref{local_gradient_chap5}.\\
    Update global statistics $N^{\Phi}$ and $N^{Y}$ from \ref{global_gradient_chap5}.\\
    Update gradient steps $\rho^\Phi_t$ and $\rho^Y_t$.\\
 Sample $P$ and $R$ from \ref{eq:pk_update} and \ref{eq:rk_update}.\\
    $t \gets t + 1$ .
    }
}
\caption{SCVI pseudo-code.}
\label{algo:scvb}
\end{algorithm}



## Experimental validation
\label{sec_5:exps}


We experimented our models on several real-world networks, directed and undirected. Their statistics and properties are summarized in Table \ref{table_5-chap5:corpus} and detailed descriptions are available in the online Koblenz network collection^[http://konect.uni-koblenz.de/networks/]. For both astro-ph and hep-ph datasets, we used the cleaned version available in the graph-tool framework.

\begin{table}[h] 
\bgroup
\def\arraystretch{1} % 1 is the default, change whatever you need
    \input{source/figures/chap5/img/corpus}
    \label{table_5-chap5:corpus}
\egroup
\tiny{
  $1$ \url{http://konect.uni-koblenz.de/networks/ca-AstroPh}. We used the cleaned version available in the graph-tool framework.\\
  $2$ \url{hhttp://konect.uni-koblenz.de/networks/ca-cit-HepTh}. We used the cleaned version available in the graph-tool framework.\\
  $3$ \url{hhttp://konect.uni-koblenz.de/networks/moreno_names}\\
  $4$ \url{hhttp://konect.uni-koblenz.de/networks/opsahl-ucsocial}\\
  $5$ \url{hhttp://konect.uni-koblenz.de/networks/munmun_digg_reply}\\
  $6$ \url{hhttp://konect.uni-koblenz.de/networks/slashdot-threads}\\
  $7$ \url{hhttp://konect.uni-koblenz.de/networks/enron}\\
  $9$ \url{hhttp://konect.uni-koblenz.de/networks/link-dynamic-simplewiki}\\
  $10$ \url{hhttp://konect.uni-koblenz.de/networks/prosper-loans}
}
\end{table}



### Experimental setup

As standard in social network analysis, the evaluation of the models is based on the missing link prediction task using the AUC-ROC score. For weighted models, we consider the probability that an edge exists between two unobserved nodes $(i,j)$ belonging to the test set, namely:
$$
p(y_{ij} \geq 1 | \Thetah, \Phih) = 1 - \sum_{kk'} \thetah_{ik} \thetah_{jk'} e^{-\phih_{kk'}}
$$


For all the datasets, we built a test set by extracting randomly 20 percent of the edges of the network and about the same amount of non-links. The remaining data constitutes the "full" training set. Then, in order to assess how the models behave when few training data is available, we sub-sampled this full training set in order to obtain smaller sub-training sets (subgraphs) containing different proportions of the edges (i.e 1\%, 5\%, 10\%, 20\%, 30\%, 50\%, and 100\%). Note that we ensure that all the sub-training sets are inclusive. We repeated this sampling 10 times with different seeds to cross validate our results. The average values (and standard deviations) computed on the ten sub-training sets are reported, for each proportion, as final results.

For deciding when to stop the inference process, 10\% of the training set used serves as a validation set on which the log-likelihood is computed after each minibatch iteration. When the increase of the log-likelihood, averaged over the last 20 measures, is less than 0.001, the inference is stopped. The log-likelihood of a given set of observations $\D_{set}$ is given by:
$$
\log p(\D_{set}) = \sum_{i,j \in \D_{set}} \log p(y_{ij} | \phih_{kk'}) p(k|\thetah_i) p(k'|\thetah_j)
$$

For all our models, the gradient step parameters $\tau$ and $\kappa$ were fixed respectively to $1024$ and $0.5$, the burn-in period $T_{burnin}$ to $150$; for stratified sampling, $M$ was set to $50$, the size of $s_0^{i,m}, \, 1 \le m \le M$ being equal to the number of nodes to which $i$ is not connected to divided by $M$. For MMSB, the hyper-parameters $\lambda_0$ and $\lambda_1$ were set to $0.1$. For WMMSB, the shape and scale parameters $r$ et $p$ were fixed to $1$ and for WMMSB, the beta-gamma hyper-parameters were fixed to $c_0=10$, $r_0=1$, $c=100$ and $\epsilon=10^{-6}$. The number of latent classes $K$ was fixed to $10$ for all models and the latent-class hyper-parameters $\alpha_k$ to $\frac{1}{K}$. Our implementation is available online^[https://github.com/***/*** (anonymized)]. In addition, we consider here two standard link prediction models, the stochastic block model, referred to as SBM, and its weighted extension, referred to as WSBM. For these two models, the microcanonical stochastic block model implementation of [@peixoto2018nonparametric] has been used since it integrates an efficient MCMC inference method for the stochastic block model family. The number of classes was also set to $K=10$.

Variational inference, used here for MMSB models, and MCMC, used for SBM models, lead to different performance, the latter usually yielding better models than the former [@asuncion2009smoothing]. Indeed, despite the fact that the MMSB models considered here rely on more realistic assumptions regarding the distribution of nodes over latent classes, the approximations made on the likelihood for scalable inference purposes penalize MMSB models when it comes to prediction accuracy. This said, the strong averaging step of the stochastic gradient descent allows for faster convergence so that, as the models are more realistic, they may yield better performance when the amount of training data is limited. This is indeed what we observe in practice.


\begin{figure}[h]
\centering
    \input{source/figures/chap5/img/roc_evolv_fig2}
\label{fig_5:roc}
\end{figure}

### Results

Figure \ref{fig_5:roc} gives the AUC/ROC scores for the different models when using 1\%, 5\%, 10\%, 20\%, 30\% and 50\% of the training data, for 6 networks (the complete results, over all training set size and networks are given in the appendix \ref{annexe:wmmsb}). As one can note, MMSB models outperform the other models when the amount of training data is limited. Among these models, WMMSB-bg is the best performing one, which highlights the importance of the Beta and Gamma priors used. The poor performance of MMSB on some networks can be explained by the fact that the convergence of the model is very sensitive to the sampling choices done during the online inference, as illustrated by the high variance in the results. When the amount of training data is sufficient (which depends on the network considered), SBM models tend to be better. As discussed before, we attribute this to the MCMC method used in SBM models. Surprisingly, and contrary to what is happening for MMSB models, WSBM does not really outperform SBM; this model does not seem to be able to make a good use of the edge covariates. 

Table \ref{table_5:roc}, which displays the results of MMSB, WMMSB-bg, SBM and WSBM for all networks when using 10\% and 100\% of the training data, confirms these elements. As one can note, using all training data, SBM outperforms WSBM on 5 datasets. Interestingly, there is an important degradation for SBM models when only 10\% of the training set is used. MMSB models are more stable in this aspect, showing that the stochastic variational inference used in MMSB models allows one to learn a correct model with few data.

Finally, it is worth mentioning that on the dataset prosper-loans, the only network classified as "Interaction" in the Konnect repository, most models fail to learn the topology. In particular, MMSB barely exceeds a random classifier. Only the weighted MMSB models, WMMSB and WMMSB-bg, succeed in predicting new edges, with a performance above 0.75 when using only 10\% of the training data.
 

\begin{table}
\centering
    \input{source/figures/chap5/img/roc_evolv_tab}
\label{table_5:roc}
\end{table}

### Convergence analysis

Figure \ref{fig_5:conv_entropy} shows the evolution of the log-likelihood for the MMSB-based models on a validation set composed of 20\% of links and non-links for each network. We used three different sets for the hyper-parameters shape $r$ and scale $p$ of WMMSB. Regardless of the values of these hyper-parameters, one can observe that the augmented model WMMSB-bg is less prone to overfitting, usually converges to a better solution and only needs a small proportion of the total number $N^2$ of edges to do so.

\begin{figure}[h]
\centering
    \input{source/figures/chap5/img/conv_entropy3}
\label{fig_5:conv_entropy}
\end{figure}

<!--
%%% Complexity
%Lastly, the complexity of the MMSB-based models with the inference scheme used here is linear in the number of nodes, meaning that it can be sublinear in the number of edges when the network is not too sparse. This has to be contrasted to the complexity of SBM-based models, that is linear in the number of edges. As our implementation, available online\footnote{https://github.com/***/*** (nonymized)}, is in Python whereas the one for SBM models is in C, a direct comparison of the running time of each model is not possible.
-->

<!--
%%% Time convergence
While our implementation is in python, the time convergence of the algorithm is fast and it is even comparable with SBM which is implemented in C. Furthermore, in practice, the algorithm exhibits a sublinear time complexity with the numbers of edges, as shown Table \ref{table_5:time}.

\begin{table}[h]
\begin{tabular}{llllll}
\hline
                    & MMSB                  & WMMSB-bg              & SBM                  \\
\hline
astro-ph      & 361.165 $\pm$ 159.107    & 868.802 $\pm$ 870.965    & 44.646 $\pm$ 4.778      \\
hep-th        & 170.281 $\pm$ 17.246     & 226.887 $\pm$ 77.84      & 20.366 $\pm$ 4.127      \\
moreno\_names  & 44.821 $\pm$ 7.717       & 30.362 $\pm$ 11.811      & 5.358 $\pm$ 1.67        \\
fb\_uc         & 50.927 $\pm$ 17.694      & 66.921 $\pm$ 10.439      & 4.093 $\pm$ 0.907       \\
digg-reply    & 1803.779 $\pm$ 1100.227  & 2044.334 $\pm$ 1016.157  & 228.661 $\pm$ 81.611    \\
slashdot      & 4272.667 $\pm$ 1971.346  & 2867.998 $\pm$ 653.092   & 365.437 $\pm$ 82.475    \\
enron         & 4660.744 $\pm$ 2978.898  & 3544.711 $\pm$ 385.445   & 1313.841 $\pm$ 109.074  \\
wiki-link     & 13683.093 $\pm$ 6890.663 & 5592.084 $\pm$ 228.13    & 613.841 $\pm$ 113.047   \\
prosper-loans & 6595.175 $\pm$ 4612.049  & 12255.827 $\pm$ 4878.113 & 1182.409 $\pm$ 183.342  \\
\hline
\end{tabular}
\label{table_5:time}
\caption{Inference time in seconds.}
\end{table}
-->




<!--
%%% WSim

For the weighted models, we further measure the capacity to predict right edge counts with a $l_1$ distance between the real count of the test set and the expected count of the models 

\begin{equation*}
D_{l_1}(D_{test} || \{\Thetah, \Phih\}) = \sum_{i,j \in \D_{test}} | y_{ij} - \Er[y_{ij}|\Thetah, \Phih] |
\end{equation*}
-->



## Conclusion
\label{sec_5:concl}

We exposed in this chapter a new model, from the mixed-membership stochastic block model family, to deal with (directed or undirected) weighted networks. We furthermore showed that this model can be efficiently learned through a stochastic collapsed variational approach that couples collapsed variational and stochastic inference, so that the model can be deployed on networks comprising millions of edges. Experiments conducted on several networks showed that the proposed model can successfully predict the topology of various real-world networks and that it outperforms the standard mixed-membership stochastic block model (with the same, scalable inference). Another interesting property of this model is the fact that it outperforms other stochastic block models when the mount of training data is limited.

<!--* contributiuon on scalable inference !-->






