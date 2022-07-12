-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION convert_long_to_clob (DS_TABELA_P text, DS_CAMPO_LONG_P text, DS_CONDICAO_P text) RETURNS text AS $body$
DECLARE

  CURSOR_W       integer;
  SQL_W          varchar(32767);
  VALUE_W        varchar(32767);
  CLOB_W         text;
  VALUE_LENGTH_W integer := 32767;
  LENGTH_W       integer := 0;

BEGIN
  SQL_W := 'SELECT ' || DS_CAMPO_LONG_P || ' FROM ' || DS_TABELA_P;

  IF ((trim(both DS_CONDICAO_P) IS NOT NULL AND (trim(both DS_CONDICAO_P))::text <> '')) THEN
    SQL_W := SQL_W || ' WHERE ' || DS_CONDICAO_P;
  END IF;

  CURSOR_W := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(CURSOR_W, SQL_W, DBMS_SQL.NATIVE);

  DBMS_SQL.DEFINE_COLUMN_LONG(CURSOR_W, 1);

  IF DBMS_SQL.EXECUTE_AND_FETCH(CURSOR_W) = 1 THEN
    LOOP
      DBMS_SQL.COLUMN_VALUE_LONG(CURSOR_W,
                                 1,
                                 32767,
                                 LENGTH_W,
                                 VALUE_W,
                                 VALUE_LENGTH_W);
      CLOB_W   := CLOB_W || VALUE_W;
      LENGTH_W := LENGTH_W + 32767;
      EXIT WHEN VALUE_LENGTH_W < 32767;
    END LOOP;
  END IF;

  IF DBMS_SQL.IS_OPEN(CURSOR_W) THEN
    DBMS_SQL.CLOSE_CURSOR(CURSOR_W);
  END IF;

  RETURN CLOB_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION convert_long_to_clob (DS_TABELA_P text, DS_CAMPO_LONG_P text, DS_CONDICAO_P text) FROM PUBLIC;

