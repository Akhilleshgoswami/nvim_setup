local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- LangChain @tool definition with Google docstring
  s("lctool", {
    t({ "from langchain_core.tools import tool", "", "", "@tool", "def " }),
    i(1, "my_tool"),
    t("("),
    i(2, "query: str"),
    t({ ") -> " }),
    i(3, "str"),
    t({ ":", '    """' }),
    i(4, "Tool description explaining when the agent should call it."),
    t({ "", "", "    Args:", "        " }),
    i(5, "query: Input argument description"),
    t({ "", "", "    Returns:", "        " }),
    i(6, "str: Result returned to the agent"),
    t({ "", '    """', "    " }),
    i(7, "return f'Processed: {query}'"),
  }),

  -- LangChain ChatPromptTemplate
  s("lcprompt", {
    t({ "from langchain_core.prompts import ChatPromptTemplate", "", "prompt = ChatPromptTemplate.from_messages([", '    ("system", "' }),
    i(1, "You are an expert AI agent with access to tools."),
    t({ '"),', '    ("human", "{' }),
    i(2, "input"),
    t({ '}"),', "])" }),
  }),

  -- LangChain ChatOpenAI Model
  s("lcopenai", {
    t({ "from langchain_openai import ChatOpenAI", "", "llm = ChatOpenAI(model=\"" }),
    i(1, "gpt-4o"),
    t({ "\", temperature=" }),
    i(2, "0"),
    t({ ")" }),
  }),

  -- LangChain ChatAnthropic Model
  s("lcclaude", {
    t({ "from langchain_anthropic import ChatAnthropic", "", "llm = ChatAnthropic(model=\"" }),
    i(1, "claude-3-5-sonnet-20241022"),
    t({ "\", temperature=" }),
    i(2, "0"),
    t({ ")" }),
  }),

  -- LCEL Chain (Prompt | Model | StrOutputParser)
  s("lcchain", {
    t({
      "from langchain_core.output_parsers import StrOutputParser",
      "",
      "chain = prompt | llm | StrOutputParser()",
      "response = chain.invoke({\"",
    }),
    i(1, "input"),
    t({ '": "' }),
    i(2, "query"),
    t({ '"})' }),
  }),

  -- LangGraph StateGraph agent definition
  s("lcgraph", {
    t({
      "from typing import Annotated",
      "from typing_extensions import TypedDict",
      "from langgraph.graph import StateGraph, START, END",
      "from langgraph.graph.message import add_messages",
      "",
      "class State(TypedDict):",
      "    messages: Annotated[list, add_messages]",
      "",
      "builder = StateGraph(State)",
      "",
      "def ",
    }),
    i(1, "chatbot"),
    t({ "(state: State):", "    response = llm.invoke(state[\"messages\"])", "    return {\"messages\": [response]}", "", "builder.add_node(\"" }),
    i(2, "chatbot"),
    t({ '", ' }),
    i(3, "chatbot"),
    t({ ")", "builder.add_edge(START, \"" }),
    i(4, "chatbot"),
    t({ '")', "builder.add_edge(\"" }),
    i(5, "chatbot"),
    t({ '", END)', "", "graph = builder.compile()" }),
  }),

  -- LangGraph prebuilt ReAct agent
  s("lcagent", {
    t({
      "from langgraph.prebuilt import create_react_agent",
      "from langchain_openai import ChatOpenAI",
      "",
      "model = ChatOpenAI(model=\"",
    }),
    i(1, "gpt-4o"),
    t({ "\", temperature=0)", "tools = [" }),
    i(2, "my_tool"),
    t({ "]", "agent_executor = create_react_agent(model, tools=tools)" }),
  }),

  -- Pydantic Structured Output Schema for Agent Tools
  s("pydantic", {
    t({
      "from pydantic import BaseModel, Field",
      "",
      "class ",
    }),
    i(1, "ToolInputSchema"),
    t({ "(BaseModel):", '    """' }),
    i(2, "Schema description for LLM function calling"),
    t({ '"""', "    " }),
    i(3, "query"),
    t({ ": " }),
    i(4, "str"),
    t({ " = Field(description=\"" }),
    i(5, "Detailed explanation of this field for the model"),
    t({ '")' }),
  }),

  -- Dotenv loader
  s("dotenv", {
    t({
      "from dotenv import load_dotenv",
      "",
      "load_dotenv()",
    }),
  }),

  -- Pytest test case for agent / tools
  s("pytest", {
    t({
      "import pytest",
      "",
      "def test_",
    }),
    i(1, "agent_tool"),
    t({ "():", "    result = " }),
    i(2, "my_tool"),
    t({ ".invoke({\"" }),
    i(3, "query"),
    t({ '": "' }),
    i(4, "test value"),
    t({ '"})', "    assert result is not None" }),
  }),
}
