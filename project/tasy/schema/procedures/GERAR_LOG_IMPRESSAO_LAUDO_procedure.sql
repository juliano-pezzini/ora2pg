-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_impressao_laudo (nm_usuario_p text, nr_seq_laudo_p bigint, ie_tipo_laudo_p text) AS $body$
DECLARE



    /*
       ie_tipo_laudo_p  -- '  I ' para laudo impresso
                     ' V ' para laudo visualizado
    */
BEGIN
INSERT INTO log_impressao_laudo(nr_sequencia,
  dt_atualizacao,
   nm_usuario,
  nr_seq_laudo,
  ie_tipo_laudo,
  dt_atualizacao_nrec,
  nm_usuario_nrec)
 VALUES (nextval('log_impressao_laudo_seq'),
  clock_timestamp(),
  nm_usuario_p,
  nr_seq_laudo_p,
  ie_tipo_laudo_p,
  clock_timestamp(),
  nm_usuario_p);
COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_impressao_laudo (nm_usuario_p text, nr_seq_laudo_p bigint, ie_tipo_laudo_p text) FROM PUBLIC;

