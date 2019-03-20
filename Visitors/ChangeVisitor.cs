using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProgramTree;

namespace SimpleLang.Visitors
{
    class ChangeVisitor : AutoVisitor
    {
        public void ReplaceExpr(ExprNode from, ExprNode to)
        {
            var p = from.Parent;
            to.Parent = p;
            if (p is AssignNode assn)
            {
                assn.Expr = to;
            }
            else if (p is BinOpNode binopn)
            {
                if (binopn.Left == from) // Поиск подузла в Parent
                    binopn.Left = to;
                else if (binopn.Right == from)
                    binopn.Right = to;
            }
            else if (p is BlockNode)
            {
                throw new Exception("Родительский узел не содержит выражений");
            }
            else if (p is WhileNode wnode)
            {
                wnode.Expr = to;
            }
            else if (p is ForNode fnode)
            {
                fnode.Expr = to;
            }
            else if (p is IfNode inode)
            {
                inode.Expr = to;
            }
        }
        public void ReplaceStatment(StatementNode from, StatementNode to)
        {
            var p = from.Parent;
            if (p is AssignNode || p is ExprNode)
            {
                throw new Exception("Родительский узел не содержит операторов");
            }
            if (to != null)
                to.Parent = p;
             
            if (p is BlockNode bln) // Можно переложить этот код на узлы!
            {
                for (var i = 0; i < bln.StList.Count; i++)
                {
                    if (bln.StList[i] == from)
                    {
                        bln.StList[i] = to;     
                    }
                }
            }
            else if (p is IfNode ifn)
            {
                if (ifn.Stat1 == from) // Поиск подузла в Parent
                    ifn.Stat1 = to;
                else if (ifn.Stat2 == from)
                    ifn.Stat2 = to;
            }
            else if (p is ForNode forn)
            {
                forn.Stat = to;
            }
            else if (p is WhileNode wh)
            {
                wh.Stat = to;
            }
            else
            {
                throw new Exception("Родительский узел не содержит операторов");
            }
        }
    }
}
