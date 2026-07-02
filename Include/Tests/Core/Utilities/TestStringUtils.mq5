//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : TestStringUtils.mq5                                    |
//| Version : 1.0.0                                                  |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

#include "../../../Core/Utilities/StringUtils.mqh"
#include "../../Framework/TestFramework.mqh"

//+------------------------------------------------------------------+
//| Test: IsEmpty                                                    |
//+------------------------------------------------------------------+
void Test_IsEmpty()
{
   CTestFramework::AssertTrue(
      CStringUtils::IsEmpty(""),
      "CStringUtils.IsEmpty.Empty");

   CTestFramework::AssertFalse(
      CStringUtils::IsEmpty("EURUSD"),
      "CStringUtils.IsEmpty.NonEmpty");
}

//+------------------------------------------------------------------+
//| Test: Equals                                                     |
//+------------------------------------------------------------------+
void Test_Equals()
{
   CTestFramework::AssertTrue(
      CStringUtils::Equals("EURUSD","EURUSD"),
      "CStringUtils.Equals.Exact");

   CTestFramework::AssertFalse(
      CStringUtils::Equals("EURUSD","GBPUSD"),
      "CStringUtils.Equals.Different");

   CTestFramework::AssertTrue(
      CStringUtils::Equals("EURUSD","eurusd",true),
      "CStringUtils.Equals.IgnoreCase");

   CTestFramework::AssertFalse(
      CStringUtils::Equals("EURUSD","eurusd",false),
      "CStringUtils.Equals.CaseSensitive");
}

//+------------------------------------------------------------------+
//| Test: ToUpper                                                    |
//+------------------------------------------------------------------+
void Test_ToUpper()
{
   CTestFramework::AssertEquals(
      "EURUSD",
      CStringUtils::ToUpper("eurusd"),
      "CStringUtils.ToUpper");
}

//+------------------------------------------------------------------+
//| Test: ToLower                                                    |
//+------------------------------------------------------------------+
void Test_ToLower()
{
   CTestFramework::AssertEquals(
      "eurusd",
      CStringUtils::ToLower("EURUSD"),
      "CStringUtils.ToLower");
}

//+------------------------------------------------------------------+
//| Run Validation Tests                                             |
//+------------------------------------------------------------------+
void RunValidationTests()
{
   Test_IsEmpty();
   Test_Equals();
}

//+------------------------------------------------------------------+
//| Run Conversion Tests                                             |
//+------------------------------------------------------------------+
void RunConversionTests()
{
   Test_ToUpper();
   Test_ToLower();
}

//+------------------------------------------------------------------+
//| Test: StartsWith                                                 |
//+------------------------------------------------------------------+
void Test_StartsWith()
{
   CTestFramework::AssertTrue(
      CStringUtils::StartsWith("EURUSD", "EUR"),
      "CStringUtils.StartsWith.Match");

   CTestFramework::AssertFalse(
      CStringUtils::StartsWith("EURUSD", "USD"),
      "CStringUtils.StartsWith.NoMatch");

   CTestFramework::AssertTrue(
      CStringUtils::StartsWith("EURUSD", "eur", true),
      "CStringUtils.StartsWith.IgnoreCase");
}

//+------------------------------------------------------------------+
//| Test: EndsWith                                                   |
//+------------------------------------------------------------------+
void Test_EndsWith()
{
   CTestFramework::AssertTrue(
      CStringUtils::EndsWith("EURUSD", "USD"),
      "CStringUtils.EndsWith.Match");

   CTestFramework::AssertFalse(
      CStringUtils::EndsWith("EURUSD", "EUR"),
      "CStringUtils.EndsWith.NoMatch");

   CTestFramework::AssertTrue(
      CStringUtils::EndsWith("EURUSD", "usd", true),
      "CStringUtils.EndsWith.IgnoreCase");
}

//+------------------------------------------------------------------+
//| Test: Contains                                                   |
//+------------------------------------------------------------------+
void Test_Contains()
{
   CTestFramework::AssertTrue(
      CStringUtils::Contains("EURUSD", "RUS"),
      "CStringUtils.Contains.Match");

   CTestFramework::AssertFalse(
      CStringUtils::Contains("EURUSD", "GBP"),
      "CStringUtils.Contains.NoMatch");

   CTestFramework::AssertTrue(
      CStringUtils::Contains("EURUSD", "rus", true),
      "CStringUtils.Contains.IgnoreCase");
}

//+------------------------------------------------------------------+
//| Test: Trim                                                       |
//+------------------------------------------------------------------+
void Test_Trim()
{
   CTestFramework::AssertEquals(
      "EURUSD",
      CStringUtils::Trim("  EURUSD  "),
      "CStringUtils.Trim.BothSides");

   CTestFramework::AssertEquals(
      "EURUSD",
      CStringUtils::TrimLeft("  EURUSD"),
      "CStringUtils.Trim.Left");

   CTestFramework::AssertEquals(
      "EURUSD",
      CStringUtils::TrimRight("EURUSD  "),
      "CStringUtils.Trim.Right");

   CTestFramework::AssertEquals(
      "",
      CStringUtils::Trim("     "),
      "CStringUtils.Trim.AllWhitespace");

   CTestFramework::AssertEquals(
      "",
      CStringUtils::Trim(""),
      "CStringUtils.Trim.Empty");
}

//+------------------------------------------------------------------+
//| Test: Replace                                                    |
//+------------------------------------------------------------------+
void Test_Replace()
{
   CTestFramework::AssertEquals(
      "GBPUSD",
      CStringUtils::Replace("EURUSD", "EUR", "GBP"),
      "CStringUtils.Replace.Single");

   CTestFramework::AssertEquals(
      "XXXX",
      CStringUtils::Replace("AAAA", "A", "X"),
      "CStringUtils.Replace.Multiple");

   CTestFramework::AssertEquals(
      "EURUSD",
      CStringUtils::Replace("EURUSD", "JPY", "GBP"),
      "CStringUtils.Replace.NoMatch");
}

//+------------------------------------------------------------------+
//| Test: Repeat                                                     |
//+------------------------------------------------------------------+
void Test_Repeat()
{
   CTestFramework::AssertEquals(
      "***",
      CStringUtils::Repeat("*", 3),
      "CStringUtils.Repeat.Normal");

   CTestFramework::AssertEquals(
      "",
      CStringUtils::Repeat("*", 0),
      "CStringUtils.Repeat.Zero");

   CTestFramework::AssertEquals(
      "",
      CStringUtils::Repeat("", 5),
      "CStringUtils.Repeat.Empty");
}

//+------------------------------------------------------------------+
//| Run Search Tests                                                 |
//+------------------------------------------------------------------+
void RunSearchTests()
{
   Test_StartsWith();
   Test_EndsWith();
   Test_Contains();
}

//+------------------------------------------------------------------+
//| Run Modification Tests                                           |
//+------------------------------------------------------------------+
void RunModificationTests()
{
   Test_Trim();
   Test_Replace();
   Test_Repeat();
}

//+------------------------------------------------------------------+
//| Run All Tests                                                    |
//+------------------------------------------------------------------+
void RunAllTests()
{
   RunValidationTests();
   RunConversionTests();
   RunSearchTests();
   RunModificationTests();
}

//+------------------------------------------------------------------+
//| Script Entry Point                                               |
//+------------------------------------------------------------------+
void OnStart()
{
   CTestFramework::Reset();

   CTestFramework::PrintHeader("CStringUtils");

   RunAllTests();

   CTestFramework::PrintSummary();
}
