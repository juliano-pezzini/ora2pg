-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_configurar_int_bco ( nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

  ds_comando_w    varchar(4000);
  ds_ambiente     varchar(50);

BEGIN

  ds_ambiente := 'TASY_VERSAO';

  ds_comando_w  := 'BEGIN TASY_CRIAR_OBJETO_SISTEMA('|| chr(39) || 'DIRLIST'|| chr(39) ||','||chr(39) ||ds_ambiente|| chr(39)||'); END;';
  CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

  ds_comando_w  := 'BEGIN TASY_CRIAR_OBJETO_SISTEMA('|| chr(39) || 'JMANIPULAARQUIVOS'|| chr(39) ||','||chr(39) ||ds_ambiente|| chr(39)||'); END;';
  CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

  ds_comando_w  := 'BEGIN TASY_CRIAR_OBJETO_SISTEMA('|| chr(39) || 'GET_DIR_LIST'|| chr(39) ||','||chr(39) ||ds_ambiente|| chr(39)||'); END;';
  CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

  ds_comando_w  := 'BEGIN TASY_CRIAR_OBJETO_SISTEMA('|| chr(39) || 'REMOVEARQUIVO'|| chr(39) ||','||chr(39) ||ds_ambiente|| chr(39)||'); END;';
  CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

  ds_comando_w  := 'BEGIN TASY_CRIAR_OBJETO_SISTEMA('|| chr(39) || 'DIRECTORY_BANK'|| chr(39) ||','||chr(39) ||ds_ambiente|| chr(39)||'); END;';
  CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

  ds_comando_w  := 'BEGIN TASY_CRIAR_OBJETO_SISTEMA('|| chr(39) || 'FIN_INTEGRACAO_BANCARIA'|| chr(39) ||','||chr(39) ||ds_ambiente|| chr(39)||'); END;';
  CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

  ds_comando_w  := 'BEGIN TASY_CRIAR_OBJETO_SISTEMA('|| chr(39) || 'FIN_REPROCESAR_INT_BCO'|| chr(39) ||','||chr(39) ||ds_ambiente|| chr(39)||'); END;';
  CALL exec_sql_dinamico(nm_usuario_p,ds_comando_w);

 ds_retorno_p := 'S';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_configurar_int_bco ( nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
