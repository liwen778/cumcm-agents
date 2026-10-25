# 演示：由 \lstinputlisting{code/q1.py} 从外部文件引入的 Python 代码
# 替换方法：论文中只需把 code/ 下的本文件替换为你的实际脚本
#（保持文件名一致），或修改 main.tex 附录B 中引用的路径
print("Hello LaTeX")


def square(n):
    """计算平方（演示文档字符串着色）"""
    return n * n


for i in range(1, 4):
    print(i, "squared =", square(i))
