# OpenSpec
When first time using, run
``` shell
openspec init
```
然后选择我们要使用的coding agents。
Code的部分，它会在我们的repo里新增 .agent/ and openspec/ 文件夹。

## OpenSpec流程
### Core Profile（默认） 的流程
1. `/opsx:propose`

   
2. `Apply`
   xxxxx
3. `Archieve`
   xxxx

### Expanded Profile
#### 开启方法
1. 扩充指令，跑：
``` shell
openspec config profile
```
	会看见：
	Delivery ，表示这些功能装在哪里
	Workflows ， 表示这些功能有哪些

2. 选择 Delivery and workflows 
3. 选择 
#### Expanded Profile 的流程
1. `/opsx:new`
   这个步骤会生成4个文件
   - proposal.md
     说明feature的变更原因和影响的范围。
   - design.md
     记录相关的技术决策。
   - spec.md
     说明这次的变更会影响到的规格差异。 spec.md 会出现在两个地方，一个在 changes/ 里 也被称作 delta spec，只描述这次变更要做什么改动，它只记录差异，并不是完整的规格文件；另一个在 specs/ 里则被称为 main spec ，当 changes 被 archived 后， spec.md 就会被移动到 changes/archive 底下，而 specs/ 低下的 spec.md 是长期维护的规格文件，它是完整的规格，反映目前的系统状态。所有 changes/ 底下的 spec.md 都会整理到 specs/ 底下的 main spec 里。
   - tasks.md
     拆解任务。

## 建立OpenSpec规则
通过AI创建 `openspec/config.yaml` 文件，记录专案使用到的技术和对应要遵守的规则，目标是让 OpenSpec skill 触发时有可以参考的惯例。 

## openspec文件夹结构
openspec文件夹下有两个文件夹：changes 和 specs
1. changes
   changes 记录正常进行中的features。当做完后，就会进行 archive ，把改动的东西送到 specs 文件夹里。
2. specs
   specs 记录这个专案曾经做过的所有改动，也就是已经做完了的任务。