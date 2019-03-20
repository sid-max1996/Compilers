using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProgramTree;

namespace SimpleLang.Visitors
{
    class ThreeAdressCodeVisitor : AutoVisitor
    {
        private LinkedList<Five> fives = new LinkedList<Five> ();
        private int tmpcount = 0;
        private int lblcount = 0;
        public override void VisitAssignNode(AssignNode a)
        {
            
            new Five { Op = "-", Arg1 = a.Expr, Arg2 = a.Expr, Res = a.Id };
            new Five { Op = "+", Arg1 = a.Expr, Arg2 = a.Expr, Res = a.Id };
        }
     
        private Five GenAssignFive(ExprNode expr, ExprNode id) => new Five { Op = "=", Arg1 = expr, Res = id };
        private Five GenIdMinusFive(ExprNode expr, ExprNode id) => new Five { Op = "-", Arg1 = expr, Res = id };
        private Five GenIdMinusFive(ExprNode expr1, ExprNode expr2, ExprNode id) => new Five { Op = "-", Arg1 = expr1, Arg2 = expr2, Res = id };
        private string genTmpName() => $"t{tmpcount++}";
        private string genLblName() => $"L{lblcount++}";


    }
    class Five
    {
        public ExprNode Label, Arg1, Arg2, Res;
        public string Op;
    }

}
