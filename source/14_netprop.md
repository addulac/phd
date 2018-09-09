# Stochastic Mixed Membership Models and Properties
\label{sec:mmsb_prop}

## Introduction

Several powerful relational learning models have been proposed to solve the problem commonly referred to as \textit{link prediction} that consists in predicting the likelihood of a future association between two nodes in a network [@LibenNowell07;@HassanZaki11]. Among such models, the class of stochastic mixed membership models has received much attention as such models can be used to discover hidden properties and infer new links in social networks. Two main models in this class have been proposed and studied in the literature: the latent feature model [@BMF] and its non-parametric extension [@ILFM], and the mixed-membership stochastic block model [@MMSB], and its non parametric extension [@iMMSB;@fan2015dynamic]. These models fall in the category of mixed-membership models that encompasses a wide range of models (such as admixture and topic model) able to learn complex patterns from structured data [@airoldi2014handbook].

Nevertheless, although drawn from a wide range of domains, real world social networks exhibit general properties and one can wonder if these models are able to capture these properties. In this work, we focus on the \textit{preferential attachment} effect [@Newman2010;@Barabasi2003]. Preferential attachment states that a nodes is more likely to create connections with nodes having many connections. In graph theory, preferential attachment is used to explain the emergence of scale-free networks that are characterized by a power-law degree distribution. The aim of our study is to assess to which extent stochastic mixed membership models comply with this property.

<!--
However, as these models belong to the family of Bayesian model, we can study their behavior in two settings. In the first one, denoted $\mathcal{M}_g$, we consider the model as a pure generative model and given the parameters, we use it to generate artificial networks. Like this, we can study the model properties based on their expectation over the random parameters. In the second setting, denoted $\mathcal{M}_e$ and corresponding to the typical use of these models for link prediction, we consider that the parameters are unknown but some observations (\textit{i.e.} an existing network ) are available and are used to estimate the distribution underlying the models. 
-->

The remainder of the chapter is organized as follows: Section \ref{sec_4:rel-work} discusses related work. Section \ref{sec_4:background} describes the two main stochastic mixed membership models used for link prediction in social networks and the settings in which they are used. Section \ref{sec_4:burstiness} introduces formal definitions of preferential attachment and studies how stochastic mixed membership models relate to them. Section \ref{sec_4:exps} illustrates the theoretical results on two synthetic and two real networks and Section \ref{sec_4:concl} concludes the study. 

## Related work
\label{sec_4:rel-work} 

Recently, the class of stochastic mixed membership models have been successfully used for link prediction and structure discovery in social networks. For example, in [@AMMSB], the authors propose an adaptation of mixed-membership stochastic block model (MMSB) called a-MMSB, where "a" stands for assortative, and they use it for discovering overlapping communities in large networks having millions of nodes. The weight matrix is constrained to have a fixed small value outside its diagonal. A non parametric dynamic version of MMSB model has also been introduced to handle temporal networks [@fan2015dynamic]. The latent feature model (LFM) has also been extended in several ways, to handle non-negative weights in [@IMRM] and with a more subtle latent feature structure in [@ILAM]. Nevertheless, the characterization of these models with regards to the properties of the networks remains to be explored, with several challenges and oppurtunities as mentioned in [@jacobs2014unified]. 

