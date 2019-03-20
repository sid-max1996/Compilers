using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProgramTree;

namespace SimpleLang.Visitors
{
    class DeleteNullVisitor : ChangeVisitor
    {
        public override void VisitBlockNode(BlockNode bln)
        {
            bln.StList= bln.StList.Where(x => x != null).ToList();
        }
        public override void VisitIfNode(IfNode ifn)
        {
            if (ifn.Stat1 == null && ifn.Stat2 == null)
            {
                ReplaceStatment(ifn, null);
            }
        }
        public override void VisitWhileNode(WhileNode c)
        {
            if (c.Stat == null)
            {
                ReplaceStatment(c, null);
            }
        }
    }
}
