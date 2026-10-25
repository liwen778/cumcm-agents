% 演示：由 \lstinputlisting{code/q1.m} 从外部文件引入的 MATLAB 代码
% 替换方法：论文中只需把 code/ 下的本文件替换为你的实际代码
%（保持文件名一致），或修改 main.tex 附录B 中引用的路径
disp('Hello LaTeX');            % 控制台输出示例
x = linspace(0, 2*pi, 100);     % 自变量序列
y = sin(x);                     % 因变量
plot(x, y);                     % 绘制曲线
xlabel('x');
ylabel('sin(x)');
title('MATLAB demo');
