# Complex Network Analysis


## Context of the study

The study of complex networks is grounded by the graph theory and in particular, for the statistical analysis of networks, by the random graph theory [@albert2002statistical;@Newman03]. The latter approach is particularly well adapted for complex networks because, by definition, their associated graphs haven't a *rigid* topological structure such as being regular, acyclic, complete, or other specific symmetries in their connectivity patterns, or at least, there are not assumed *a priori*. This can be resumed by the statement: *"a complex network is governed by simple assumptions"*.
Meanwhile, using random structures provides a rich formalism to encode data priors and model the uncertainty through representation (\ref{sec:network_model}) that are sound with the assumptions made on the network [@orbanz2015bayesian].
A major difficulty in modelling complex networks is that they have several degrees of uncertainty regarding their topological structure and in the law that control their dynamics.
This uncertainty makes the problem of finding a good model to explain the construction of a given network (and make prediction on it) ill-defined.
Besides, there is an other source of uncertainty that comes from the fact that there is no strong consensus about the semantics behind the construction of the networks [@krackhardt1999ties]; what does it means that there exists a connection between two nodes in a network? Why and when a connection is established between two nodes? There is no obvious answer to those questions, and worse, the answer may not be the same depending on the type of the network considered (\ref{sec:network_type}). Even for two networks of similar type, the answer may differ for two different couple of nodes. For example, the notion of friendship in a social network can vary according to the country or the culture considered. Or, for a hyperlink network, such as the Web^[The World Wide Web], a web page could points to another because the content is related in some way, or maybe because it references a sponsor, which are two completely different reasons.
Hence, to face this uncertainty we focus our study on probabilistic models as they provide a natural framework to build powerful and flexible model in this context [@ghahramani15_nature]. 

Therefore, to build pertinent probabilistic models, one needs to seek and identifies the characteristic properties of the data being modelled, in order to propose suitable assumptions.
In the rest of the section, we gives a quick review of the type of networks we are interested in. Then, we recall the basic properties of graphs before exposing the applications of interest in the context of our study.
<!--Finally, we introduce the models and inference scheme that are relevant to our work.-->


## Network type
\label{sec:network_type}


