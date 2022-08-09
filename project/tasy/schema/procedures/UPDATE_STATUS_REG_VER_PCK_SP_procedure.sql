-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_status_reg_ver_pck_sp (NR_SEQ_P bigint, IE_STATUS_BUILD_P text) AS $body$
BEGIN
  update REGRA_VERSAO_PACOTE_SP set IE_STATUS_BUILD = IE_STATUS_BUILD_P, DT_ATUALIZACAO = clock_timestamp() WHERE NR_SEQUENCIA = NR_SEQ_P;
  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_status_reg_ver_pck_sp (NR_SEQ_P bigint, IE_STATUS_BUILD_P text) FROM PUBLIC;
