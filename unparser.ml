open While_ast;;

let rec unparse_aexpr aexpr =
  match aexpr with
  | AConst n -> string_of_int n
  | AIdent id -> id
  | Op (op, aexpr_l, aexpr_r) ->
      let sign = (match op with
                  | Add -> " + "
                  | Sub -> " - "
                  | Div -> " / "
                  | Mult -> " * ") in
      unparse_aexpr aexpr_l ^ sign ^ unparse_aexpr aexpr_r;;

let rec unparse_bexpr bexpr =
  match bexpr with
  | BConst t ->
      if t then "true" else "false"
  | BIdent id -> id
  | Neg bexpr_ -> "not " ^ unparse_bexpr bexpr_
  | RelOp (op, aexpr_l, aexpr_r) ->
      let sign = (match op with
                  | LessThan -> " < "
                  | LessThanEq -> " <= "
                  | GreaterThan -> " > "
                  | GreaterThanEq -> " >= "
                  | Equal -> " = ") in
      unparse_aexpr aexpr_l ^ sign ^ unparse_aexpr aexpr_r
  | BoolOp (op, bexpr_l, bexpr_r) ->
      let oper = (match op with
                  | And -> " and "
                  | Or -> " or ") in
      unparse_bexpr bexpr_l ^ oper ^ unparse_bexpr bexpr_r;;

let repeat a n =
  let rec repeat_ a n acc =
    if n == 0 then 
      acc
    else
      repeat_ a (n-1) (a::acc)
  in repeat_ a n [];;

let indentate indent =
  List.fold_right (^) (repeat "\t" indent) "";;

let rec unparse_stmt stmt level =
  match stmt with
  | IfStmt (cond, truebody, falsebody, _) ->
      indentate level ^ 
      "if " ^ unparse_bexpr cond ^ " then\n" ^
        unparse_stmt truebody (level + 1) ^ "\n" ^
      indentate level ^ 
      "else\n" ^ 
        unparse_stmt falsebody (level + 1) ^ "\n"
  | WhileStmt (cond, body, _) ->
      indentate level ^
      "while " ^ unparse_bexpr cond ^ " do\n" ^
         unparse_stmt body (level + 1) ^ "\n"
  | AssignStmt (id, aexpr, _) ->
      indentate level ^ id ^ " := " ^ unparse_aexpr aexpr
  | SkipStmt (_) -> "skip"
  | CompStmt (stmt1, stmt2, _) ->
      let needs_semicol = (match stmt1 with
                           | IfStmt _ -> false
                           | WhileStmt _ -> false
                           | _ -> true) in
      indentate level ^ unparse_stmt stmt1 level ^ 
      (if needs_semicol then ";\n" else "") ^
      indentate level ^
      unparse_stmt stmt2 level;;

let unparse ast = unparse_stmt ast 0;;
