-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE db_content_macro_version ( nr_seq_macro_p bigint, nm_usuario_p text, nr_seq_new_version_p INOUT bigint) AS $body$
DECLARE

  nr_seq_w db_content_macro.nr_sequencia%type;

BEGIN

  SELECT nextval('db_content_macro_seq') INTO STRICT nr_seq_w;

  INSERT
  INTO db_content_macro(
      nr_sequencia,
      nm_usuario_nrec,
      dt_atualizacao_nrec,
      nm_usuario,
      dt_atualizacao,
      ds_macro,
      ie_macro_type,
      ds_description,
      ds_sql_command,
      nr_version
    )
  SELECT nr_seq_w,
    nm_usuario_p,
    clock_timestamp(),
    nm_usuario_p,
    clock_timestamp(),
    ds_macro,
    ie_macro_type,    
    ds_description,
    ds_sql_command,
    (SELECT max(nr_version) +1 from db_content_macro b where a.ds_macro = b.ds_macro)
  FROM db_content_macro a 
  WHERE nr_sequencia = nr_seq_macro_p;

  INSERT
  INTO db_content_macro_param(
      nr_sequencia,
      nr_seq_content_macro,
      nm_usuario_nrec,
      dt_atualizacao_nrec,
      nm_usuario,
      dt_atualizacao,
      ds_parameter
    )
  SELECT nextval('db_content_macro_param_seq'),
    nr_seq_w,
    nm_usuario_p,
    clock_timestamp(),
    nm_usuario_p,
    clock_timestamp(),
    ds_parameter
  FROM db_content_macro_param
  WHERE nr_seq_content_macro = nr_seq_macro_p;

  COMMIT;

  nr_seq_new_version_p := nr_seq_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE db_content_macro_version ( nr_seq_macro_p bigint, nm_usuario_p text, nr_seq_new_version_p INOUT bigint) FROM PUBLIC;

