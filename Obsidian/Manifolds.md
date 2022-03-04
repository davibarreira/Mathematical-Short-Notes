# Análise Geométrica em Julia

Nesse capítulo iremos mostrar como podemos realizar análises geométricas utilizando Julia.
De maneira mais específica, vamos mostrar como trabalhar com Manifolds (variedades) e malhas.
Um Manifold generaliza nossa intuição de objetos geométricos, enquanto malhas são muito utilizadas
como uma maneira de representar de forma aproximada um objeto geométrico.

Julia possui os pacotes Manifolds.jl e ManifoldsBase.jl que nos permitem trabalhar de forma abstrata com Manifolds
sem nos preocupar em definir toda a estrutura de dados necessária. Para malhas, utilizaremos
o pacote Meshes.jl.

O conteúdo se baseia neste curso de [Shape Analysis](https://groups.csail.mit.edu/gdpgroup/6838_spring_2021.html) ministrado
pelo professor Justin Solomon.

## 1 - Teoria Básica de Manifolds

Antes de entrar no código, vamos fazer uma breve revisão dos conceitos básicos envolvendo Manifolds
(em português Manifolds são chamados de Variedades, porém, utilizaremos o termo em inglês, pois é o nome dos pacotes em Julia).
Aqui, nos baseamos principalmente no livro "Introduction to Manifolds" (Tu).

Primeiro, o que é afinal um Manifold? De forma informal, um Manifold nada mais é que a generalização do conceito de Curva, Superfície
ou "Sólidos". A primeira vista, pode parecer algo fácil de se definir, mas não é. Antes de definir formalmente um Manifold, que tipo
de objeto geométrico **não** seria um Manifold? Um bom exemplo é uma mesa. Ao modelar um objeto 3D como uma mesa, podemos ser tentados
a modelar primeiro as quatro pernas, para então "encaixá-las" sob o corpo retangular da mesa. Esse objeto construído desta forma
não seria um Manifold. Porém, se invés disso construíssemos a mesa primeira pegando um enorme toco de madeira e esculpíssemos, nesse
caso ela seria um Manifold... Ou seja, a idea de uma Manifold tem relação com a continuidade da nossa superfície, e com o fato que podemos,
por exemplo, dizer sob qual face estamos. Note que na mesa construída em partes, ao colar as pernas, estamos colando duas faces juntas.

Segundo ponto a se observar é que existem vários tipos de Manifolds. Temos os Manifolds topológicos, analíticos, complexos.
Vamos começar pelos topológicos. Para isso, enunciaremos algumas definições para refrescar a memória.

### 1.1 - Manifolds Topológicos

**Def. (Hausdorff Space)** Um espaço topológico $X$ é Hausdorff se para todo
$x,y \in X$, existem abertos $U, V \subset X$, tal que
$x \in U, y \in V$ e $U \cap V = \varnothing$.

**Def. (Base Topológica)** A base de um espaço topológico $X$ é uma família de abertos $\mathfrak B$ tal que para todo aberto $V \in X$, temos que $V$ pode ser construído como uma união arbitrária de abertos de $\mathfrak B$, ou seja, $V = \cup_{i \in \Lambda} B_i$, onde $B_i \in \mathfrak B$ para todo $i \in \Lambda$.
Além disso, um espaço topológico $X$ é segundamente contável se possui uma base enumerável.

**Def. (Homeomorfismo)** Um homeomorfismo entre dois espaços topológicos $X$ e $Y$ é uma função $f:X\to Y$ bi-contínuo
(bijeção contínua com inversa contínua).

**Def. (Localmente Euclidiano)** Um espaço topológico $M$ é localmente Euclidiano se para todo $p\in M$ existe um aberto
$U$, tal que $p \in U$, e existe um homeomorfismo entre $U$ e um aberto $V \subset \mathbb R^n$ dado por $\phi: U \to V \subset \mathbb R^n$.
Chamamos o conjunto $(U, \phi:U \to \mathbb R^n)$ de carta.

Finalmente, podemos enunciar a definição do nosso Manifold topológico.

**Def. (Manifold Topológico)** Um espaço topológico $M$ é um Manifold se ele for Hausdorff, segundamente contável e localmente Euclidiano.
A dimensão de $M$ é a mesma da dimensão de $\mathbb R^n$ na qual ele é localmente Euclidiano.

