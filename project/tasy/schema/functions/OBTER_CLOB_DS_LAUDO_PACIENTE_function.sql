-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_clob_ds_laudo_paciente (NR_SEQ_LAUDO_P bigint) RETURNS text AS $body$
DECLARE

  V_CURSOR  bigint;
  V_LENGTH  bigint;
  V_TAMANHO bigint;
  V_SQL     varchar(2000);
  V_MAX     varchar(32760);
  V_CLOB    text;
  V_LONG    text;
  V_SYSCUR  REFCURSOR;

BEGIN
  V_CURSOR := DBMS_SQL.OPEN_CURSOR;
  V_SQL := 'SELECT LP.DS_LAUDO FROM LAUDO_PACIENTE LP WHERE LP.NR_SEQUENCIA = :NR_SEQ_LAUDO';

  OPEN V_SYSCUR FOR EXECUTE V_SQL
    USING NR_SEQ_LAUDO_P;
  FETCH V_SYSCUR
    INTO V_LONG;
  V_LENGTH := LENGTH(V_LONG);
  CLOSE V_SYSCUR;

  DBMS_LOB.CREATETEMPORARY(V_CLOB, FALSE, DBMS_LOB.CALL);

  IF (V_LONG IS NOT NULL AND V_LONG::text <> '') THEN
    DBMS_SQL.PARSE(V_CURSOR, V_SQL, DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(V_CURSOR, 'NR_SEQ_LAUDO', NR_SEQ_LAUDO_P);
    DBMS_SQL.DEFINE_COLUMN_LONG(V_CURSOR, 1);

    IF (DBMS_SQL.EXECUTE_AND_FETCH(V_CURSOR) = 1) THEN
      DBMS_SQL.COLUMN_VALUE_LONG(V_CURSOR, 1, V_LENGTH, 0, V_MAX, V_TAMANHO);
    END IF;

    V_CLOB := V_MAX;
  END IF;
  RETURN V_CLOB;
 exception
  when data_exception then
    SELECT substr(obter_dados_laudo_paciente(NR_SEQ_LAUDO_P,'DT'),1,255)
    INTO STRICT V_CLOB
;
    RETURN V_CLOB;
   when others then
        CALL wheb_mensagem_pck.exibir_mensagem_abort(obter_desc_expressao(350838));
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_clob_ds_laudo_paciente (NR_SEQ_LAUDO_P bigint) FROM PUBLIC;

