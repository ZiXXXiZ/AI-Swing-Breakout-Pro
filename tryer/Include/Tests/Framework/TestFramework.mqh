//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : TestFramework.mqh                                      |
//| Version : 1.0.0                                                  |
//|                                                                  |
//| Responsibilities                                                 |
//|------------------------------------------------------------------|
//| ✓ Test statistics                                                |
//| ✓ Assertions                                                     |
//| ✓ Test reporting                                                 |
//|                                                                  |
//| Does NOT                                                         |
//| ✗ Execute tests                                                  |
//| ✗ Depend on production code                                      |
//| ✗ Depend on trading modules                                      |
//+------------------------------------------------------------------+
#ifndef __TESTFRAMEWORK_MQH__
#define __TESTFRAMEWORK_MQH__

//+------------------------------------------------------------------+
//| Test Statistics                                                  |
//+------------------------------------------------------------------+
struct STestStatistics
{
private:
   int m_passed;
   int m_failed;

public:
   void Reset()
   {
      m_passed = 0;
      m_failed = 0;
   }

   void Pass()
   {
      ++m_passed;
   }

   void Fail()
   {
      ++m_failed;
   }

   int Passed() const
   {
      return m_passed;
   }

   int Failed() const
   {
      return m_failed;
   }

   int Total() const
   {
      return (m_passed + m_failed);
   }

   bool Success() const
   {
      return (m_failed == 0);
   }
};

//+------------------------------------------------------------------+
//| Global Statistics                                                |
//+------------------------------------------------------------------+
STestStatistics g_testStatistics;

//+------------------------------------------------------------------+
//| Framework                                                        |
//+------------------------------------------------------------------+
class CTestFramework
{
public:

   static void Reset();

   static void PrintHeader(
      const string moduleName);

   static void PrintSummary();

   static void AssertTrue(
      const bool condition,
      const string testName);

   static void AssertFalse(
      const bool condition,
      const string testName);

   static void AssertEquals(
      const string expected,
      const string actual,
      const string testName);

   static void AssertEquals(
      const int expected,
      const int actual,
      const string testName);

   static void AssertEquals(
      const bool expected,
      const bool actual,
      const string testName);
};

//+------------------------------------------------------------------+
//| Reset                                                            |
//+------------------------------------------------------------------+
void CTestFramework::Reset()
{
   g_testStatistics.Reset();
}

//+------------------------------------------------------------------+
//| Header                                                           |
//+------------------------------------------------------------------+
void CTestFramework::PrintHeader(
   const string moduleName)
{
   Print("==================================================");
   Print("Testing ", moduleName);
   Print("==================================================");
}

//+------------------------------------------------------------------+
//| Assert True                                                      |
//+------------------------------------------------------------------+
void CTestFramework::AssertTrue(
   const bool condition,
   const string testName)
{
   if(condition)
   {
      g_testStatistics.Pass();
      Print("[PASS] ", testName);
   }
   else
   {
      g_testStatistics.Fail();
      Print("[FAIL] ", testName);
   }
}

//+------------------------------------------------------------------+
//| Assert False                                                     |
//+------------------------------------------------------------------+
void CTestFramework::AssertFalse(
   const bool condition,
   const string testName)
{
   AssertTrue(!condition, testName);
}

//+------------------------------------------------------------------+
//| Assert Equals (string)                                           |
//+------------------------------------------------------------------+
void CTestFramework::AssertEquals(
   const string expected,
   const string actual,
   const string testName)
{
   if(expected == actual)
   {
      g_testStatistics.Pass();
      Print("[PASS] ", testName);
   }
   else
   {
      g_testStatistics.Fail();

      Print(
         "[FAIL] ",
         testName,
         " | Expected=\"",
         expected,
         "\" Actual=\"",
         actual,
         "\""
      );
   }
}

//+------------------------------------------------------------------+
//| Assert Equals (int)                                              |
//+------------------------------------------------------------------+
void CTestFramework::AssertEquals(
   const int expected,
   const int actual,
   const string testName)
{
   if(expected == actual)
   {
      g_testStatistics.Pass();
      Print("[PASS] ", testName);
   }
   else
   {
      g_testStatistics.Fail();

      Print(
         "[FAIL] ",
         testName,
         " | Expected=",
         expected,
         " Actual=",
         actual
      );
   }
}

//+------------------------------------------------------------------+
//| Assert Equals (bool)                                             |
//+------------------------------------------------------------------+
void CTestFramework::AssertEquals(
   const bool expected,
   const bool actual,
   const string testName)
{
   if(expected == actual)
   {
      g_testStatistics.Pass();
      Print("[PASS] ", testName);
   }
   else
   {
      g_testStatistics.Fail();

      Print(
         "[FAIL] ",
         testName,
         " | Expected=",
         (expected ? "true" : "false"),
         " Actual=",
         (actual ? "true" : "false")
      );
   }
}

//+------------------------------------------------------------------+
//| Print Summary                                                    |
//+------------------------------------------------------------------+
void CTestFramework::PrintSummary()
{
   Print("==================================================");
   Print("Tests Passed : ", g_testStatistics.Passed());
   Print("Tests Failed : ", g_testStatistics.Failed());
   Print("Total Tests  : ", g_testStatistics.Total());

   if(g_testStatistics.Success())
      Print("RESULT       : PASSED");
   else
      Print("RESULT       : FAILED");

   Print("==================================================");
}

#endif // __TESTFRAMEWORK_MQH__