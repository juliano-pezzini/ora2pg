-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_regra_exp_imp_atual ON ctb_regra_exp_imp CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_regra_exp_imp_atual() RETURNS trigger AS $BODY$
declare

BEGIN


if (NEW.cd_interface is null)and (NEW.nm_objeto  is null) then
   --Favor cadastrar uma interface ou Importação via banco!
   CALL Wheb_mensagem_pck.exibir_mensagem_abort(311920);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_regra_exp_imp_atual() FROM PUBLIC;

CREATE TRIGGER ctb_regra_exp_imp_atual
	BEFORE INSERT OR UPDATE ON ctb_regra_exp_imp FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_regra_exp_imp_atual();
