%{
// ��� ���������� ����������� � ����� GPPGParser, �������������� ����� ������, ������������ �������� gppg
    public BlockNode root; // �������� ���� ��������������� ������ 
    public Parser(AbstractScanner<ValueType, LexLocation> scanner) : base(scanner) { }
	private bool InDefSect = false;
%}

%output = SimpleYacc.cs

%union { 
			public double dVal; 
			public int iVal; 
			public string sVal; 
			public Node nVal;
			public ExprNode eVal;
			public StatementNode stVal;
			public BlockNode blVal;
       }

%using System.IO;
%using ProgramTree;

%namespace SimpleParser

%start progr

%token BEGIN END CYCLE ASSIGN ASSIGNPLUS ASSIGNMINUS ASSIGNMULT SEMICOLON WRITE
VAR PLUS MINUS MULT DIV OPEN_BRACKET CLOSE_BRACKET
OPEN_BLOCK CLOSE_BLOCK OPEN_SQUARE CLOSE_SQUARE
TRUE FALSE NO AND OR MORE LESS EQUAL NOT_EQUAL MORE_EQUAL LESS_EQUAL
INT DOUBLE BOOL
WHILE FOR TO PRINTLN IF ELSE COMMA

%token <iVal> INUM 
%token <dVal> RNUM 
%token <sVal> ID

%type <eVal> expr ident T F Q K
%type <stVal> statement assign block cycle write empty var varlist while for if println idenlist
%type <blVal> stlist block

%%

progr   : stlist { root = $1; }
		;

stlist	: statement 
			{ 
				$$ = new BlockNode($1); 
			}
		| stlist statement 
			{ 
				$1.Add($2); 
				$$ = $1; 
			}
		;

statement: assign SEMICOLON { $$ = $1; }
		| block   { $$ = $1; }
		| cycle   { $$ = $1; }
		| write   { $$ = $1; }
		| var     { $$ = $1; }
		| empty SEMICOLON  { $$ = $1; }
		| while   { $$ = $1; }
		| for { $$ = $1; }
		| println { $$ = $1; }
		| if { $$ = $1; }
		| idenlist SEMICOLON { $$ = $1; }
		;

idenlist: TYPE ident 
		| idenlist COMMA ident 
		;

TYPE : INT | DOUBLE | BOOL;

empty	: { $$ = new EmptyNode(); }
		;
	
ident 	: ID 
		{
			// if (!InDefSect)
			//	if (!SymbolTable.vars.ContainsKey($1))
			//		throw new Exception("("+@1.StartLine+","+@1.StartColumn+"): ���������� "+$1+" �� �������");
			$$ = new IdNode($1); 
		}
		| ID OPEN_SQUARE expr CLOSE_SQUARE
	;
	
assign 	: ident ASSIGN expr { $$ = new AssignNode($1 as IdNode, $3); }
		| TYPE ident ASSIGN expr { $$ = new AssignNode($2 as IdNode, $4); }
		;

expr	: Q { $$ = $1; }
		| TRUE { $$ = new BoolNode(true);}
		| FALSE { $$ = new BoolNode(false);  }
		| expr MORE Q { $$ = new BinOpNode($1,$3,">"); }
		| expr LESS Q { $$ = new BinOpNode($1,$3,"<"); }
		| expr EQUAL Q { $$ = new BinOpNode($1,$3,"=="); }
		| expr NOT_EQUAL Q { $$ = new BinOpNode($1,$3,"!="); }
		| expr MORE_EQUAL Q { $$ = new BinOpNode($1,$3,">="); }
		| expr LESS_EQUAL Q { $$ = new BinOpNode($1,$3,"<="); }
		;

Q		: Q PLUS T { $$ = new BinOpNode($1,$3,"+"); }
		| Q MINUS T { $$ = new BinOpNode($1,$3,"-"); }
		| T { $$ = $1; }
		;
		
T 		: T MULT K { $$ = new BinOpNode($1,$3,"*"); }
		| T DIV K { $$ = new BinOpNode($1,$3,"/"); }
		| K { $$ = $1; }
		;

K		: F { $$ = $1; }
		| K AND F { $$ = new BinOpNode($1,$3,"&&"); }
		| K OR F { $$ = new BinOpNode($1,$3,"||"); }
		;

// H		: F { $$ = $1; }
// 		| NO F
//		;
		
F 		: ident  { $$ = $1 as IdNode; }
		| INUM { $$ = new IntNumNode($1); }
		| OPEN_BRACKET expr CLOSE_BRACKET { $$ = $2; }
		;

block	: OPEN_BLOCK stlist CLOSE_BLOCK { $$ = $2; }
		;

cycle	: CYCLE expr statement { $$ = new CycleNode($2,$3); }
		;
		
write	: WRITE OPEN_BRACKET expr CLOSE_BRACKET { $$ = new WriteNode($3); }
		;
		
var		: VAR { InDefSect = true; } varlist 
		{ 
			foreach (var v in ($3 as VarDefNode).vars)
				SymbolTable.NewVarDef(v.Name, type.tint);
			InDefSect = false;	
		}
		;

varlist	: ident 
		{ 
			$$ = new VarDefNode($1 as IdNode); 
		}
		| varlist COMMA ident 
		{ 
			($1 as VarDefNode).Add($3 as IdNode);
			$$ = $1;
		}
		;

while	: WHILE OPEN_BRACKET expr CLOSE_BRACKET statement { $$ = new WhileNode($3, $5); }
		;

for		: FOR OPEN_BRACKET assign TO expr CLOSE_BRACKET statement { $$ = new ForNode($3, $5, $7); }
		;

println	: PRINTLN OPEN_BRACKET expr CLOSE_BRACKET SEMICOLON
		;
if		: IF OPEN_BRACKET expr CLOSE_BRACKET statement { $$ = new IfNode($3, $5); }
		| IF OPEN_BRACKET expr CLOSE_BRACKET statement ELSE statement { $$ = new IfNode($3, $5, $7); }
		;
	
%%

