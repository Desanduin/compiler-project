/* A Bison parser, made by GNU Bison 3.0.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDENTIFIER = 258,
    INTEGER = 259,
    FLOATING = 260,
    CHARACTER = 261,
    STRING = 262,
    TYPEDEF_NAME = 263,
    NAMESPACE_NAME = 264,
    CLASS_NAME = 265,
    ENUM_NAME = 266,
    ELLIPSIS = 267,
    COLONCOLON = 268,
    DOTSTAR = 269,
    ADDEQ = 270,
    SUBEQ = 271,
    MULEQ = 272,
    DIVEQ = 273,
    MODEQ = 274,
    XOREQ = 275,
    ANDEQ = 276,
    OREQ = 277,
    SL = 278,
    SR = 279,
    SREQ = 280,
    SLEQ = 281,
    EQ = 282,
    NOTEQ = 283,
    LTEQ = 284,
    GTEQ = 285,
    ANDAND = 286,
    OROR = 287,
    PLUSPLUS = 288,
    MINUSMINUS = 289,
    ARROWSTAR = 290,
    ARROW = 291,
    ASM = 292,
    AUTO = 293,
    BOOL = 294,
    BREAK = 295,
    CASE = 296,
    CATCH = 297,
    CHAR = 298,
    CLASS = 299,
    CONST = 300,
    CONST_CAST = 301,
    CONTINUE = 302,
    DEFAULT = 303,
    DELETE = 304,
    DO = 305,
    DOUBLE = 306,
    DYNAMIC_CAST = 307,
    ELSE = 308,
    ENUM = 309,
    EXPLICIT = 310,
    EXPORT = 311,
    EXTERN = 312,
    FALSE = 313,
    FLOAT = 314,
    FOR = 315,
    FRIEND = 316,
    IF = 317,
    INLINE = 318,
    INT = 319,
    LONG = 320,
    MUTABLE = 321,
    NAMESPACE = 322,
    NEW = 323,
    OPERATOR = 324,
    PRIVATE = 325,
    PROTECTED = 326,
    PUBLIC = 327,
    REGISTER = 328,
    REINTERPRET_CAST = 329,
    RETURN = 330,
    SHORT = 331,
    SIGNED = 332,
    SIZEOF = 333,
    STATIC = 334,
    STATIC_CAST = 335,
    STRUCT = 336,
    SWITCH = 337,
    THIS = 338,
    THROW = 339,
    TRUE = 340,
    TRY = 341,
    TYPEDEF = 342,
    TYPEID = 343,
    TYPENAME = 344,
    UNION = 345,
    UNSIGNED = 346,
    USING = 347,
    VIRTUAL = 348,
    VOID = 349,
    VOLATILE = 350,
    WCHAR_T = 351,
    WHILE = 352
  };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define INTEGER 259
#define FLOATING 260
#define CHARACTER 261
#define STRING 262
#define TYPEDEF_NAME 263
#define NAMESPACE_NAME 264
#define CLASS_NAME 265
#define ENUM_NAME 266
#define ELLIPSIS 267
#define COLONCOLON 268
#define DOTSTAR 269
#define ADDEQ 270
#define SUBEQ 271
#define MULEQ 272
#define DIVEQ 273
#define MODEQ 274
#define XOREQ 275
#define ANDEQ 276
#define OREQ 277
#define SL 278
#define SR 279
#define SREQ 280
#define SLEQ 281
#define EQ 282
#define NOTEQ 283
#define LTEQ 284
#define GTEQ 285
#define ANDAND 286
#define OROR 287
#define PLUSPLUS 288
#define MINUSMINUS 289
#define ARROWSTAR 290
#define ARROW 291
#define ASM 292
#define AUTO 293
#define BOOL 294
#define BREAK 295
#define CASE 296
#define CATCH 297
#define CHAR 298
#define CLASS 299
#define CONST 300
#define CONST_CAST 301
#define CONTINUE 302
#define DEFAULT 303
#define DELETE 304
#define DO 305
#define DOUBLE 306
#define DYNAMIC_CAST 307
#define ELSE 308
#define ENUM 309
#define EXPLICIT 310
#define EXPORT 311
#define EXTERN 312
#define FALSE 313
#define FLOAT 314
#define FOR 315
#define FRIEND 316
#define IF 317
#define INLINE 318
#define INT 319
#define LONG 320
#define MUTABLE 321
#define NAMESPACE 322
#define NEW 323
#define OPERATOR 324
#define PRIVATE 325
#define PROTECTED 326
#define PUBLIC 327
#define REGISTER 328
#define REINTERPRET_CAST 329
#define RETURN 330
#define SHORT 331
#define SIGNED 332
#define SIZEOF 333
#define STATIC 334
#define STATIC_CAST 335
#define STRUCT 336
#define SWITCH 337
#define THIS 338
#define THROW 339
#define TRUE 340
#define TRY 341
#define TYPEDEF 342
#define TYPEID 343
#define TYPENAME 344
#define UNION 345
#define UNSIGNED 346
#define USING 347
#define VIRTUAL 348
#define VOID 349
#define VOLATILE 350
#define WCHAR_T 351
#define WHILE 352

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 60 "120gram.y" /* yacc.c:1909  */

   struct tree *treenode;

#line 252 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