In this chapter, we focus on two important properties of social networks, namely \textit{homophily} and \textit{preferential attachment} [@Newman2010;@Barabasi2003]. Those property has been emphasized in previous studies, for example for modeling and generating artificial networks reflecting properties of real networks, as in the model by Barab\`asi-Albert [@albert2002statistical], the model by Buckley and Osthus [@Buckley2001], which integrates a preferential attachment mechanism, or in the Dancer model for generating dynamic attributed networks with community structures and homophilic networks [@Largeron2017]. Preferential attachment has also been exploited for improving methods for solving classical tasks such as community detection [@Ciglan2013] or link prediction [@Zeng2016]. 
  That said, few theoretical works have been conducted to study to what extent stochastic models comply with this property. Orbanz and Roy pointed out that models belonging to the family of infinitely exchangeable Bayesian graph models cannot generate sparse networks and are thus less compatible with power law degree distributions [@orbanz2015bayesian]. Consequently, Lee \textit{et al.} proposed a random network model in order to capture the power law typical of the degree distribution in social networks [@Lee2015]. However the model remains challenging to use in practice, especially for link prediction, due to the relaxation of the exchangeability assumption.

Concerning the homophily effect, [@hoff2008modeling] pointed out that the latent eigen model (called MLFM, an extension of LFM) can comply with both homophily and stochastic equivalence in undirected graphs but without providing a formal definitions of these properties. Furthermore, Li \textit{et al.}, suggest that the latent eigen model MLFM fails to model homophily for directed graphs and, for correcting that, designed the GLFM model [@Li11].

A preliminary version of this study was published in [@dulac2017study]. However, the definitions of preferential attachment and local degrees we proposed in this previous paper are not entirely satisfying inasmuch as the dynamic aspect of preferential attachment was not taken into account. The definitions we propose here and the developments concerning stochastic block models are new and we believe better founded than in this previous work. 

We study, in a theoretical way, how the non-parametric versions of the classical stochastic mixed membership models handle homophily and preferential attachment. For this purpose, we introduce formal definitions of this phenomenon and then study how the models behave with respect to these definitions but, first, we present these models and the settings in which we study their behavior.


## Stochastic Mixed Membership Models
\label{sec_4:background}

Stochastic mixed membership models are generative models that rely on latent factors (also called latent \textit{classes} or \textit{features}) for modeling relational data such as links in social networks represented by a graph $G=(\V,\E)$, where $\V$ is a a set of nodes and $\E$ a set of edges between these nodes.

In the remainder, we denote by $N$ the number of nodes in this graph ($N = |\V|$) and by $Y$ the adjacency matrix of the graph $G$ ($y_{ij}=1$ if there is a link between nodes $i$ and $j$, $1 \le i,j \le N$; $y_{ij} = 0$ otherwise). Without loss of generality, we assume that the graph is undirected, the directed case being a special case of the undirected one.

Stochastic mixed membership models are characterized by the fact that each node can "belong" to several latent factors, which reflects the fact that each individual usually has several properties, for example can belong to several communities^[As mentioned in [@goldenberg2010survey], the reader should however bear in mind that the notion of latent factors is of stochastic nature and is an approximation of the notions of communities and shared properties.]. The relation between a node $i$ and the latent factors is encoded in a vector denoted $\mat{\theta}_{i}$, of finite dimension $K$ in standard versions of the models, and of infinite dimension in non-parametric versions. The collection of all vectors $\mat{\theta}_{i}$ ($1 \le i \le N$) constitutes the factor matrix $\mat{\Theta}$. Furthermore, a weight matrix $\mat{\Phi}$ is used to encode the relations between the latent factors.

Stochastic mixed membership models differ on the way the vectors $\mat{\theta}_{i}$ ($1 \le i \le N$) and the matrix $\mat{\Phi}$ are generated. As mentioned before, and to be as general as possible, we consider here the non-parametric versions of the latent feature model [@ILFM], referred to as \ifm, and of the mixed-membership stochastic block model [@iMMSB;@fan2015dynamic], referred to as \imb. This leads to a dynamic number of classes that allows the dimensions of the models to grow with the complexity of the data. This is done in practice by the use of non-parametric prior, the Indian Buffet Process (IBP) for \ifm\ and the Hierarchical Dirichlet Process (HDP) for \imb. All our results are nevertheless also valid for the finite versions of these models.

In the latent feature model, each node is represented by a finite vector of binary features. The probability of linking two nodes is then based on a weighted similarity between their feature vectors, the weight matrix being generated according to a normal distribution. In its non-parametric version \ifm, the feature vectors are now generated according to an IBP, leading to feature vectors of infinite dimensions (even though only a finite number of dimensions is actually active). The following steps summarize this process:

\begin{enumerate}
    \item Generate a feature matrix $\mat{\Theta}_{N \times \infty}$ representing the feature vector of each node: \[\mat{\Theta} \sim \IBP(\alpha)\]
\item Generate a weight matrix for each latent feature:\\
    \[\mat{\phi}_{mn} \sim N(0, \sigma_w), \, m,n \in \mathbb{N}^{+*}\]
\item Generate or not a link between any node $i$ and any node $j$ according to: 
\begin{equation*} \label{eq:link-ilfm}
y_{ij} \sim \mathrm{Bern}(\sigma(\mat{\theta}_{i} \mat{\Phi} \mat{\theta}_{j}^\top))
\end{equation*}
\end{enumerate}
where $^\top$ dentotes the transpose and $\sigma()$ is the sigmoid function, mapping $[-\infty, +\infty]$ values to [0,1], and where $y_{ij}$ is a binary variable indicating that a link has been generated ($y_{ij}=1$) or not ($y_{ij}=0$). We will denote by $\mat{Y}$ the $N \times N$ matrix with elements $y_{ij}$. Finally, $\mat{f}_{i}$ denotes the row feature vector corresponding to the $i^{th}$ row of $\mat{\Theta}$.

This model makes use of two real hyper-parameters, one for the IBP process ($\alpha$), and one for the variance of the normal distribution underlying the weight matrix ($\sigma_w$). In the case of undirected networks, the matrices $\mat{Y}$ and $\mat{\Phi}$ are symmetric and only their upper (or lower) diagonal parts are generated. Lastly, both $\mat{\Theta}$ and $\mat{\Phi}$ are infinite matrices. In practice however, one always deals with a finite number of latent features. A graphical representation of this model is given in Figure \ref{fig_4:mmm} (left).

The MMSB model generates class membership distributions per node on the basis of a Dirichlet distribution. Then, for each connection between two nodes, a particular class for each node is first sampled from the class membership distribution, and the probability of connecting the two nodes is, as in the previous model, based on a Bernoulli distribution integrating the weight of the two classes. 

The non-parametric version \imb\ parallels this development but considers, in lieu of the Dirichlet distribution, a Hierarchical Dirichlet Process, leading to the following generative model:

* Generate the class membership distributions $\mat{\Theta}_{N \times \infty}$:
   \begin{align}
       \mat{\beta} &\sim \gem(\gamma) \nonumber \\
    \mat{\theta}_i &\sim \DP(\alpha_0, \beta) \quad\text{ for } i \in \{1, \dotsc, N\} \nonumber
   \end{align}
where $\gem$ (named after Griffiths, Engen and McCloskey) denotes the Stick Breaking Process distribution over the set of natural numbers and $\DP$ a Dirichlet Process [@HDP];
* Generate a weight matrix for each latent class from i.i.d Beta distribution:
$$ \phi_{mn} \sim \mathrm{Beta}(\lambda_0,\lambda_1), \, m,n \in \mathbb{N}^{+*} $$
* For any node $i$ and any node $j$, choose a class from their class membership distribution according to a Categorical distribution and generate or not a link according to a Bernoulli distribution:
   \begin{gather*} \label{eq:link-immsb} 
    z_{i \rightarrow j} \sim \mbox{Cat}(\mat{\theta}_i) \ , \quad z_{i \leftarrow j} \sim \mbox{Cat}(\mat{\theta}_j) \\
    y_{ij} \sim \mathrm{Bern}(\phi_{z_{i \rightarrow j}z_{i \leftarrow j}})
   \end{gather*}

We have this time four real hyper-parameters, two for the Hierarchical Dirichlet Process ($\gamma$ and $\alpha_0$) and two for the Beta distribution underlying the weight matrix ($\lambda_0$ and $\lambda_1$). As for the previous model, in the case of undirected networks, the matrices $\mat{Y}$ and $\mat{\Phi}$ are symmetric and only their upper (or lower) diagonal parts are generated; as before again, both $\mat{\Theta}$ and $\mat{\Phi}$ are infinite matrices. A graphical representation of this model is given in Figure \ref{fig_4:mmm} (right).

\begin{figure}[t]
	\centering
	\minipage{0.48\textwidth}\vspace{1cm}
	\scalebox{0.99}{
	\input{source/figures/chap4/ilfrm2.tex}}
	\endminipage
	\minipage{0.48\textwidth}
	\scalebox{0.99}{
		\input{source/figures/chap4/mmsb2.tex}}
	\endminipage
	\caption{The two graphical representations of (left) the latent feature model and (right) the latent class model. The difference between the two graphical structures of models lies in the way representations are associated to nodes: a fixed representation is used in the case of the latent feature model, whereas the representation in the latent class model varies according to the link considered.}
	\label{fig_4:mmm}
\end{figure}

### Settings

In a Bayesian context, the set of hyper-parameters underlying the model considered is known. This set, denoted $\mg$, respectively corresponds to $\alpha$ and $\sigma_w$ for \ifm\ and to $\gamma$, $\alpha_0$, $\lambda_0$ and $\lambda_1$ for \imb. For mixed membership models, the evidence $\p(Y|\mg)$ has no closed form solution. Yet, the random graph $G$ is exchangeable so that, for any permutation $\pi$ on integers, one has:
$$
P((y_{ij})_{i,j\in \mathcal{R}} | \mg) = P((y_{\pi(i)\pi(j)})_{i,j\in \mathcal{R}} | \mg)
$$
and one can generate networks from $\mg$ by following the generative processes described above for \ifm\ and \imb. In this setting, the question we ask ourselves is whether the networks generated from $\mg$ comply with the homophily and preferential attachment effect.

However, the typical use of the above models corresponds to the scenario in which some observations (\textit{i.e.} an existing network, observed till a certain time) are available and are used to estimate $\mat{\Theta}$ and $\mat{\Phi}$ from which new links are created. The estimation of $\mat{\Theta}$ and $\mat{\Phi}$ is based on:
\begin{equation}
    \p(\Theta, \Phi | Y, \mg) = \frac{\p(Y|\Theta,\Phi)\p(\Theta|\mg)\p(\Phi|\mg)}{\p(Y|\mg)}
\end{equation}
and usually makes use of standard Gibbs sampling and Metropolis-Hastings algorithms^[We do not detail the inference of $\mat{\hat{\Theta}}$ and $\mat{\hat{\Phi}}$ here and refer the interested reader to [@ILFM;@IBP;@HDP;@fan2015dynamic].].

In the remainder, we denote by $\mat{\hat{\Theta}}$ and $\mat{\hat{\Phi}}$, for both \ifm\ and \imb, the estimates of $\mat{\Theta}$ and $\mat{\Phi}$ obtained from $\mg$ and $Y$, and furthermore set $\me = \{\mat{\hat{\Theta}},\mat{\hat{\Phi}}\}$. Whether, from the learned parameters $\mat{\hat{\Theta}}$ and $\mat{\hat{\Phi}}$, the new links generated produce networks that comply with the preferential attachment effect is the second question we ask ourselves in this study.

We now propose a formalization of homophily and preferential attachment in social networks and answer the above questions.

## Homophily
\label{sec_4:homophily}

Homophily refers to the tendency of individuals to connect to similar others; two individuals (and thus their corresponding nodes in a social network) are more likely to be connected if they share common characteristics [@mcpherson2001birds;@lazarsfeld1954friendship]. The characteristics often considered are inherent to the individuals and may represent their social status, their preferences or their interests. A related notion is the one of assortativity, that is slightly more general as it applies to any network, and not just social networks, and refers to the tendency of nodes in networks to be connected to others that are similar in some way.

A definition of homophily has been proposed in [@la2010randomization]. However, this definition, which relies on a single characteristic (like age or gender), does not allow one to assess whether latent models for link prediction capture the homophily effect or not. We thus introduce a new definition of homophily:

\begin{definition}[Homophily] \label{def:homophily}
	Let $\mathcal{M}_e$ be a probabilistic link prediction model and $s$ a similarity measure between nodes. We say that $\mathcal{M}_e$ is homophilic under the similarity $s$ iff, $\forall (i,j,i',j') \in V^4$:
\begin{equation}
	s(i,j) > s(i',j')  \implies \pr(y_{ij}=1 \mid \mathcal{M}_e) > \pr(y_{i'j'}=1  \mid \mathcal{M}_e) \nonumber
\end{equation}
\end{definition}
As one can note, this definition directly captures the effect "if two nodes are more similar, then they are more likely to be connected".

Different similarities can be considered, as long as they are based on the proximity of the properties of the nodes considered. In stochastic mixed membership models, these properties are encoded in the latent factors. Indeed, as mentioned before, the factor matrix $\mat{\hat{\Theta}}$ aims at capturing some latent properties of the nodes, whereas the estimated matrix $\mat{\hat{\Phi}}$ captures the correlations between these latent properties. One can thus define, on their basis, a "natural" similarity between nodes as follows:
\begin{equation}
s_n(i,j) = \mat{\hat{\theta}}_{i} \mat{\hat{\Phi}} \mat{\hat{\theta}}_j^\top \nonumber
\end{equation}

It is straightforward that both \ifm\ and \imb\ in the setting $\mathcal{M}_e$ are homophilic with respect to $s_n$. Indeed, $\pr(y_{ij}=1 \mid \mathcal{M}_e)$ increases with $s_n$ for \ifm\ as the sigmoid function is strictly increasing (Eq. \ref{eq:link-ilfm}). Furthermore, marginalizing over the $z$ variables in \imb\ leads to:
\begin{align}
&\pr(y_{ij} =1 \mid \mathcal{M}_e) \nonumber \\
& \quad = \sum_{k,k'} \hat{\phi}_{k,k'} \pr(z_{i \rightarrow j}=k | \mathcal{M}_e) \pr(z_{i \leftarrow j}=k' | \mathcal{M}_e) \nonumber \\
& \quad= \sum_{k,k'} \hat{\phi}_{k,k'} \hat{\theta}_{ik} \hat{\theta}_{jk'} = \mat{\hat{\theta}}_{i} \mat{\hat{\Phi}} \mat{\hat{\theta}}_j^\top \nonumber
\end{align}

Dropping the correlation between latent factors in the natural similarity leads to a new similarity, solely based on the latent factors and defined by $s_l(i,j) = \mat{\hat{\theta}}_{i} \mat{\hat{\theta}}_j^\top \nonumber$ ($s_l$ stands for latent similarity). With this similarity, however, neither \ifm\  nor \imb\ are homophilic. Indeed, let us first assume that $\mat{\hat{\Phi}}$ is null on the diagonal, and strictly positive elsewhere (this can be obtained for both models). For \imb, one has:
\begin{align}
\pr(y_{ij}=1 \mid \me) & = \sum_{k' \neq k} \hat{\theta}_{ik} \hat{\phi}_{kk'} \hat{\theta}_{jk'} \nonumber 
\end{align}
as $\hat{\phi}_{kk} = 0$. Let us now consider $\mat{\hat{\theta}}_i=\mat{\hat{\theta}}_j=(0,1,0)$ and $\mat{\hat{\theta}}_{i'}=(0.5,0,0.5)$ and $\mat{\hat{\theta}}_{j'}=(0,1,0)$. Then, $s_l(i,j)=1$ and $s_l(i',j')=0$. However, $\pr(y_{ij}=1 \mid \me) = 0$ whereas $\pr(y_{i'j'}=1 \mid \me) > 0$. \imb\ is thus not homophilic under $s_l$. The same example, replacing $\mat{\hat{\theta}}_{i'}=(0.5,0,0.5)$ by $\mat{\hat{\theta}}_{i'}=(1,0,1)$, can be used to show that \ifm\ is neither homophilic under $s_l$.

This shows that, for a model to be homophilic, it should be designed according to the similarity at the basis of the proximity between individuals. Both \ifm\ and \imb\ have been designed on the basis of the natural similarity $s_n$, and directly encode the fact that similar nodes, according to $s_n$, are more likely to be connected.  It is furthermore possible to make these models homophilic under $s_l$ by imposing constraints on the weight matrix $\mat{\Phi}$ (and hence its estimate $\mat{\hat{\Phi}}$); for example, considering positive, diagonal matrices with equal values on the diagonal leads to homophilic models. In that case, the latent factors can be interpreted as community indicators, each community being of equal importance. This is in line with what is done in the study presented in [@AMMSB] to find overlapping communities through assortativity constraints in the mixed membership stochastic block model.



## Preferential attachment
\label{sec_4:burstiness} 

As mentioned before, preferential attachement can be global, in which case nodes are connected across communities, and/or local to the network communities. Preferential attachment is reminiscent of a phenomenon called \textit{burstiness}, studied in different contexts [@barabasi_burst]. We introduce here definitions for the local and global preferential attachment effects that are extensions of the definitions for burstiness proposed in [@clinchant2010information] for text collections. We will first study global preferential attachment for the models \ifm\ and \imb\ in the two contexts defined by $\mathcal{M}_g$ and $\mathcal{M}_e$. We will then turn our attention to local preferential attachment.

### Global preferential attachment

Probabilistic models naturally lead to the following generative process for creating links between nodes in a network^[For simplicity in the notation, we consider that nodes can be linked to themselves. Excluding such links does not raise particular problems.]. This process considers all possible pairs of nodes in turn and generates or not a link between them:

\begin{description}
 \item[1.] \textit{For each node $i \in \{1, \dotsc, N\}$},
 \begin{description}
    \item[2.] \textit{For each node $j \in \{1, \dotsc, N\}$},
       \begin{description}
          \item[3.] \textit{Generate a link between $i$ and $j$ with probability $P(y_{ij}=1 | \mathcal{M})$ where $\mathcal{M}$ is either $\mathcal{M}_e$ or $\mathcal{M}_g$}.
       \end{description}
  \end{description}
\end{description}

<!--
\begin{algorithm}[t!]
\caption{Deep $k$-Means algorithm}
\label{algo:train}
\DontPrintSemicolon
    \KwIn{data $\mathcal{X}$, number of clusters $K$, balancing parameter $\lambda$, scheme for $\alpha$, number of epochs $T$, number of minibatches $N$, learning rate $\eta$}
    %$\mathcal{X}, \lambda, \eta, T, m_{\alpha}, M_{\alpha}$}
    \KwOut{autoencoder parameters $\theta$, cluster representatives $\mathcal{R}$}
    %$\theta$, $\mathcal{R}$}
	%\STATE{\textbf{Random initialization of} $\theta$ \textbf{and} $\vect{r}_k, \, 1 \le k \le K$}
	Initialize $\theta$ and $\vect{r}_k, \, 1 \le k \le K$ (randomly or through pretraining)\;
	\For(\Comment*[f]{inverse temperature levels}){$\alpha = m_{\alpha}$ to $M_{\alpha}$} {
		\For(\Comment*[f]{epochs per $\alpha$}){$t=1$ to $T$} {
			\For(\Comment*[f]{minibatches}){$n=1$ to $N$} {
				Draw a minibatch $\tilde{\mathcal{X}} \subset \mathcal{X}$\;
				Update $(\theta, \, \mathcal{R})$ using SGD (Eq. \ref{eq:update})\;
			}
		}
	}
\end{algorithm}
-->

As one can note, this process considers all nodes in turn, from node 1 to node $N$. An indexing, \textit{i.e.} a mapping between nodes and integers in $\{1,\cdots,N\}$, is however arbitrary and conclusions drawn from the above process should be independent of the indexing. As we will see, the results we establish below are indeed independent of the indexing.

For a given node $i$ at step $p$ of the above process, $p$ nodes, from node 1 to node $p$, have been considered and links from these nodes to node $i$ generated or not. We will denote by $d_i^{(p)}$ the degree of node $i$, i.e. the number of links of node $i$, at the $p^{th}$ step of this process. By definition:

\begin{equation} \label{eq:degree_def}
d_i^{(p)} = \sum_{j=1}^p y_{ij}
\end{equation}

As mentioned before, preferential attachment characterizes the propensity of nodes in social networks to connect to nodes that already have a lot of connections and can be stated as \textit{the higher the number of links a node has, the more likely it will get new links}. The following definition directly captures this idea:

\begin{definition}[Global preferential attachment]
In the above setting, a probabilistic model satisfies the global preferential attachment effect iff for any indexing, for any node $i, \, 1 \leq i \leq N$, for any $p, \, 1 \leq p < N$, $P(d_i^{(N)} \geq n+1 | d_i^{(p)} = n; \mathcal{M})$ increases with $n$ ($1 \leq n < p$). If $P(d_i^{(N)} \geq n+1 | d_i^{(p)} = n; \mathcal{M})$ is independent of $n$, the model is said to be neutral \textit{w.r.t.} the global preferential attachment effect. As before, $\mathcal{M}$ is either $\mathcal{M}_e$ or $\mathcal{M}_g$.
\end{definition}

Thus, a model satisfies the global preferential attachment effect if and only if the more links a node $i$ has at some point in the process, the more likely a new link will be created with that node.

For both \ifm\ and \imb, in $\me$, the generation of links are independent of each other. The fact that $n$ links have been created after $p$ steps has thus no impact on the future links to a given node. In $\mg$, as one first needs to generate $\Theta$ and $\Phi$ prior to generate all the links, a similar behavior is likely to be observed. Intuitively thus, both \ifm\ and \imb\ are neutral wrt the global preferential attachment effect. The following property formalizes this intuition.

\begin{proposition} \label{th:mg_glob}
Both \ifm\ and \imb, for both $\mathcal{M}_e$ and $\mathcal{M}_g$, are neutral wrt the global preferential attachment effect.
\end{proposition}

\begin{proof}
We first consider model $\me$. Fix any indexing, a node $i$, $i \leq i \leq N$, and a step $p$, $1 \leq p < N$. One has, $\forall n, 1 \leq n < p$:
\begin{align*}
P(d_i^{(N)} \geq n+1 | d_i^{(p)}=n, \me) &= 1 - P(d_i^{(N)}=n | d_i^{(p)}=n, \me) \\
        &= 1 -P(y_{i,p+1}=0, \dotsc,y_{iN}=0 | \me ) \\
        &= 1 - \prod_{j=p+1}^N P(y_{ij}=0 | \me)
\end{align*}
where the last equality comes from the fact that, in $\me$, links are independently generated. Similarly:
\begin{align*}
P(d_i^{(N)} \geq n+2 | d_i^{(p)}=n+1, \me) &= 1 - \prod_{j=p+1}^N P(y_{ij}=0 | \me) \\
                    &=P(d_i^{(N)} \geq n+1 | d_i^{(p)}=n, \me)
\end{align*}
which shows that both \ifm\ and \imb\ are neutral wrt to global preferential attachment with $\me$.

For $\mg$, it suffices to observe that the above result holds for all $\mat{\Theta}$ and $\mat{\Phi}$, and not only for $\mat{\hat{\Theta}}$ and $\mat{\hat{\Phi}}$, so that:
\begin{equation*}
P(d_i^{(N)} \geq n+1 | d_i^{(p)}=n, \mg) = \int_{\mat{\Theta},\mat{\Phi}} P(\mat{\Theta},\mat{\Phi}|\mg) P(d_i^{(N)} \geq n+1 | d_i^{(p)}=n, \mat{\Theta},\mat{\Phi}) \ d\mat{\Theta} d\mat{\Phi}
\end{equation*}

As the models are neutral with $(\mat{\Theta},\mat{\Phi})$, $P(d_i^{(N)} \geq n+1 | d_i^{(p)}=n, \mat{\Theta},\mat{\Phi}) = P(d_i^{(N)} \geq n+2 | d_i^{(p)}=n+1, \mat{\Theta},\mat{\Phi})$ and thus:
\begin{equation*}
P(d_i^{(N)} \geq n+2 | d_i^{(p)}=n+1, \mg) = P(d_i^{(N)} \geq n+1 | d_i^{(p)}=n, \mg)
\end{equation*}
which completes the proof.
\end{proof}

\vspace{0.1cm}
We now turn to local preferential attachment that deals with the fact that preferential attachment can be also observed within classes of nodes, as exemplified in [@LeskovecBKT08]. The classes we consider here are the latent classes of the stochastic mixed-membership models.

### Local preferential attachment
\label{sec_4:local_me}

Local preferential attachment is a restriction of global preferential attachment at the community level and aims at capturing the fact that the more links a node has in a given community, the more links it will have in the future within this community. The latent classes used in \ifm\ and \imb\ play the role of latent communities gathering nodes sharing unobserved properties. Local preferential attachment can thus be studied in stochastic mixed membership models by studying how preferential attachment is captured within latent classes. This nevertheless entails that the latent classes be set in one way or another, meaning that the question of whether stochastic mixed membership models comply with the local preferential attachment effect only makes sense in $\me$, and not in $\mg$.

For \textbf{\ifm}, the situation wrt to local preferential attachment is very similar to the one for global preferential attachment. This is due to the fact that, in $\me$ (i.e. given $\Theta$ and $\Phi$), a local degree can be defined in the same way as the global degree above.

Considering the same generative process as before, for $\me$ and \ifm, the local degree in class $k$ ($0\leq k\leq K-1$), for a node $i$ such that $\theta_{ik}=1$, is defined by:
\begin{equation*}
d_{i,k}^{(p)} = \sum_{j=1, \theta_{jk}=1}^p y_{ij}
\end{equation*}

Note that if $\theta_{ik}=0$, $d_{i,k}^{(p)} = 0$ for all $p$. This then leads to the following definition for local preferential attachment with \ifm.

\begin{definition}[\ifm\ - local preferential attachment, $\me$]\label{def:locdeg-discrete}
We say that \ifm, in $\me$, satisfies the local preferential attachment effect iff for any indexing, for any node $i, \, 1\leq i \leq N$ such that $\theta_{ik}=1$, and for any step $p, \, 1\leq p < N$, $P(d_{i,k}^{(N)} \geq n+1 | d_{i,k}^{(p)}=n,\me)$ increases with $n$ ($1\leq n < p$). If $P(d_{i,k}^{(N)} \geq n+1 | d_{i,k}^{(p)}=n,\me)$ is independent of $n$, the model is said to be neutral wrt to the local preferential attachment effect.
\end{definition}

As before, we have the following property.
\begin{proposition}
\ifm, with $\me$, is neutral \textit{w.r.t.} the local preferential attachment effect.
\end{proposition}

\begin{proof}
The proof is identical to the first part of the proof of Property \ref{th:mg_glob}.
\end{proof}

\vspace{0.1cm}
For \textbf{\imb} in $\me$, we do not have a direct access to classes, encoded in the $Z$ variables. One can nevertheless define local random variables $y_{ij,k}$ that are 1 if a link is generated between nodes $i$ and $j$ within class $k$ and 0 otherwise. One has:
\begin{align*}
P(y_{ij,k}=1 | \me) &= P(y_{ij}=1 | z_{i\rightarrow j} = z_{i\leftarrow j}=k, \Phi) P(z_{i\rightarrow j}=k|\Theta)P(z_{i\leftarrow j}=k|\Theta) \\
    &= \theta_{ik} \phi_{kk} \theta_{jk}
\end{align*}

The local degree $d_{i,k}^{(p)}$ can then be defined as the expectation of $y_{ij,k}$ over the nodes $1,\dotsc,p$:
\begin{align}\label{def:locdegimb}
d_{i,k}^{(p)} &= \sum_{j=1}^p P(y_{ij,k}=1 | \me) \nonumber \\
    &= \sum_{j=1}^p \theta_{ik} \phi_{kk} \theta_{jk}
\end{align}

As one can note, such a local degree is not necessarily an integer and the definition of the local preferential attachment has to be adapted accordingly. 

\begin{definition}[\imb\ - local preferential attachment, $\me$]
We say that \imb, in $\me$, satisfies the local preferential attachment effect iff for any indexing, for any node $i, \, 1\leq i \leq N$ such that $\theta_{ik}=1$, for any step $p, \, 1\leq p < N$, and for all $\epsilon$ compatible with the domain of definition of $d_{i,k}$ and $x$, $P(d_{i,k}^{(N)} \geq x+\epsilon | d_{i,k}^{(p)} \geq x,\me)$ increases with $x$. If $P(d_{i,k}^{(N)} \geq x+\epsilon | d_{i,k}^{(p)} \geq x,\me)$ is independent of $x$, the model is said to be neutral wrt to the local preferential attachment effect.
\end{definition}

This definition can be seen as the continuous counterpart of Definition\ref{def:locdeg-discrete}. If $\epsilon$ is too large, the probability is null and is independent on $x$, hence the compatibility requirement with the domain of definition of $x$ and $d_{i,k}$. 

Because of the Hierarchical Dirichlet Process underlying the \imb\ model, $\mat{f}_i$ follows a Dirichlet distribution: $\mat{f}_i \sim \Dir((\alpha_0 \beta_k + N_{ik})_{1 \le k \le K})$, with $\mat{\beta}\sim \gem(\gamma)$ and $N_{ik}$ being the number of edges connecting node $i$ through class $k$ (see for example [@teh2006hierarchical]) and $K$ the number of latent classes obtained. The marginals $f_{ik}$ are thus distributed according to a Beta distribution: $f_{ik} \sim \Beta(a_{ik}, b_{ik})$ with $a_{ik} = \alpha_0\beta_k + N_{ik}$ and $b_{ik} = \sum_{k'=1, k' \ne k}^{K} \alpha_0\beta_k' + N_{ik'}$.

The following property displays a sufficient condition on $x$, $\epsilon$, $a_{ik}$ and $b_{ik}$ for \imb\ to satisfy the local preferential attachment.


\begin{proposition}\label{prop:IMBlocal}
Let $F_k^p = \sum_{j=1}^p \hat{f}_{jk}$, $x'=\frac{x}{F_k^p \phi_{kk}}$ and $\epsilon'=\frac{\epsilon}{F_k^N \phi_{kk}}$. In the region where $x$ and $\epsilon$ are such that:
%
\[
F_k^N a_{ik} x'^{a_{ik}-1} (1-\epsilon') > F_k^p a_{ik} x'^{a_{ik}} + b_{ik} F_k^p (1-x'^{a_{ik}}),
\]
%
$P(d_{i,k}^{(N)} \geq x+\epsilon | d_{i,k}^{(p)} \geq x,\me)$ increases with $x$.
\end{proposition}

As one can note, when $F_k^p$ is small (typically in the first steps of the process), then the above condition is likely to be met and \imb\ satisfies the preferential attachment effect. However, when $F_k^p$ gets closer to $F_k^N$ the above condition is no longer met.


\begin{proof}
\end{proof}


We now present an experimental illustration of the above theoretical results.



## Illustration
\label{sec_4:exps}

To illustrate our theoretical results, we evaluate the predictive performance and the ability of the models to capture the preferential attachment on artificial and real networks. In order to evaluate this property we used several measures.

The measures considered to evaluate the preferential attachment rely on a goodness of fit. Indeed, it has been reported that preferential attachment leads to networks characterized by a degree distribution with heavy tail drawn from a power law [@barabasi1999emergence]. A graphical method, most often used to verify that the observations are consistent with this law consists in constructing the histogram representing the degree distribution and if the plot on doubly logarithmic axes approximately falls on a straight line, then one can assume that the distribution follows a power law. Thus, the comparison of the degree distribution in the log-log scale with a linear function gives us a qualitative measure for the preferential attachment. To obtain a second evaluation of the power law hypothesis for the degree distribution, we follow the statistical framework, introduced by [@clauset2009power], for discerning and quantifying power-law behavior in empirical data. This framework combines maximum-likelihood fitting methods with goodness-of-fit tests based on the Kolmogorov-Smirnov statistic. It includes the following steps:


* Estimate the parameters $\alpha$ and $x_\text{min}$ of the power law model. $\alpha$ is the scaling parameter of the law and $x_\text{min}$, the lower bound for the tail. It has been fixed to the smallest value observed in the distributions evaluated, in our experiments to allow their comparisons.
* Using the Kolmogorov-Smirnov (KS) statistic, compute the distance $KS_{obs}$ between the degree distribution obtained on the network with the theoretical distribution corresponding to the power law with the estimated parameters.
* Sample $S$ synthetic datasets from the power law with the estimated parameters. For each sample dataset $s \in S$, compute the distance $KS_{s}$ between the distribution obtained on this synthetic dataset, drawn from the power law, with the corresponding theoretical distribution using the Kolmogorov-Smirnov statistic. 
* Decide how many sample dataset $S$ to use, with a rule of thumb, based on a worst-case performance analysis of the test [@clauset2009power]. To obtain a precision of the $p$-value about $\epsilon$, one should choose $S = \frac{1}{4}\epsilon^{-2}$.
* The p-value is defined as the fraction of the resulting statistics $KS_s, s \in \{1,\dotsc,S\}$ obtained on the samples larger than the value $KS_{obs}$ computed on the network distribution.

If p-value is large (close to 1), then the difference between the data and the model can be attributed to statistical fluctuations alone; if it is small, the model is not a plausible fit for the data and we can not conclude that there is an evidence for the preferential attachment in the network. 
However, as mentioned in [@clauset2009power] high value of the $p$-value should be considered with caution for at least two reasons. First, there may be other distribution that match the data equally or better. Second, a small number of samples of the data may lead to high p-value and reflect the fact that is hard to rule out a hypothesis in such a case.




For local preferential attachment, we follow the same approach as before to compute the $p$-value, the only difference being that the empirical data does not correspond any longer to the global adjacency matrix, but to reduced matrices for each class. The computation of the reduced adjacency matrices varies from one model to the other:

* For \imb, for a given class $k$, the reduced adjacency matrix $Y^k$ is defined by: $y_{ij,k}=1$ if $y_{ij}=1, z_{i\rightarrow j}=z_{i\leftarrow j}=k$ and $0$ otherwise.
* For \ifm, the reduced adjacency matrix $Y^k$ is defined by: $ y_{ij,k}=1$ if $y_{ij}=1 , \theta_{ik}=\theta_{jk}=1$ and $0$ otherwise.


Note that all our experiments where realized in a platform that we developed and maintain in order to help reproducibility of machine learning experiments. It is available online^[https://github.com/dtrckd/pymake] under a GNU GPL license.

### Datasets

To illustrate the above developments, we consider two artificial and two real networks, the characteristics of which are summarized in Table \ref{table:networks_measures}.

\input{source/tables/net_measures}

The non-oriented artificial networks (Network1 and Network2) have been generated with the DANCer-Generator [@largeron2015]. This generator has been chosen because it allows one to build an attributed graph having a community structure as well as known properties of real-world networks such as preferential attachment and homophily. In order to test link prediction models on different types of networks, Network1 was generated, by design, to comply with preferential attachment whereas Network2 was not.

The first real network, denoted Blogs^[moreno.ss.uci.edu/data.html\#blogs], contains front-page hyperlinks between blogs in the context of the 2004 US election. A node represents a blog and an oriented link represents a hyperlink between two blogs. The second one, denoted Manufacturing^[www.ii.pwr.edu.pl/~michalski/index.php?content=datasets\#manufacturing], is an internal email communication network between employees of a mid-sized manufacturing company. Each node is associated to an employee and an oriented link represents an email sent between the two employees. One can notice that the second network is specific since it is an enterprise network in which the relationships between the employees are (professionally) constrained. This means that this network is less likely to display some of the properties that occur in unconstrained social networks.

The adjacency matrices and global degree distributions of these networks are presented in Figure \ref{fig_4:corpuses}. This figure allows us to visualize some characteristics of the networks such as their density and their clustering patterns: as one can note, Blogs and the two artificial networks (Network1 and Network2) have a clear community structure, corresponding to the blocks of white dots on the figure, whereas Manufacturing, the denser network, does not have such a structure. Furthermore, the log-log scale plots show that Network1 and Blogs verify the global preferential attachment (the fitted line represents relatively well the data points) whereas neither Network2 nor Manufacturing verify it. This is confirmed by the $p$-values reported in the first section of Table \ref{table:me_gofit} (Training Datasets): the $p$-value is 1 for Network1 and Blogs, whereas it is null for Network2 and Manufacturing. The parameter $\alpha$ reported in Table \ref{table:me_gofit} corresponds to the parameter of the estimated power law distribution (\textit{i.e.} the slope of the best fitting line in log-log scale).

Figure \ref{fig_4:synt_graph_local} represents the local degree distributions for all networks, each curve in each plot being associated to a different class. As the ground truth is not available for the real networks (Blogs and Manufacturing), classes have been determined with Louvain algorithm [@Blondel2008] and the local distribution defined according to the obtained classes. As one can note, the plots for Network1 and Blogs are linear for the most frequent degrees, whereas the plots for Network2 and Manufacturing do not display any clear linearity, suggesting that Network1 and Blogs satisfy, at least partly, local preferential attachment whereas Network2 and Manufacturing do not. This is confirmed by the $p$-values reported in Table\ref{table:me_gofit}: the $p$-value equals $1$ for Network1 and Blogs, $0$ for Network2 and $0.4$ for Manufacturing.

\begin{figure}[h]
    \centering
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/network1_dd}
        \end{minipage}
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/network2_dd}
        \end{minipage}
        %\vskip\baselineskip
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/blogs_dd}
        \end{minipage}
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/manufacturing_dd}
        \end{minipage}
	\caption{Adjacency matrices (left) and global degree distributions (right) for the four training datasets. In the adjacency matrices, a white dot corresponds to a 1 and a black dot to a 0.}
	\label{fig_4:corpuses}
\end{figure}

\begin{figure}[h]
    \centering
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/network1_1}
        \end{minipage}
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/network2_1}
        \end{minipage}
        \vskip\baselineskip
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/blogs_1}
        \end{minipage}
        \begin{minipage}{0.48\textwidth}
            \includegraphics[width=\textwidth]{source/figures/chap4/corpus/manufacturing_1}
        \end{minipage}
        \caption {Local degree distributions for the four training datasets. For Network1 and Network2 the classes come from ground-truth. For Blogs and Manufacturing, classes are obtained with a Louvain algorithm.} 
	\label{fig_4:synt_graph_local}
\end{figure}

### Homophily 

Figure \ref{fig_4:homo_mustach} presents boxplots describing the distributions of the natural $s_n(i,j)$ and latent $s_l(i,j)$ similarities computed respectively on linked and non-linked pairs of nodes for \imb\  (top) and \ifm\ (bottom). The results have been aggregated over the four datasets. They confirm that the natural similarity is  higher for pairs of nodes which are linked than for pairs of nodes which are not   linked, for both models. For the latent similarity,  there is no difference between the linked and non-linked pairs, indicating that the links are not homophilic. These experimental results are in line with the theoretical results presented in Section\ref{sec_4:homophily} that state that both \ifm\ and \imb\ are homophilic for the natural similarity but are not homophilic for the latent similarity.

\begin{figure}[h]
\centering
	\begin{minipage}{0.48\textwidth}
	\includegraphics[width=\textwidth]{source/figures/chap4/corpus/homo_mustach_immsb}
	\end{minipage}
	\begin{minipage}{0.48\textwidth}
	\includegraphics[width=\textwidth]{source/figures/chap4/corpus/homo_mustach_ilfm}
	\end{minipage}
\caption{Natural and latent similarities aggregated over all datasets and computed on linked and non-linked pairs of nodes for \imb\ (top) and \ifm\ (bottom).}
\label{fig_4:homo_mustach}
\end{figure}

### Preferential attachment in $\me$

For each dataset, we estimated the model parameters through a Markov Chain Monte Carlo inference consisting of 200 iterations. For \imb, the concentration parameters of HDP were optimized using vague gamma priors $\alpha_0 \sim \text{Gamma}(1,1)$ and $\gamma \sim \text{Gamma}(1,1)$ following [@HDP]. The parameters for the matrix weights $\lambda_0$ and $\lambda_1$ were fixed to 0.1. For \ifm, the hyper-parameter $\sigma_w$ was fixed to 1 and the IBP hyper-parameter $\alpha$ to 0.5. <!--in order to have comparable number of classes with \imb.-->
Once the models have been learned, they are used to generate links (or non-links) between the entire set of network nodes. The whole procedure is repeated 10 times and the average values are reported as final results.

\input{source/tables/preferential_attachment}

#### Degree distributions

Table \ref{table:me_gofit} reports the value of the power-law goodness of fit for \imb\ and \ifm\ in the global case (left) and in the local case (right). The precision of the test was set to $\epsilon = 0.03$. It appears that for both models, the global preferential attachment is only verified for networks generated from datasets where the property was observed, namely in Network1 with p-value equal to 0.9 for \imb\ and 1 for \ifm, and in Blogs with a p-value equal to 1 for both models; the property is not verified in Network2 and in Manufacturing, where the p-values are equal to 0. This is in accordance with Proposition 2.1 according to which both \ifm\ and \imb\ do not satisfy global preferential attachment. However, these models are able to capture this property if it exists in the training datasets. Moreover, one can observe that, in the local case, \imb\ complies with the preferential attachment with $p$-values equal or close to 1 for the four networks, while \ifm\ obtained low p-values for the networks that were less locally bursty (respectively 0 for Network2 and 0.3 for Manufacturing). In addition, the power-law coefficients $\alpha$ are significantly greater for \imb\ than for \ifm, and specially for the bursty networks Network1 and Blogs.

Figure \ref{fig:me_local} illustrates the local preferential attachment for Network1 (top) and Network2 (bottom) estimated with \imb\ (left) and \ifm\ (right). The shape of the local degree distributions appears more linear for \imb\ and with more fluctuations for \ifm. This illustrates the fact that \ifm\ does not capture local preferential attachment whereas \imb\ does, as stated in Proposition \ref{prop:IMBlocal}. 

\input{source/figures/chap4/corpus/me_deg}


#### Generating process
In Figure \ref{fig:burst_immsb} and \ref{fig:burst_ilfm} we show respectively for IMMSB and ILFM the evolution of the local preferential attachment following the definition given in section \ref{sec_4:local_me}, for the networks Manufacturing and Networks1 and for two different values of the generating process at step $p$ ($p$ is given as a percentage of $N$ in the plots). For IMMSB one can see on figure \ref{fig:burst_immsb}, that the probability of generating new links increases with the degree. However, for ILFM, one can observe, on figure \ref{fig:burst_ilfm}, some classes where the preferential attachment is no true such as for the class 3 in Manufacturing where the probability to generate new links decreases with the degree or contains some plateau. For Networks1, the probability to generate new links increase in average because the model is fitted with a networks where the preferential attachment is present. However, on can see that the increase of the probability is not as clear than for IMMSB. The value of the probability fluctuate and reach some plateau. The interpretation of these results with regard to the properties that we asses for the local preferential attachment is that IMMSB is better adapted than ILFM to capture the local preferential attachment.


\begin{figure}[h]
\centering
\input{source/figures/chap4/burst_mmsb}
\end{figure}

\begin{figure}[h]
\centering
\input{source/figures/chap4/burst_ilfm}
\end{figure}

#### Performance evalutation


In Figure \ref{fig_4:auc}, we compare the performance of the models for predicting new links using the Area Under the Curve (AUC) measure as a function of the training set size. In the bottom plot, the y-axis gives the relative performance defined as the difference of the AUC values for \imb\ and \ifm\ ($AUC_{\imb} - AUC_{\ifm}$) whereas the x-axis indicates the percentage of links randomly removed from the datasets and used as test examples. Hence, the number of training data decreases with the x-axis and a positive value on the y-axis indicates that \imb\ outperforms \ifm. The relative performance corresponds to the difference of the best AUC values obtained for both models on the 10 inference experiences. The top plots illustrate a case where 75 percent of the data is used as test set and where \imb\ dominates \ifm\ on Network1 (left), and the opposite on Network2 (right).

In general, as shown in the bottom plot, \ifm\ obtains better performance than \imb. However, the relative predictive performance of \imb\ increases when the quantity of training data decreases on bursty networks, whereas for non-bursty networks the results are the opposite: the performance of \ifm\ increases when the size of the learning dataset decreases. This is particularly visible for Network2. The results for Manufacturing are less marked, which is certainly due to the small size of this network, making the prediction less challenging.

The above behavior can be explained by the fact that \imb\ satisfies the local preferential attachment whereas \ifm\ does not: as links are randomly removed, one is more likely to remove links from large classes than from small ones; a model that enforces local preferential attachment on bursty networks is thus more likely to reconstruct those removed links. This is what is happening on Network1 and Blogs for \imb. On the contrary, for non-bursty networks, a model enforcing local preferential attachment is penalized.

\begin{figure}[ht]
\centering
    \begin{minipage}{0.48\textwidth}
        \includegraphics[width=\textwidth]{source/figures/chap4/corpus/roc_network1_75_f}
    \end{minipage}
    \begin{minipage}{0.45\textwidth}
        \includegraphics[width=\textwidth]{source/figures/chap4/corpus/roc_network2_75_f}
    \end{minipage}
    \begin{minipage}{0.75\textwidth}
        \includegraphics[width=\textwidth]{source/figures/chap4/corpus/testset_max_20}
    \end{minipage}
    \caption{Top: AUC-ROC curves for Network1 (left) and Network2 (right) with 75 percent of data used for learning that compares the performance of models. Bottom: Relative performance of \imb\ and \ifm\ according to the percentage of data used for testing, the rest being used for learning.} 
\label{fig_4:auc}
\end{figure}


### Preferential attachment in $\mg$

Illustrations in the $\mg$ case are based on the simulation of the models where the parameters $\Theta$ and $\Phi$ have been marginalized out. In other words the degrees that we are going to observe are the expected degree for a large numbers (in the sense of the theory of large numbers) of generated parameters, given the hyper-parameters of the model. In order to simulate this scenario, we generated a large number (100) of networks with a given set of hyper-parameters for the models. Then we reported the average global degree distribution in Figure \ref{fig:mg_deg} (top). For this experiments, fix the number of nodes to 1000. We went trough the generative process 100 times in order to simulate the $\mg$ mode. In order to have a comparable number of classes for \ifm and \imb and block-block probability priors, we fix the hyper-parameters $\lambda_0=\lambda_1=0.5$ for both models, $\alpha=\alpha_0=1$ for \ifm, and $\gamma=0.5$ for \imb.

We see that the global degree distributions are not monotone, with several peaks, and that the range values of the outcome degrees are concentrated in a small segment determined by the hyper-parameters of the models. The shape of the global degree distributions shows that the global preferential attachment is not satisfied. 


In the Figure \ref{fig:mg_deg} (bottom), we also reported a measure on the local preferential attachment in $\mg$. An important note is that, to be able to compute the statistics for the local degree, the latent classes need to be aligned between the different epochs in order to report average values of the local degree distributions. But, the mixed membership models do not defined unique labels over the latent classes. Thus, it is not straightforward to identify the common classes between the generations of the different network realizations. Actually, as the processes are exchangeable, they is no strict correspondence between classes in two independent generative process. Nevertheless, the property of the Dirichlet Process and the Indian Buffet Process, enable to identify the classes by ordering them with their size (or concentration). For example, the stick breaking process interpretation of the DP provides a natural class ordering with a descending (or ascending) order of the class representations. While the IBP generates a row-exchangeable feature matrix, it is possible to reorder the rows to obtain a $\Theta$ matrix where the size of the classes keeps the same descending (or ascending) order.

For the local degree, one can see that, for IMMSB, the shape of the distributions is characteristic of the preferential attachment effect (linear decrease in a log-log space) while it is not the case for ILFM. This experiment is interesting as it show that, for \imb, the local preferential attachment property in $\me$ seems to holds also in $\mg$.

\input{source/figures/chap4/0201/mg_deg}

## Conclusion
\label{sec_4:concl}

We have studied whether stochastic mixed membership models, such as \ifm\ and \imb\, can generate new links while satisfying important properties frequently observed in real social networks, namely the  homophily and preferential attachment. To do so, we have introduced formal definitions adapted for these properties in a global and a local context where edges are either considered across the full network or inside communities. We have analyzed how these models behave according to those definitions. We have shown, in particular, that both models are homophilic with the natural similarity that underlies them.  Concerning the preferential attachment, we have shown that stochastic mixed membership models do not comply with global preferential attachment. The situation is however more contrasted when the property is considered at the local level: \imb\ enforces a partial local preferential attachment whereas \ifm\ does not.

These findings have been validated experimentally on two real and two artificial networks that have different degrees of global and local preferential attachment. An important, practical finding of our study is that \imb, usually considered of lesser "quality" than \ifm, can indeed yield better results on bursty networks (\textit{i.e.} networks with preferential attachment) when the number of training data is limited. 
 
There are many directions to extend this work with the motivation of improving our theoretical understanding of graphical models for link prediction in complex networks. A interesting extension is to examine the relation between the local preferential attachment and the dynamic of the latent classes.

An other direction of interest in the line of this work is to study how the preferential attachment relates to the sparsity of a network and how the exchangeability assumption should be relaxed in order to have models that naturally comply with both the preferential attachment and the sparsity properties.
 


