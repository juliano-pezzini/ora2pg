-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_tx_opme_atual ON pls_regra_tx_opme CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_tx_opme_atual() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
NEW.dt_fim_vigencia_ref := pls_util_pck.obter_dt_vigencia_null( NEW.dt_fim_vigencia, 'F');
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_tx_opme_atual() FROM PUBLIC;

CREATE TRIGGER pls_regra_tx_opme_atual
	BEFORE INSERT OR UPDATE ON pls_regra_tx_opme FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_tx_opme_atual();

