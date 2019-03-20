﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProgramTree;

namespace SimpleLang.Visitors
{
    class WhileFalseOptVisitor: ChangeVisitor
    {
        public override void VisitWhileNode(WhileNode c)
        {
            if (c.Expr is BoolNode bn && bn.Value == false)
            {
                ReplaceStatment(c, new EmptyNode());
            }
        }
    }
}
