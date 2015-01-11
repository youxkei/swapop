import parser_combinator.parsing_result : ParsingResult;
import parser_combinator.parse_tree_node : ParseTreeNode;
import parser_combinator.memo : Memo;
import parser_combinator.combinators;

import tcenal.rule_selector : createRuleSelector;
import tcenal.dparsers : Module, skip;
import tcenal.dsl.generate_parsers : generateParsers;


mixin (generateParsers(`
    AssignExpression <- SwapExpression / super;
    SwapExpression <- ConditionalExpression ":=:" ConditionalExpression;
`));


alias parse = Module!(createRuleSelector!().RuleSelector);


string generateVisitor(ParseTreeNode node)
{
    if (node.ruleName == "SwapExpression")
    {
        return "(){"
            "static import std.algorithm;"
            "std.algorithm.swap(" ~ node.children[0].children[0].generateVisitor() ~ ","
                                  ~ node.children[0].children[2].generateVisitor() ~ ");"
        "}()";
    }
    else if (node.ruleName.length > 0)
    {
        string codeSegment;
        foreach (child; node.children)
        {
            codeSegment ~= child.generateVisitor();
        }
        return codeSegment;
    }
    else
    {
        return node.value ~ " ";
    }
}


string SWAP_OP(string src)
{
    Memo memo;
    return parse(src, 0, memo).node.generateVisitor();
}
