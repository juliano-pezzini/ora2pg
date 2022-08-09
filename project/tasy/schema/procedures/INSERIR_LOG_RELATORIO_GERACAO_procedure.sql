-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_log_relatorio_geracao ( cd_classif_relat_p text, cd_relatorio_p bigint, dt_geracao_p timestamp, ds_parametros_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint) AS $body$
BEGIN

INSERT INTO log_relatorio_geracao(
  nr_sequencia,
  cd_classif_relat,
  cd_relatorio,
  dt_geracao,
  ds_parametros,
  ie_status,
  nm_usuario,
  nm_usuario_nrec,
  dt_atualizacao,
  dt_atualizacao_nrec)
VALUES (
  nextval('log_relatorio_geracao_seq'),
  cd_classif_relat_p,
  cd_relatorio_p,
  dt_geracao_p,
  substr(ds_parametros_p,1,500),
  'I',
  nm_usuario_p,
  nm_usuario_p,
  clock_timestamp(),
  clock_timestamp());

SELECT MAX(nr_sequencia) INTO STRICT nr_sequencia_p FROM log_relatorio_geracao;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_log_relatorio_geracao ( cd_classif_relat_p text, cd_relatorio_p bigint, dt_geracao_p timestamp, ds_parametros_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;
