-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_susbst_com_insert ON rep_regra_subst_com CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_susbst_com_insert() RETURNS trigger AS $BODY$
DECLARE
dt_atualizacao 	timestamp	:= LOCALTIMESTAMP;
qt_regra_w	bigint;
BEGIN

select	count(*)
into STRICT	qt_regra_w
from	rep_regra_subst_gen
where	cd_convenio = NEW.cd_convenio;

if (qt_regra_w > 0) then	
	 CALL wheb_mensagem_pck.exibir_mensagem_abort(1086690,'DS_REGRA='||obter_desc_expressao(947152));
end if;
	
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_susbst_com_insert() FROM PUBLIC;

CREATE TRIGGER regra_susbst_com_insert
	AFTER INSERT OR UPDATE ON rep_regra_subst_com FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_susbst_com_insert();

