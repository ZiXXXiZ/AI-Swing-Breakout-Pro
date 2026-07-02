//+------------------------------------------------------------------+
//| Project : AI Swing Breakout Pro                                  |
//| File    : StringUtils.mqh                                        |
//| Version : 2.0.0-alpha.2                                          |
//| Author  : AI Swing Breakout Team                                 |
//|                                                                  |
//| Purpose                                                          |
//|   Provides stateless string utility functions for the framework. |
//|                                                                  |
//| Notes                                                            |
//|   - Static utility class                                         |
//|   - No internal state                                            |
//|   - Thread-safe (stateless)                                      |
//+------------------------------------------------------------------+
#ifndef __STRINGUTILS_MQH__
#define __STRINGUTILS_MQH__

//+------------------------------------------------------------------+
//| String Utilities                                                 |
//+------------------------------------------------------------------+
class CStringUtils
{
public:

   //===============================================================
   // Validation
   //===============================================================

   static bool IsEmpty(const string text);

   static bool Equals(
      const string a,
      const string b,
      const bool ignoreCase = false);

   //===============================================================
   // Conversion
   //===============================================================

   static string ToLower(const string text);

   static string ToUpper(const string text);

   //===============================================================
   // Search
   //===============================================================

   static bool StartsWith(
      const string text,
      const string prefix,
      const bool ignoreCase = false);

   static bool EndsWith(
      const string text,
      const string suffix,
      const bool ignoreCase = false);

   static bool Contains(
      const string text,
      const string value,
      const bool ignoreCase = false);

   //===============================================================
   // Modification
   //===============================================================

   static string Trim(const string text);

   static string TrimLeft(const string text);

   static string TrimRight(const string text);

   static string Replace(
      const string text,
      const string find,
      const string replacement);

   static string Repeat(
      const string text,
      const int count);

private:

   //===============================================================
   // Internal Helpers
   //===============================================================

   static bool IsWhiteSpace(const ushort ch);

   static string ToLowerCopy(const string text);

   static string ToUpperCopy(const string text);
};

//+------------------------------------------------------------------+
//| Private Helpers                                                  |
//+------------------------------------------------------------------+

bool CStringUtils::IsWhiteSpace(const ushort ch)
{
   return (ch == ' '  ||
           ch == '\t' ||
           ch == '\r' ||
           ch == '\n');
}

//+------------------------------------------------------------------+

string CStringUtils::ToLowerCopy(const string text)
{
   string result = text;
   StringToLower(result);
   return result;
}

//+------------------------------------------------------------------+

string CStringUtils::ToUpperCopy(const string text)
{
   string result = text;
   StringToUpper(result);
   return result;
}

//+------------------------------------------------------------------+
//| Validation                                                       |
//+------------------------------------------------------------------+

bool CStringUtils::IsEmpty(const string text)
{
   return (StringLen(text) == 0);
}

//+------------------------------------------------------------------+

bool CStringUtils::Equals(
   const string a,
   const string b,
   const bool ignoreCase)
{
   if(ignoreCase)
   {
      return StringCompare(
         ToLowerCopy(a),
         ToLowerCopy(b)
      ) == 0;
   }

   return (StringCompare(a, b) == 0);
}

//+------------------------------------------------------------------+
//| Conversion                                                       |
//+------------------------------------------------------------------+

string CStringUtils::ToLower(const string text)
{
   return ToLowerCopy(text);
}

//+------------------------------------------------------------------+

string CStringUtils::ToUpper(const string text)
{
   return ToUpperCopy(text);
}

//+------------------------------------------------------------------+
//| Search                                                           |
//+------------------------------------------------------------------+

bool CStringUtils::StartsWith(
   const string text,
   const string prefix,
   const bool ignoreCase)
{
   const int textLength   = StringLen(text);
   const int prefixLength = StringLen(prefix);

   if(prefixLength > textLength)
      return false;

   string left = StringSubstr(text, 0, prefixLength);

   return Equals(left, prefix, ignoreCase);
}

//+------------------------------------------------------------------+

bool CStringUtils::EndsWith(
   const string text,
   const string suffix,
   const bool ignoreCase)
{
   const int textLength   = StringLen(text);
   const int suffixLength = StringLen(suffix);

   if(suffixLength > textLength)
      return false;

   string right =
      StringSubstr(text, textLength - suffixLength);

   return Equals(right, suffix, ignoreCase);
}

//+------------------------------------------------------------------+

bool CStringUtils::Contains(
   const string text,
   const string value,
   const bool ignoreCase)
{
   if(IsEmpty(value))
      return true;

   if(ignoreCase)
   {
      return (StringFind(
                 ToLowerCopy(text),
                 ToLowerCopy(value)
              ) >= 0);
   }

   return (StringFind(text, value) >= 0);
}

//+------------------------------------------------------------------+
//| Modification                                                     |
//+------------------------------------------------------------------+

string CStringUtils::TrimLeft(const string text)
{
   const int length = StringLen(text);

   int start = 0;

   while(start < length)
   {
      if(!IsWhiteSpace((ushort)StringGetCharacter(text, start)))
         break;

      start++;
   }

   if(start >= length)
      return "";

   return StringSubstr(text, start);
}

//+------------------------------------------------------------------+

string CStringUtils::TrimRight(const string text)
{
   int end = StringLen(text) - 1;

   while(end >= 0)
   {
      if(!IsWhiteSpace((ushort)StringGetCharacter(text, end)))
         break;

      end--;
   }

   if(end < 0)
      return "";

   return StringSubstr(text, 0, end + 1);
}

//+------------------------------------------------------------------+

string CStringUtils::Trim(const string text)
{
   return TrimRight(TrimLeft(text));
}

//+------------------------------------------------------------------+

string CStringUtils::Replace(
   const string text,
   const string find,
   const string replacement)
{
   if(IsEmpty(find))
      return text;

   string result = text;

   int position = StringFind(result, find);

   while(position >= 0)
   {
      result =
         StringSubstr(result, 0, position) +
         replacement +
         StringSubstr(
            result,
            position + StringLen(find)
         );

      position = StringFind(
         result,
         find,
         position + StringLen(replacement)
      );
   }

   return result;
}

//+------------------------------------------------------------------+

string CStringUtils::Repeat(
   const string text,
   const int count)
{
   if(count <= 0 || IsEmpty(text))
      return "";

   string result;

   for(int i = 0; i < count; ++i)
      result += text;

   return result;
}

#endif // __STRINGUTILS_MQH__