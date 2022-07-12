-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS bordero_tit_pagar_after ON bordero_tit_pagar CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_bordero_tit_pagar_after() RETURNS trigger AS $BODY$
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (TG_OP = 'INSERT') then
	/* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


	CALL gravar_agend_fluxo_caixa(NEW.nr_titulo,null,'TP',NEW.dt_atualizacao,'I',NEW.nm_usuario);
elsif (TG_OP = 'UPDATE') then
	/* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


	CALL gravar_agend_fluxo_caixa(NEW.nr_titulo,null,'TP',NEW.dt_atualizacao,'A',NEW.nm_usuario);
end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_bordero_tit_pagar_after() FROM PUBLIC;

CREATE TRIGGER bordero_tit_pagar_after
	AFTER INSERT OR UPDATE ON bordero_tit_pagar FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_bordero_tit_pagar_after();

