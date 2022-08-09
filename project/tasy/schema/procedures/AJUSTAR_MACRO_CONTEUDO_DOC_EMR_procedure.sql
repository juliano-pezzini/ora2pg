-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_macro_conteudo_doc_emr ( NR_SEQ_CONTENT_ITEM_P bigint, NM_USUARIO_P text, DS_MACROS_P text) AS $body$
BEGIN

  DELETE
  FROM db_content_item_macro
  WHERE nr_seq_content_item = nr_seq_content_item_p;

  INSERT
  INTO db_content_item_macro(
      NR_SEQUENCIA,
      DT_ATUALIZACAO,
      NM_USUARIO,
      DT_ATUALIZACAO_NREC,
      NM_USUARIO_NREC,
      NR_SEQ_CONTENT_ITEM,
      NR_SEQ_CONTENT_MACRO
    )
  SELECT nextval('db_content_item_macro_seq'),
    clock_timestamp(),
    nm_usuario_p,
    clock_timestamp(),
    nm_usuario_p,
    nr_seq_content_item_p,
    nr_sequencia
  FROM db_content_macro
  WHERE nr_sequencia IN (WITH RECURSIVE cte AS (
SELECT trim(both regexp_substr(ds_macros_p,'[^,]+', 1, level))
    
      (regexp_substr(ds_macros_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(ds_macros_p, '[^,]+', 1, level))::text <> '')
      UNION ALL
SELECT trim(both regexp_substr(ds_macros_p,'[^,]+', 1, level)) JOIN cte c ON ()

) SELECT * FROM cte;
);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_macro_conteudo_doc_emr ( NR_SEQ_CONTENT_ITEM_P bigint, NM_USUARIO_P text, DS_MACROS_P text) FROM PUBLIC;
