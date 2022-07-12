-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_proc_remun_diag_befins ON regra_proc_remun_diag CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_proc_remun_diag_befins() RETURNS trigger AS $BODY$
DECLARE


BEGIN

if	wheb_usuario_pck.get_ie_executar_trigger = 'S'  then

	if	NEW.cd_procedimento is null	and
		NEW.nr_seq_proc_interno is null then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(196410);
	elsif	NEW.cd_procedimento is not null and
		NEW.nr_seq_proc_interno is not null then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(44139);
	end if;
	
end if;


RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_proc_remun_diag_befins() FROM PUBLIC;

CREATE TRIGGER regra_proc_remun_diag_befins
	BEFORE INSERT OR UPDATE ON regra_proc_remun_diag FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_proc_remun_diag_befins();

