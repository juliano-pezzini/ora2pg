-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS same_cpi_prontuario_update ON same_cpi_prontuario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_same_cpi_prontuario_update() RETURNS trigger AS $BODY$
declare
nr_prontuario_w		bigint;

pragma autonomous_transaction;
BEGIN
if (NEW.nr_prontuario is not null)  then
	nr_prontuario_w := coalesce(obter_prontuario_pf(NEW.cd_estabelecimento, NEW.cd_pessoa_fisica),0);

	if	(nr_prontuario_w > 0 AND NEW.nr_prontuario <> nr_prontuario_w) then
		-- ESTE LOG ESTÁ CADASTRADO NO Sistema\Dicionário de Dados\Tipos de log PARA GERAR ATÉ 16/09/2016. OS 934797
		CALL gravar_log_tasy(4040,substr('NR_PRONTUARIO='||NEW.nr_prontuario||'-CD_PESSOA_FISICA='||NEW.cd_pessoa_fisica||' - '||dbms_utility.format_call_stack,1,2000), NEW.nm_usuario);
		commit;
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_same_cpi_prontuario_update() FROM PUBLIC;

CREATE TRIGGER same_cpi_prontuario_update
	BEFORE INSERT OR UPDATE ON same_cpi_prontuario FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_same_cpi_prontuario_update();