It exists a large variety of domains in our environment from which networks can arise. Most of us are familiar with certain type of networks that surrounds us. Especially, since Information Technology (IT) and online social networking platform have been widely adopted by the people. Indeed, those platforms that connect people who are "friends" have somehow democratize the access to a number of datasets which are used by, among others, the machine learning community^[See the statistics on https://icon.colorado.edu and http://konect.uni-koblenz.de/]. They also represents great interest for the social sciences for empirical evaluation. Nevertheless, as exposed in this section, there are many different type of networks who represent a great interest for other discipline as well, such as the Linguistics and the Natural Language Processing (NLP), but also the Economy, the Ecology and the Biology.

More generally, the category of **social interaction networks** represents type of networks used to study any kind of relation between individuals, humans or not. Here is a non exhaustive list of such networks:

* *Social networks*: They represent set of entities with some relationship pattern between them. The pattern can be the friendship between individuals or business relation between company for example. They are the most representative networks in term of available datasets and academic research [@kunegis2013konect;@Newman03].
* *Communication networks*: They represent communication patterns between entities. The pattern takes usually the form of a message or information delivered from a sender to a receiver. Such networks can be built from email exchange in a company [@klimt2004enron] or from phone call patterns [@aiello2001random] for example.
* *Economic networks*: They represent transaction patterns between entities and are mostly based on human activities. For instance, one can think about user ratings of movies, user clicks over web content, or again, financial transactions [@bell2007lessons]. Those networks have gained a particular focus in the recommender system community [@burke2002hybrid].
* *Sexual contacts*: Networks of sexual relations between individuals have also attracted some attention [@liljeros2001web].

An other important source of networks resides in the relations that can be extract from textual content or collection of documents. This category is formed by **information networks** (sometimes called knowledge network) and the semantic behind theirs construction is strongly dependant to the format used to represent the documents:

* *Citation networks*: The entities are documents and relations are the citations between them. The academic paper citations is the most studied representative of these networks [@leskovec2007graph].
* *Collaboration networks*: The entities are authors and there is a relation between two authors if they have collaborated on a paper. These networks are also often studied through academic paper collaborations [@yang2015defining;@ley2002dblp].
* *Hyperlink networks*: The entities are web-pages and the relation between them are the hyperlinks. Those networks arise from the web, and often represent a small region of it such as the hyperlinks in a set of related blogs [@adamic2005political], or again the hyperlinks of the Wikipedia website [@preusse2013structural].
* *Lexical networks*: The entities are words and a relation can be built in several ways between them. For example, a relation can be present if two words are consecutive [@newman2006finding] or alternatively if they co-occurs in a document [@leacock1998combining]. 
* *Ontologies*: Those networks, also called *knowledge graph*, are used to represents the relations between concepts, data, and entities that substantiate one or many domains. They are also often used to formalize the structure of databases as a means to describe its semantics [@bollacker2008freebase].

Aside from social individuals or textual documents, a source of interconnected entities arise from technological devices. They form the **technological networks** who are constituted of man-made networks of resources such as the electricity power grid [@watts1998collective], the internet as the network of interconnected physical machines, or the networks of roads that connect cities [@watts1998collective].

The last category of networks that contains also an abundant number of example in our environment, corresponds to **biological networks** who are used to represent the relations between biological structures. Those networks can again be divided into two distinct sub-types. The first concerns interactions between organisms (exogenous relations) in their environment such as *predator-prey networks*, which are used to represent food-web, where nodes are the species and the edge indicates feeding relations [@lafferty2006parasites;@thompson2000resolution]. These networks are sometimes refer to as ecological network. The second sub-type concerns interactions inside an organism (endogenous relation). Major examples of those are *metabolic networks* whose represent the functioning of cells at a chemical level [@jeong2000large;@stelling2002metabolic], *protein interation* networks who map physical interactions that proteins can have together [@maslov2002specificity] or, the *gene regulatory* networks that express the relations between genes and proteins production [@guelzim2002topological;@kauffman1992origins]. Lastly, *neural networks* constitute a very important class of biological networks and, although they are very difficult to measure due to brain access, they could have been investigated as in [@sporns2002network].


Note that some of the network types presented can overlap in some case as there is no strict definition to state to which category a particular network belongs. For example, one could consider that the notion of friendship in a friendship network relates to a communication flow shared between individual and thus, call it an communication network. Or in the opposite, that a email exchange network or even a collaboration network underly some social relations.
Furthermore, the classification of networks presented here are based on the *nodes* similarities of the graph. But, a classification based on the *edges* similarities (i.e. the similarities between the pattern of interactions) could suggest different classification choices.
Recently, interesting metrics have also been proposed in order to compare and classify networks. In [@onnela2012taxonomies], the authors defined a similarity measure to automatically construct taxonomies of networks. Another interesting methodology to compare pair of network was proposed in [@asta2014geometric], where network is approximated by continuous geometric object.


In this thesis, we aim at study general properties that occur in most of the complex networks. It turns out that several properties have been find to emerge in most of the real-world networks, that we briefly reviewed in section \ref{sec:network_property}. 
In particular, it is known that social networks exhibit community structure, power-law degree distributions and are sparse.
However, power-law degree distributions ans sparsity are not verified by all the categories of real-world networks. For instance, it has been shown that most food webs appear to be dense [@dunne2002food] and it may also be true for other biological networks such as metabolic network [@Newman03]. In general, biological and technological networks may exhibit specific properties, that require different expert knowledge than for social and information networks.
Therefore, our work focus primarily on properties that characterise social interaction networks and information networks and, our study and development of models in chapter \ref{sec:mmsb_prop} and \ref{sec:wmmsb} are in this direction as well.


### Datasets

Networks have been collected in recent years by some university and researchers to provide clean repositories of datasets and helping the research in networks science and the reproducibility of experiments. 

The Stanford Network Analysis Project (SNAP) provides various useful resources to the community, such as events, tutorial, publication and datasets^[\url{https://snap.stanford.edu/data/index.html}] [@snapnets].
Some datasets are provided by ^[\url{http://vlado.fmf.uni-lj.si/pub/networks/data/}] [@pajekdataset]. The University of California maintains a repository with links that points to datasets curated by individuals^[\url{https://networkdata.ics.uci.edu/resources.php}]. The page of Tore Opsahl contains a list of social networks datasets^[\url{https://toreopsahl.com/datasets/}].

More recently, an effort has been done to build and maintain an index of the existing network dataset found in the literature. They also provide descriptions, statistics and source references. There is two projects that provide such indexes:

* The KONECT (the Koblenz Network Collection) by the University of Koblenz–Landau^[\url{http://konect.uni-koblenz.de}] [@kunegis2013konect].
* The ICON project based at the University of Colorado Boulder^[\url{https://icon.colorado.edu}] [@icon].


## Network properties
\label{sec:network_property}

We will first provide some basic definitions used throughout the manuscript, and then recall some of the properties found in real-world networks. The Table \ref{table:net_terms} recall the basic terminology of networks analysis.

\begin{table}
\centering
\footnotesize
\caption{Short glossary of terms.}
\setlength{\fboxsep}{10pt}
\fbox{\begin{minipage}{0.8\textwidth}

\hspace{10pt}\emph{Graph}: The mathematical representation of a networks defined in terms of vertices and edges.\vspace{7pt}

\hspace{10pt}\emph{Vertex} (pl vertices): The fundamental unit of a network, also called a site (physics), a node (computer science), or an actor (sociology).\vspace{7pt}

\hspace{10pt}\emph{Edge}: The line connecting two vertices. Also called a bond (physics), a link (computer science), or a tie (sociology).\vspace{7pt}

\hspace{10pt}\emph{Directed/Undirected}: An edge is directed if it runs in only one direction (such as an email sent to a person), and undirected if it runs in both directions. A graph is directed if all of its edges are directed. An undirected graph can be represented by a directed one having two edges between each pair of connected vertices, one in each direction.\vspace{7pt}

\hspace{10pt}\emph{Self-loop}: A self-loop indicate an edge from a vertex to itself.\vspace{7pt}

\hspace{10pt}\emph{Degree}: The number of edges connected to a vertex. Note that the degree is not necessarily equal to the number of vertices adjacent to a vertex, since there may be more than one edge between any two vertices. A directed graph has both an in-degree and an out-degree for each vertex, which are the numbers of in-coming and out-going edges respectively.\vspace{7pt}

\hspace{10pt}\emph{Density}: The density of graph is its number of edges divided by the maximal number of edges.\vspace{7pt}

\hspace{10pt}\emph{Geodesic path}: A geodesic path is the shortest path through the network from one vertex to another. Note that there may be and often is more than one geodesic path between two vertices.\vspace{7pt}

\hspace{10pt}\emph{Diameter}: The diameter of a network is the length (in number of edges) of the longest geodesic path between any two vertices.


\end{minipage}}
\label{table:net_terms}
\end{table}

### Definitions
**Graph.** We can represent a network by a graph. A graph $G$ is defined by a set of nodes $\V$ and a set of edges $\E$ such that $G=(\V,\E)$. We denote the number of nodes as $N=|\V|$ and the number of edges as $E=|\E|$. A graph may be *directed* or *undirected* and may contains *self-loop* or not. For undirected graph without self-loop, the number of possible edges is $\dbinom{N}{2}$.
In general, if not specified, we will consider undirected graph for convenience. A graph may be binary or weighted. For binary graph, let $\yij$ indicates the presence or absence of an edges with $\yij=1$ if there is an edge between $i$ and $j$ and $\yij=0$ otherwise. For weighted graph, let $\yij$ indicate the weight between $i$ and $j$ --- for instance the number of calls in a communication network, or the number of links in a hyperlink network. The *adjacency matrix* of a graph $G$ is a matrix of edge indicators where nodes are in rows and columns denoted $Y=(\yij)_{N\times N}$. For each node $i$, let $d_i$ be its degree defined as the number of adjacent edges of $i$, such that $d_i = \sum_{j\in \V} \yij$. Graph can be *unipartite* or *multipartite*. For multipartite graph, they are multiple classes of nodes and edges are drawn only between nodes of different classes (note that in this case the adjacency matrix is not square) --- for instance, a bipartite graph can be a movie rating networks where $y_{ij}$ represent the rating of a movies $j$ by an individual $i$. However, we will only consider unipartite graph in the following wich traduce by square adjacency matrix of size $N\times N$. For undirected graph, the adjacency matrix is symmetrix such that $\yij=y_{ji}$. 
<!--The adjacency matrix provide a convenient way to visualize large graph as illustrated in figure \ref{fig:graph_adj}. -->

Additionally, a graph can be *multi-relational* where the edges can belongs to several classes. In this case, the graph is represented by an adjacency tensor.
However, in this work, we will focus only on *uni-relational* graph.

Finally, a graph can be *dynamic* (sometimes call temporal or time-varying network) if one or several of its characteristic can evolve over time. This can translate into a birth and/or death process for both nodes an edges. A dynamic graph $\Graph$ can be represented by a sequence of graph snaphsots $\Graph=(G_1, G_2, G_3,\dotsc)$ where each graph $G_t$ represents the network at a time step $t$.


In the next section, we will introduce the emerging properties that are often observed in real-world networks.

### Community structure
<!-- Structral equivalence is more general ! see me) -->

Real-world networks are known to exhibit a modular structure, where nodes group together according to some equivalence relation [@flake2002self;@girvan2002community;@Schwartz92discoveringshared]. Those groups are generally referred to as communities where a *community* is  defined as a set of nodes that are tighter connected to each other than those outside the community. In this case, the nodes are grouped according to an equivalence relation based on their common neighborhood. This approach to defined communities is referred to as _**regular equivalence**_ [@holme2005role].

Nevertheless, networks can also exhibits another form of modular structure based on a different definition of the equivalence relation. Instead of measuring the common neighbors, it measure the pattern of relations between nodes. That is, nodes in the same group are not necessarily tied together but instead, their connectivity to similar nodes are similar [@goldenberg2010survey]. This approach is called _**structural equivalence**_ [@lorrain1971structural] (sometimes called *stochastic equivalence* [@wasserman1994social]) and the groups are generally referred to as *blocks*^[Note that we may also refers to them as *classes* in this manuscipt.] [@leicht2006vertex;@sun2009information].

For formal definitions of equivalence relation in graphs, the reader can refer to [@white1983graph].

<!-- shema of a networks where nodes arge grouped by they regular equivlance, and structural equivalance. -->


### Mixing patterns

Mixing patterns refers to the tendency of certain type of nodes to connect to another type. For example, studies on networks of married and unmarried couples have shown strong correlation between the age of the partner [@garfinkel2002assortative]. In general, this kind of selective linking are based on the nodes attributes or characteristics, which are dependent of the type of network analysed, to measure similarities between them. For social networks, it has been admitted that individuals tend to associate between similar ones in some way. This is known as *assortative mixing* or _**homophily**_ and it has been widely cover in the literature [@la2010randomization;@kim2017effect]. In contrast, when nodes tend to connect to dissimilar ones, the networks is said to be *disassortative* or *heterophilic*. Several metrics has been proposed to measure to what extent a network exhibits assortative (homophilic) mixing patterns that usually rely on some side information about nodes (type, features) are assumed to be know [@newman2003mixing]. A sub-case of assortative mixing consists to measure pair nodes similarity with the network topology information only, such as node's centrality. In particular, the measure of the degree has received some attention [@Newman03], where the idea is to ask if either a node with a high degree prefer to connect to nodes with high degree or low-degree; it appears that both situation can occurs in some networks.

### Preferential attachment

A key element to characterize the structural properties of networks is the study of the repartition of the node degrees. Notably, real-world networks have been found to exhibit degree distributions that lies in the family of *long-tailed* distributions which are a sub-class of heavy-tailed distributions [@clauset2009power]. They represent distributions with heavier tail than the exponential distribution, that is, with a slower decay. This is useful to represent events that are not independent, in contrast with the distribution of independent events that are generally represented by Normal distributions, as a consequence of the central limit theorem^[It concerns i.i.d. events to be precise.]. The slow decay of heavy-tailed distributions is hence in contrast with typical Gaussian distributions that have an exponential decay^[This also the case of the Poisson distribution often used to represents count processes.]. The Long-tailed distributions family includes the power-law and the Pareto distribution among others. A long-tailed distribution is characterized by events (the nodes' degree in a graph for instance) with a high-frequency that concentrate a large part of the population located in the head of the distribution, followed by events with low frequency that gradually decrease asymptotically, called the tail^[In this case we says that the distribution right-tailed, but is can also be left-tailed or both.]. 
This property have been coin in many domain in science, for example in social science, where it has been called the *Matthew effect* in reference to biblical texts of the *Gospel of Matthew* [@merton1968matthew]. In statistics, the phenomenon is often referred to as the *Pareto principle* after the Pareto distribution, where the least frequently occurring items (e.g. the degrees) represent 80\% of the population and the most frequent ones represent only 20\%. Lastly, it has also been discovered in the words distribution of the natural language, and it is know as the *Zipf law* [@zipf2016human].

A proposed explanation of the emergence of fat-tailed distribution of degrees in networks is based on the *preferential attachment effect* which encodes the idea that *the more you have, the more you will get*. It states that a node in the network will attach with higher probability to nodes that have a high degree [@barabasi1999emergence], and leads to the famous Barab\acca{}si-Albert (BA) model that generates networks with power law degree distribution such that $$\p_k \sim k^{-\alpha},$$ where $p_k$ is the probability that a node chosen uniformly at random has degree $k$ and $\alpha$ a constant exponent greater than zero.
Networks with power-law distributions are also referred to as *scale-free* networks as the power-law *"it is the only distribution that is the same whatever scale we look at it on."* [@newman2005power].

<!--
A related notion proposed to characterise long-tailed response in wide range system is the *Burstiness*. 
An other characterisation of this effect have been proposed 
lambiotte2013burstiness
goh2008burstiness
-->



#### Sparsity and scale-free networks

Sparsity is a property observed on most of the real-world networks dataset and means that the number of edges $E$ is very low compared to the network capacity, which naturally increases quadratically with the number of nodes $N$. The question we ask here is how the sparsity is related to scale-free networks? We show that scale-free networks leads to sparse networks if $\alpha > 2$.

Formally we say that a network $G$ is sparse if the following limit is true:
$$
\frac{E}{N^2} \rightarrow 0 \qquad \text{as} \quad N \rightarrow \infty \ .
$$

Let $G$ be a scale-free undirected network of size $N$ with degree distribution $f(k)=C k^{-\alpha}$ with $C$ and $\alpha$ two positive constants. Let $f_k$ be the number of nodes having a degree equal to $k$. The number of edges in the network is then
$$
E = \frac{1}{2} \sum_{k=0}^{\infty} k f_k \ .
$$
Further, when $N\gg0$, we assume that the empirical degree distribution converges towards the true degree distribution such that $f(k) = \frac{f_k}{N}$. Thus one obtains:
$$
E = \frac{NC}{2} \zeta(\alpha-1) \ ,
$$
where $\zeta$ is the Riemann zeta function. Hence, $E$ is not divergent if $\alpha>2$ and in this case, $E$ has a linear growth with $N$ as $E=O(N)$, which results to a sparse network.


<!--
+ see also triangle power law (source?)
+ see also eigen value power law (class burstiness)
-->

### Small-world effect

The small-world effect is an important emerging property that has been found in many real world networks [@watts2004six]. It has been popularized by the well known experiment of Milgram [@travers1967small] in which letters, passed form person to person, were able to reach any individual in a small number of steps. Though, it has been speculated in earlier work [@karinthy1929chains;@de1978contacts].
A major practical implication of the small-world effect in real-world networks concerns the speed of the spread of information.

The phenomenon is related to the slow growth of the geodesic path as the network size increase.
Let us define $L$ as the mean geodesic (i.e. shortest) path between nodes pair in a undirected network:
$$
L = \frac{2}{N(N+1)}\sum_{i<j}d_{ij}
$$
where $d_{ij}$ is the geodesic path from node $i$ to node $j$. Many real-world networks exhibit the small-world effect in the sense that it has been observed that the value of $L$ scale logaritmically or slower with the number of nodes $N$ such as $L \propto \log N$ [@newman2001scientific;@newman2001structure]. Interestingly, Many random graph models are also known to exhibit the small-world effect [@bollobas1981diameter]. Another interesting question concerns the relation between scale-free networks and small-world phenomenon. An highlighting result provided by [@bollobas2004diameter], showed that the networks with power law degree distributions increase no faster than $\log N / \log\log N$.

<!-- conjecture: pref atta + sparsity <=> small world. (should be a corollary of a representation theorem) !!! -->


## Applications
\label{sec:network_application}

Applications of network analysis aim at developing models and algorithms to perform various kind of tasks. They can be divided into two opposite categories:

* *Generative based*: Here the objective is to generate networks according to a model. Applications include the development of simulator that can be used for visualization purpose or to provide synthetic datasets for the scientific communities. The challenge of this problem is to generate graphs that have relevant properties according to the type of networks we want to simulate.
* *Learning based*: Where the goal is to build models and algorithms that can extract knowledge from a given network (or a set of networks) and eventually predict future outcomes. The challenge here is twofold; the first is to make accurate predictions and the second is to scale the algorithms to large networks.

In this thesis, we focus on learning based applications. Specifically we are interested in two sub-task that has been widely studied in the literature, namely the *community detection* and the *link prediction*.


### Community detection

*Community detection* is a task that consists of solving a clustering problem where one tries to find the best partition of the nodes according to a given criterion generally based on the network structure [@DBLP:journals/corr/abs-1708-00977]. In general, this criterion is a means of identifying *communities*. A standard criterion in this direction is the **modularity** with an optimisation method originally proposed through a greedy algorithm [@newman2004finding]. Recently, alternative version of the modularity with scalable optimization methods have been proposed such as simulated annealing approach and the Louvain algorithm [@ChenKS14]. 
A concurrent approach, is the clustering of network nodes in the context so-called *block models* [@breiger1975algorithm;@white1976social], which are essentially just partitions of the nodes into blocks (or classes) according to a criterion. The advantage of block modeling is that it offers more flexibility in the definition of the criterion than the modularity based approaches as they can be augmented with more prior knowledge as exposed in section \ref{sec:mmsb_prop}. The relation between block modeling and modularity has been studied in [@bickel2009nonparametric] and notably they established under what conditions theirs respective objective are consistent.

<!-- define formally the modularity ? -->
<!-- Says what the relation between, theorem ? (is the theorem beautiful, general enough?  -->

### Link prediction

In the *link prediction* task, one assumes a partially observed network with missing links. The goal is then to predict the missing links, that is, to predict if either an edge exists or not between any unobserved relations between nodes [@lu2011link]. In the case of weighted graphs, the prediction concerns the number of edges or the weights between two nodes. In the learning based context, there is two major approaches to solve this problem^[Other Standard non learning based approaches rely on ad-hoc similarity measures that use topological properties of nodes such as common neighborhood, short paths, or other [@LibenNowell07]]. The first is based on matrix factorizations techniques [@menon2011link] and the second on latent variable models [@wang2015link], also referred to as probabilistic models. The latter is the approach pursued in the thesis^[Note that the two approaches are closely related as in some case matrix factorization models can be equivalently interpreted in terms of probabilistic models. This question is also related to frequentist vs Bayesian reasoning debate.].

<!--
* evnetually, present similarity based methode >= o(n^2). 
* the optimization problem for matric optimization
* the optimization probleme for probabilistic model.
=> whiy we choose pr => very general framework. sound mathematical framework. Unified representation.
-->


### Other applications

Though not in the scope of this thesis, it is worth to mention another important application which consists of studying the *diffusion processes* in networks. From the diffusion of innovations to the spread of diseases, or more generally, the propagation of information between network members, the question is to identify the impact of the structural properties of network on the diffusion process and localize the regions that either maximize or minimize the latter [@zhang2016dynamics;@pei2013spreading]. A related notion is the network resilience that evaluates the impact of random deletions of nodes and/or edges, and which can be studied through the percolation theory [@callaway2000network].

Yet another application is the exploitation of the graph topology for *Information Retrieval*. Canonical example rely on random walk which is at the basis of the Page-Rank algorithm used by search engine to extract relevant web pages on the web [@kleinberg1999authoritative;@page1999pagerank].



## Summary

We presented in this chapter several classes of complex networks found in the real-world, and in particular social an information networks on which we focus in this thesis. We review some of the emergent properties that arise in those networks as they constitute observation evidence and will be used to guide our assumptions and evaluations of the network models throughout the next chapters. We also presented the typical applications that concerns network analysis and especially the one we've been considering in our empirical evaluations in chapters  \ref{sec:mmsb_prop} and \ref{sec:wmmsb}.

