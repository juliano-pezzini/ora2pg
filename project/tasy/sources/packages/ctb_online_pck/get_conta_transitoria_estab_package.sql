-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ctb_online_pck.get_conta_transitoria_estab (cd_tipo_lote_contabil_p ctb_regra_estab_dif.cd_tipo_lote_contabil%type, cd_estab_origem_p ctb_regra_estab_dif.cd_estab_origem%type) RETURNS varchar AS $body$
BEGIN
  CALL ctb_online_pck.definir_regra_lote_esta_dif(cd_tipo_lote_contabil_p,cd_estab_origem_p);
  return current_setting('ctb_online_pck.cd_conta_contabil_w')::ctb_regra_estab_dif.cd_conta_contabil%type;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ctb_online_pck.get_conta_transitoria_estab (cd_tipo_lote_contabil_p ctb_regra_estab_dif.cd_tipo_lote_contabil%type, cd_estab_origem_p ctb_regra_estab_dif.cd_estab_origem%type) FROM PUBLIC;
