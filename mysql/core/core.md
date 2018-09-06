[MySQL索引背后的数据结构及算法原理](https://www.cnblogs.com/tgycoder/p/5410057.html)
* B-tree
  * d>=2，即B-Tree的度；
  * h为B-Tree的高；
  * 每个非叶子结点由n-1个key和n个指针组成，其中d<=n<=2d；
  * 每个叶子结点至少包含一个key和两个指针，最多包含2d-1个key和2d指针，叶结点的指针均为NULL；
  * 所有叶结点都在同一层，深度等于树高h；
  * key和指针相互间隔，结点两端是指针；
  * 一个结点中的key从左至右非递减排列；
  * 如果某个指针在结点node最左边且不为null，则其指向结点的所有key小于v(key1)，其中v(key1)为node的第一个key的值。
  * 如果某个指针在结点node最右边且不为null，则其指向结点的所有key大于v(keym)，其中v(keym)为node的最后一个key的值。
  * 如果某个指针在结点node的左右相邻key分别是keyi和keyi+1且不为null，则其指向结点的所有key小于v(keyi+1)且大于v(keyi)。
* B+tree
  * 带有顺序访问指针
  * 每个结点的指针上限为2d而不是2d+1
  * 内结点不存储data，只存储key；叶子结点不存储指针
