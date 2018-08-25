# Complex Network Analysis


## Context of the Study

The study of complex networks is grounded by the graph theory and in particular, for the statistical analysis of networks, by the random graph theory [@albert2002statistical][@Newman03]. The latter approach is particularly well adapted for complex networks because, by definition, their associated graphs haven't a *rigid* topological structure such as being acyclic, complete, or other specific symmetries in their connectivity patterns, or at least, there are not assumed *a priori*. This can be resumed by the statement: *a complex network is governed by simple assumptions*.
Meanwhile, using random structures provides a rich formalism to encode data priors and model the uncertainty through representation (\ref{sec:network_model}) that are sound with the assumptions made on the network [@orbanz2015bayesian].
A major difficulty in modelling complex networks is that there have several degrees of uncertainty in the topological structure and in the law that control their dynamics.
This uncertainty makes the problem of finding a good model to explain the construction of a given network (and make prediction on it) ill-defined.
Besides, there is an other source of uncertainty that comes from the fact that there is no strong consensus about the semantics behind the construction of the networks [@krackhardt1999ties]; what does it means that there exists a connection between two nodes in a network? Why and when a connection is established between two nodes? There is no obvious answer to those questions, and worse, the answer may not be the same depending on the type of the network considered (\ref{sec:network_type}). Even for two networks of similar type, the answer may differ for two different couple of nodes. For example, the notion of friendship in a social network can vary according to the country or the culture considered. Or, for a hyperlink network, such as the Web^[The World Wide Web], a web page could points to another because the content is related in some way, or maybe because it references a sponsor, which are two completely different reasons.
Hence, to face this uncertainty we focus our study on probabilistic models as they provide a natural framework to build powerful and flexible model in this context [@ghahramani15_nature]. 

In the rest of the section, we gives a quick review of the type of networks we are interested in. Then, we recall the basic properties of graphs and the application of interest our context. Finally, we introduce the models and inference scheme that are relevant to our work.


## Network type
\label{sec:network_type}


