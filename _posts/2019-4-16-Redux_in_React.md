---
layout: post
title: "Redux in React"
date: 2019-4-16
excerpt: "设计模式与数据流"
tags: [React]
comments: false
---

# Redux in React

Redux并不是单独为React设计，但很适合React，因为React以state函数的形式来描述界面。

## React Redux

React Redux是桥接React和Redux的绑定库（看名字就知道）。两种引入方法：

1. npm

   ```shell
   npm install --save react-redux
   ```

2. \<script>标签

   ```html
   <script src="https://unpkg.com/react-redux@7.0.2/dist/react-redux.min.js"/>
   ```

## 容器组件和展示组件

React和Redux的绑定基于区分容器型组件和展示型组件，这种方法让App设计更加简单。

- 容器型组件(Container Components)负责监听Redux State获得其数据，向Redux派发action使store数据更新。基本上是靠React Redux自动生成的。一般容器型组件是展示型组件的父组件。
- 展示型组件(Presentatioanl Components)负责真正的View。从上层组件props获得数据，绑定上层组件传入的DOM事件监听回调，不知道Redux的存在。

虽然容器型组件可以手写，使用`store.subscribe()`这些方法一个一个绑定，但最好不要（不然引入React Redux干嘛）。React Redux提供了`connect()`方法使创建容器组件更简单。而且，可以自动判断是否需要重新渲染（手写的话就要用`shouldComponentUpdate()`进行判断），创造一些性能优势。

展示型组件并不知道Redux的存在，给定它一定的props，它就会自己渲染出来最终效果，这种方法便于组件复用。

### 展示型组件例子

均摘自官方例子<https://redux.js.org/basics/example>

```jsx
import React from 'react'
import PropTypes from 'prop-types'

const Todo = ({ onClick, completed, text }) => (
  <li
    onClick={onClick}
    style={{
      textDecoration: completed ? 'line-through' : 'none';
    }}
  >
    {text}
  </li>
)

Todo.propTypes = {
  onClick: PropTypes.func.isRequired,
  completed: PropTypes.bool.isRequired,
  text: PropTypes.string.isRequired
}

export default Todo
```

仅仅接收参数，进行渲染，自己没有状态。

### 容器型组件例子

要用`connect()`方法创建容器型组件，需要先创建两个方法：

- `mapStateToProps`：描述如何将Redux Store中的state转换为要传递给子展示组件的props。

  ```jsx
  //@param state: 代表接收Redux Store的state属性
  //@param ownProps: 可选，代表容器组件的现有props对象
  //@return propsObj: 代表产生的要传给下层展示组件的props
  (state,ownProps)=>propsObj
  ```

- `mapDispatchToProps`：描述如何将dispatch行为（一般是dispatch一个action creator）转换为要传递给子展示组件的props。

  ```jsx
  //@param dispatch: 代表接收Redux Store的dispatch方法
  //@param ownProps: 可选，代表容器组件的现有props对象
  //@return propsObj: 代表产生的要传给下层展示组件的props
  (dispatch,ownProps)=>propsObj
  ```

定义好之后，仅仅需要

```jsx
import { connect } from 'react-redux'

const AppContainer = connect(
  mapStateToProps,
  mapDispatchToProps
)(present);	
//present是子展示组件的根组件，
//present通过props来接收mapStateToProps，mapDispatchToProps定义的props对象
//或者直接是函数组件，在参数里面接收

export default AppContainer
```

以上就是Redux配合React的使用方法，只需要如此就能调用了：

```jsx
import React from 'react'
import AppContainer from '../containers/AppContainer'

//其实只有一个Container，不需要这样做包裹一层div
//但是很多时候为了进一步划分应用，需要不仅仅一个Container
//所以才这样写
const App = () => (
  <div>
    <AppContainer />
  </div>
)

export default App
```

## 传入Store

搞了半天，Redux最关键的store还没传入。当然可以在Container上使用prop一个一个传入，但很多时候不止一个container，写起来比较麻烦，react-redux给了一个语法糖：

```jsx
import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import appReducer from './reducers'
import App from './components/App'

const store = createStore(appReducer);

//相同Provider中的所有Container都被赋予了同一个store
//使用render把View画到页面上
render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);
```



不得不说Redux设计的非常nice，单向数据流逻辑非常通达。事件处理和数据存储逻辑高内聚，而不是像MVC一样分散在各个Model和Controller里面，写起来很爽，实属人间之鉴~