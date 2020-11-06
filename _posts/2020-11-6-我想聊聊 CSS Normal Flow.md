---
layout: post
title: "我想聊聊 CSS Normal Flow"
date: 2020-11-6
excerpt: "基本布局流"
tags: [CSS]
comments: false
---

## Normal Flow 是什么？

Normal Flow 这个名词可能很陌生，在中文翻译中，一般称之为浏览器正常布局流。 虽然中文可能也很陌生，但 Normal Flow 确实是 web 排版的基本规则。如何理解这个基本规则？一句话来说，非浮动、绝对定位的元素都处于浏览器排版的 Normal Flow 中。

Normal Flow 包括 Block Formatting Context(BFC) 和 Inline Formatting Context(IFC)。其中 BFC 已经快变成面试八股文了，BFC 的相关文章甚至比 Normal Flow 的文章都多，而聊 IFC 的文章却极少。然而，在[W3C的相关规范](https://www.w3.org/TR/CSS2/visuren.html#normal-flow)中，IFC所用的篇幅比 BFC 多得多。

任何一个处在 Normal Flow 中的元素，不是在 BFC 中，就是在 IFC 中，取决于元素本身是 block box 还是 inline box。可以理解为 Normal Flow 中的相关定义决定了block 和 inline 两种排版模式。

## BFC 

BFC (Block Formatting Context) 决定了块级元素的排版规则。虽然国内文章对 BFC 的精讲往往一次就是几千字。但是规范中 BFC 的规则很少，可以直接翻译了：
1.  **浮动元素、绝对定位元素、作为块级元素容器而本身非块级的元素、overflow 非 visible 的元素**会建立一个  BFC ，这个元素称为 BFC 容器。
    > 很多同学会疑惑了，我明明背的是 flex, grid, column 也会产生 BFC 啊？其实这是一个长久以来的误会。以 flex 为例，在 W3C 标准中，flex 布局产生的是 Flex Formatting Context(FFC)，但是同时也说了 FFC 除了使用弹性布局方式（而BFC使用按顺序垂直排列），其他特性与 BFC 相同。所以很多文章包括 MDN 就直接写了 flex 产生 BFC。[原文的描述](https://drafts.csswg.org/css-flexbox-1/#flex-formatting-context)如下：
    > *A flex container establishes a new **flex formatting context** for its contents. This is the same as establishing a block formatting context, except that flex layout is used instead of block layout.*
    > 所以大家看到了 Flex 真的不建立 BFC。虽然了解了这种学究小细节确实没什么用，最多是下次讨论 BFC 的时候可以吹吹逼，哈哈。

2. BFC 中的块级元素按顺序垂直排列，相邻块级元素之间的距离被 margin 属性和 [margin collapse](https://www.w3.org/TR/CSS2/box.html#collapsing-margins) 规则决定。

   > 换句话就是说 margin collapse 现象只会发生在同一个 BFC 中。所以国内很多前端教程都会说 BFC 可以用来清除边距折叠，其实是有点理解反了。

3. BFC 中的块级元素左外边(margin 的左边)触及 BFC 容器的包含块左边界，右外边界触及 BFC 容器的包含块右边界。**即使有 float 元素存在也不会影响这个特性，除非块级元素建立了新的 BFC**。

   > 这一点标准里面讲的比较晦涩，可以查看我简单写的这个[codepen 例子](https://codepen.io/excitedqe/pen/BazPJrE)：
   >
   > ```html
   > <h2>Normal block box layout with float left</h2>
   > <div class="BFC_box">
   > <div class="yellow_box" style="float: left"></div>
   > <div class="aqua_box"></div>
   > </div>
   > 
   > <h2>BFC block box layout with float left</h2>
   > <div class="BFC_box">
   > <div class="yellow_box" style="float: left"></div>
   > <div class="BFC_box aqua_box"></div>
   > </div>
   > 
   > <style>
   > /* generate BFC */
   > .BFC_box{
   > outline: 1px black solid;
   > overflow: hidden;
   > }
   > 
   > .BFC_box > div {
   > height: 100px;
   > }
   > 
   > .yellow_box{
   > background-color: rgba(255, 255, 0,0.5);
   > }
   > 
   > .aqua_box{
   > background-color: rgba(0, 255, 255,0.5);
   > }
   > </style>
   > ```
   >
   > ![image.png](http://mk.woa.com/web_api/v1/uploads/202011/C42CF_926_684.png)
   >
   > 在例子中，每个 BFC 都由黑色实线 outline 标注出来。上方是 float 元素与一个普通 block 元素一起布局，可以看见发生了重叠。下方是 float 元素与一个 BFC Block 一起布局，不发生重叠。

另外，在  float 章节中还有一些对 BFC 的补充说明: 

1. 一个 BFC 容器的 border-box 不允许与其中任何 float 元素的 margin-box 有重叠。
也就是大家都知道的清除浮动。
2. [clear 属性](https://www.w3.org/TR/CSS2/visuren.html#flow-control)不能影响其他 BFC 中的浮动元素定位。

在我的理解中，BFC是一个块级布局的基本容器单位。可以从标准的定义中看出W3C尽力想让每个 BFC 相对独立，两个 BFC 容器中包含的元素尽可能不产生布局上的相互影响：
* 让 BFC 完全包含内部的元素
* clear 不能影响其他 BFC 中的浮动元素定位
* 一个建立了新 BFC 的块级元素不与原BFC中的 float 元素相交。

## IFC

不产生 block box 的元素被称为 inline-level 元素，即 inline block，`display: inline` 或 `inline-box`、`inline-table`，替换元素等。所有 inline-level 的元素都参与 IFC (Inline Formatting Context) 布局。 在 IFC 中，最基本的布局方式即：

* 在IFC中，每个元素按顺序水平放置，从包含块的顶部开始，布局中元素间水平方向的 margin、border、padding 生效。**包含这些元素的矩形区域被称为线框(line box)**

  >  包含块是什么？在IFC这里包含块一般确定为包含IFC的最近块级元素。更详细的包含块定义可参考[此链接](https://www.w3.org/TR/CSS2/visudet.html)

  所以我们知道的行内元素垂直方向的margin、border、padding 不生效其实是来自 IFC 的这条布局规则。

除此之外，IFC还有一些比较有趣的规范。我们一一来看看：

*  线框的宽度由包含块和浮动元素的定位共同决定。在没有浮动元素的情况下，线框的左外边(margin-box)与包含块内容左边(content-box)重叠，右外边与包含块的内容右边重叠。有浮动元素的情况下，线框的宽度相应减少该浮动元素的宽度，从而不与浮动元素相交。
  
  > 这条规则也就是定义了行内元素可以“环绕”浮动元素这个行为。而在BFC中，正常情况是普通块级元素会和浮动元素相交。

*  线框的高度总是足够包含其中所有的行内元素，**当行内元素的高度小于线框的高度**时，元素的垂直定位由 [`vertical-align`](https://www.w3.org/TR/CSS2/visudet.html#propdef-vertical-align)属性决定。
  
  > 定义了 `vertical-align` 属性什么时候生效。
  
* **如果线框中的全部元素的宽度小于线框宽度时**，元素的水平定位由[`text-align`](https://www.w3.org/TR/CSS2/text.html#propdef-text-align)属性决定。
  
  > 定义了`text-align`属性什么时候生效。
  
* 如果线框中的全部元素的宽度大于线框宽度时，将会自动断行分裂成垂直方向上多个线框。如果元素定义了不能在垂直方向上断行（例如 white-space 为 `nowarp` 或 `pre`），元素将会溢出。
  
  > 定义了“行内元素溢出”这个行为。所以 `text-overflow` 属性总是和 `white-space: nowarp` 一起出现
  
*  当一个线框被分裂成垂直方向上多个线框的时候，margin, border, padding 在断开的地方没有视觉效果

   > 直接看视觉效果比较明显:
   >
   > ```html
   > <p>
   >   <span>
   >     思消者許去。亞長能流馬願中使年如了讓路續就重白自，也快看久怎民它一正的確該效照公旅電主？
   >   </span>		
   >   <span>
   >     合風安老然得舉的子視名。
   >   </span>
   > </p>
   > <style>
   > span {
   >   margin: 3em;
   >   border: 1px black solid;
   >   }
   > </style>
   > ```
   >
   > ![image.png](http://mk.woa.com/web_api/v1/uploads/202011/D1289_666_220.png)
   >
   > 可以看到，在断行处，margin 和 border 是无效的

之前提到线框的高度总是足够包含其中所有的行内元素，究竟是如何计算的呢？在 [visual model detail](https://www.w3.org/TR/CSS2/visudet.html#line-height) 这一个补充章节， w3c 指出:
1. 计算出线框中的每个 inline-level 元素的高度。行内元素是 `line-height`属性，替换元素是 `margin-box` 高度。
2. 按照`vertical-align`属性将线框中的元素对齐。如果是`top`或者`bottom`，必须以造成线框高度最小的结果进行对齐。
3. 计算出线框高度: 线框中最高元素的上边界和最低元素下边界的距离。

知道了计算的方式，那我们也就知道了在这种规则的约束下，**线框高度可以比最高的行内元素更高**。写一个很简单的例子:

```html
<p>
<span>思消者許去。</span><em>也快看久怎民？</em>
</p>

<style>
em{
  line-height: 34px;
  vertical-align: 10px;
}
</style>
```

![image.png](http://mk.woa.com/web_api/v1/uploads/202011/36E12_440_214.png)

由该例子可以看出，我们定义的最高的行内元素是 `line-height:34px`的`<em>`元素，但整个`<p>`元素但内容高度是38px，因为这是一个单行的线框，所以38px也就是这个单行线框的实际高度。如何做到的？只要用`vertical-align`将元素的基线位置变更即可。
> 很多同学可能又要问了，为什么 line-height 就是行内元素高度呢？也是在 visual model detail 这一个章节的 [`line-height`]()定义中，标准指出:
> On a block container element whose content is composed of inline-level elements, 'line-height' specifies the minimal height of line boxes within the element.

## 相对定位

开篇定义过什么是 normal flow: 
> 非浮动、绝对定位的元素都处于浏览器排版的 Normal Flow 中。

按照这个定义，相对定位(position: relative)的元素也是在 normal flow 中。为什么 w3c 这样定义呢？我们都知道相对定位的元素在原位置也会占位，就好像原位置上有一个一模一样大小的元素，并且是相对原位置进行定位而非相对包含块定位。这个原位置就是 Normal Flow 的布局位置。所以在这个意义上理解，相对定位的元素也是处于 Normal Flow 中。

## 参考
\[1] [Visual Formatting Model - w3.org](w3.org/TR/CSS2/visuren.html)

\[2] [Visual Formatting Model Detail - w3.org](w3.org/TR/CSS2/visudet.html)