It exists a large variety of domains in our environment from which networks can arise. Most of us are familiar with certain type of networks that surround us. Especially, since Information Technology and online social networking platform have been widely adopted by the people. Indeed, those platforms that connect people who are friends have somehow democratize the acesss to a number of datasets which are used by, among others, the machine learning community^[See the statistics on https://icon.colorado.edu and http://konect.uni-koblenz.de/]. They also represents great interest for the social sciences for empirical evaluation. Nevertheless, as exposed in this section, there is also other type of network that represents a great interest for other discipline such as the Linguistics and the Natural Language Processing (NLP), but also the Economy, the Ecology and the Biology.

More generally, the category of **Social Interaction Networks** type are used to study any kind of relation between individuals, humans or not, or other type of entities. Here is a non exhaustive list of such networks:

* *Social networks*: They represent set of entities with some relationship pattern between them. The pattern can be the friendship between individuals or business relation between company for example. They are the most representative networks in term of available datasets and academic research [@kunegis2013konect][@Newman03].
* *Communication networks*: They represent communication pattern between entities. The pattern takes usually the form of a message or information delivered from a sender to a receiver. Such networks can be built from email exchange in a company [@klimt2004enron] or from phone call patterns [@aiello2001random] for example.
* *Economic networks*: They represent transaction pattern between entities. Such transactions can take the form of user ratings of movies [netfilx], user clicks over web content, or again, interaction based on money loan []. Those networks have gain particular attention in the Recommender System community [].
* *Sexual contacts*: Networks of sexual relation between individuals have also attracted some attentions [@liljeros2001web].

An other important source of networks resides in the relations that can be extract from textual content or document. This type of networks are called **Information Networks** (sometimes called knowledge networks) and the semantics behind their construction is strongly connected to the format used to represent the documents:

* *Citation networks*: The entities are documents and relations are the citations between them. The academic papers citations is the most studied representative of these networks [].
* *Collaboration networks*: The entities are individuals and there is relation between them if they collaborated on a paper. These network are also often studied though academic paper collaboration [].
* *Hyperlink networks*: The entities are web-pages and the relation between them are the hyperlinks. Those networks arise from the web, and often represent a small region of it such as the hyperlinks in a set of related blogs [], or again the hyperlink en the Wikipedia website [].
* *Lexical networks*: The entities are words and a relation can be built in several ways between them. For example, a relation can be present if two words are consecutive [] or alternatively if they co-occurs in a document []. 
* *Ontologies*: Those networks, also called *Knowledge Graph*, are used to represents the relations between concepts, data, and entities that substantiate one or many domains. There also often used to formalize the structure of databases as a means to describe its semantics [].

Aside from social individuals or textual documents, a source of interconnected entities arise from technological devices. They form the **Technological Networks** who are man-made networks of resources such as the electricity power grid [], the internet as the network of internected physical machines, or the networks of roads that connect cities [].

The last type of networks that are also abundant in our environment, are the **Biological Networks** who are used to represent the relations between biological structures. Those networks can again be divided into two distinct sub-types. The first concerns interaction between organisms (exogenous relations) in a environment (sometimes called Ecological network) such as *predator-prey networks*, which are used to represent food-web, where nodes are the species and the edge indicates feeding relations [@lafferty2006parasites][@thompson2000resolution]. The second sub-type concerns interaction inside an organism (endogenous relation). Major examples of those are *metabolic network* that represent the functionning of cells at a chemical level [@jeong2000large][@stelling2002metabolic]. The *protein interation* networks who map physical interactions that proteins can have together [@maslov2002specificity]. Or, the *gene regulatory* networks that express the relations between genes and protein production [@guelzim2002topological][@kauffman1992origins]. Lastly, *neural networks* constitute a very important class of networks and though very difficult to measure, due to brain access, they have been investigated in [@sporns2002network].


Note that some of the network types can overlap in some case as there is no strict definition of their boundaries.
Furthermore, the classification of type of networks presented here are based on the *nodes* similarities of the graph. But, a classification based on the *edges* similarities (i.e. the similarities between the pattern of interactions) can suggest different classification choices.
Recently, interesting metrics have also been proposed in order to automatically construct taxonomies of networks [@onnela2012taxonomies].

However, it is important to mention that because a majority of the class of networks presented here share some structural properties such as being scale-free or sparse \ref{network_property}, it mays seems appealing to consider the presence of such properties as an element of carachterisation of real-world complex networks. However, there are some exceptions that are worth to mention to weaken the idea of considering these properties as universal. Indeed, it has been shown that most food webs appear to be dense [@dunne2002food] and it may also be true for other biological networks such as Metabolic network [@Newman03]. In general, Biological and Technological network may exhibit specific properties that require different expert knowledge from Social and Information networks. In the following, we will specifically focus on properties and application that mainly concern these last two types of networks.


### Datasets

Networks have been collected in recent years by some university and researchers to provide clean repository of datasets and helping the research in networks science and the reproducibility of experiments. 

The Stanford Network Analysis Project (SNAP) provide various useful resources to the community, such as events, tutorial, publication and datasets^[\url{https://snap.stanford.edu/data/index.html}] [@snapnets].
Some datasets are provided by ^[\url{http://vlado.fmf.uni-lj.si/pub/networks/data/}] [@pajekdataset]. The University of California maintains a repository with links to list of datasets curated by individuals^[\url{https://networkdata.ics.uci.edu/resources.php}]. The page of Tore Opsahl contains list of social networks datasets^[\url{https://toreopsahl.com/datasets/}].

More recently, an effort has been done to build and maintains an index of the existing network dataset found in the literature. They also provide descriptions, statistics and source references. There is two projects that provide such indexes:

* The KONECT (the Koblenz Network Collection) by the University of Koblenz–Landau^[\url{http://konect.uni-koblenz.de}] [@kunegis2013konect].
* The ICON project based at the University of Colorado Boulder^[\url{https://icon.colorado.edu}] [@icon].


## Network Properties
\label{sec:network_property}

We will first provide some basic definitions use throughout the manuscript, and then recall some of the properties find in real-world networks. The table \ref{table:net_terms} recall the basic terminology of networks analysis.

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
**Graph.** We can represent a network by a graph. A graph $G$ is defined by a set of nodes $V$ and a set of edges $E$ such that $G=(\V,\E)$. We denotes the number of nodes as $N=|\V|$ and the number of edges as $E=|\E|$. A graph may be *directed* or *undirected* and may contains *self-loop* or not. For directed graph with self-loop, the number of possible edge is $N^2$ and for undirected $\dbinom{N}{2}$.
The properties that we will examine will be on directed graph unless we specify otherwise. A graph may be binary or weighted. For binary graph, let $\yij$ indicates the presence or absence of an edges with $\yij=1$ if there is an edge between $i$ and $j$ and $\yij=0$ otherwise. For weighted graph, let $\yij$ indicate the weight between $i$ and $j$ --- for instance the number of call in a communication network, or the number of links in a hyperlink network. The *adjacency matrix* of a graph $G$ is the matrix element $\yij$ where nodes are in rows and columns and denoted $Y=(\yij)$. For each node $i$, let $d_i$ be its degree defined as the number of adjacent edges of $i$, such that $d_i = \sum_{j\in \V} \yij$. Graph can be *unipartite* or *multipartite*. For multipartite graph, they are multiple classes of nodes and edges are drawn only between nodes of different classes --- for instance, a bipartite graph can be a movie rating networks where edges represent the ratings of movies by individuals. We will only consider unipartite graph in the following wich traduce by square adjacency matrix os size $N\times N$. For undirected graph, the adjacency matrix is symmetrix such that $\yij=y_{ji}$. 
<!--The adjacency matrix provide a convenient way to visualize large graph as illustrated in figure \ref{fig:graph_adj}. -->

Additionally, a graph can be *multi-relational* where the edges can belongs to several classes. In this case, the graph is represented by an adjacency tensor.
However, in this work, we will focus only on *uni-relational* graph.

Finally, a graph can be *dynamic* (sometimes call temporal or time-varying network) if one or several of its characteristic can evolve over time. This can translate into a birth and/or death process for both nodes an edges. A dynamic graph $\Graph$ can be represented by a sequence of graph snaphsots $\Graph=(G_1, G_2, G_3,...)$ where each graph $G_t$ represents the network at a time step $t$.


In the next section, we will introduce the emerging properties that are often observed in real-world networks.

### Community Structure

Clustering is the task of grouping a set of objects in such a way that objects in the same group (called a cluster) are more similar (in some sense) to each other than to those in other groups (clusters).
In the context of network analysis, the clustering task concerns the grouping of nodes into groups accoring to a given similarity measure that in general based on topological properties of the network. Thus ,the choice of the right similarity measure is crucial to capture the desired properties. 

* but what we observed is that community structure is a properties that arise in number of complex network, and especially social networks.



Nodes in real-world networks 

community structure and structural equivalence

### Homophily

### Burstiness

* and and bursty phenomenon.
* heavy tailed and power law (and sparsity)
* scale-free
* preferential attachment

<!--

+ see also triangle power law (source?)
+ see also eigen value power law (class burstiness)

-->

### Small-world effect


## Applications
\label{sec:network_application}

Applications of network analysis aims at develloping models and algorithms to performs various kind of tasks. Those tasks can be divided into two opposite categories:

* *Generative based*: Here the objective is to generate networks according to a model. Applications include the devellopment of simulator that can be used for visualization purpose or to provide synthetic datasets for the scientific communities. The challenge of this problem is to generate graphs that have relevant properties according to the type of networks we want to simulate.
* *Learning based*: Where the goal is to build models and algorithms that can extract knowledge from a given network (dataset) and predict future outcomes. The challenge here is twofold; the first is to make accurate prediction and the second is to scale the algorithms to large networks.

In this thesis, we focus on learning based applications. Specifically we are interested in two sub-task that has been widely studied in the literature, namely the *community detection* and the *link prediction*.


### Community detection

*Community detection* is a task that consists of solving a clustering problem where one tries to find the best partition of the nodes according to a given criterion generally based on the network structure [@DBLP:journals/corr/abs-1708-00977]. In general, this criterion is a means of identifying *communities*. A standard criterion in this direction is the **modularity** with an optimisation method originally proposed through a greedy algorithm [@newman2004finding]. Recently, alternative version of the modularity with scalable optimization methods have been proposed such as simulated annealing approach and the Louvain algorithm [@ChenKS14]. 
A concurent approach, is the clustering of networks in the context so-called *block models* [@breiger1975algorithm][@white1976social], which are essentially just partitions of the nodes into blocks (or classes) according to a criterion. The advantage of block modeling is that it offers more flexibility in the definition of the criterion than the modularity based approaches as they can be augmented with more prior knowledge as exposed in section \ref{sec:mmsb}. The relation between block modeling and modularity has been studied in [@bickel2009nonparametric] and notably they established under what conditions theirs respective objcetif are consistent.

<!-- define formally the modularity ? -->
<!-- Says what the relation between, theorem ? (is the theorem beautiful, general enough?  -->

### Link prediction

In the *link prediction* task, one assumes a partially oberved networks with missing links. The goal is then to predict the missing links, that is, to predict if either an edge exists or not between unobserved relations between nodes [@lu2011link]. In the case of weighted graphs, the prediction concerns the number of edges or the weights between two nodes. In the learning based context, there is two major approaches to solve this problem^[Other Standard non learning based approach rely on had-hoc similarity measures that uses topological properties of nodes such as common neighborhood, short paths, or other [@LibenNowell07]]. The first is based on matrix factorizations techniques [@menon2011link] and the second on latent variable models [@wang2015link], also referred to as probabilistic models. The latter is the approach pursued in the thesis^[Note that the two approaches are closely related as most of the times one a matrix factorization model can equivalently interpreted in terms of probabilistic model. This question is also related to frequentist vs bayesian reasonning debate.].

<!--
* evnetually, present similarity based methode >= o(n^2). 
* the optimization problem for matric optimization
* the optimization probleme for probabilistic model.
=> whiy we choose pr => very general framework. sound mathematical framework. Unified representation.
-->


### Other applications

Though not in the scope of this thesis, it is worth to mention another important application which consist of studying the *diffusion processes* in networks. From the diffusion of innovations to the spread of dissease, or more generally, the propagation of information between network members, the question is to identify the impact of the structural properties on the diffusion process and localize the regions that either maximize or mimize the latter [@zhang2016dynamics][@pei2013spreading].

Another related application is the exploitation of the graph topology for *Information Retrieval*. Canonical example rely on random walk which is at the basis of the Page-Rank algorithm used by search engine to extract relevant web pages on the web [@kleinberg1999authoritative][@page1999pagerank].



## Summary

* we review some of the important properties that arise in real world networks, neverthess, other properties have been studied and are not present in this paper.
* we precise the type of network to which this work and review some important of the properties that caracterise social and information networks.
* We discuss the application of network analysis and the different modeling and algorithmic existing approaches. In this context, the model of interest (probablistic) are apealing because i) they can run on the two mode; generative based and learning based, and ii) they can answer several type a question. In particular, once the model inference is performed, they can be used for community detection as well as link prediction.

