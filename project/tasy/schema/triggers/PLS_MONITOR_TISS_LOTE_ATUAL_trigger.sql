-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_monitor_tiss_lote_atual ON pls_monitor_tiss_lote CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_monitor_tiss_lote_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S' and pls_se_aplicacao_tasy = 'N')  then
	if (NEW.ie_origem_lote is null) then
		insert into pls_monitor_log_lote(nr_sequencia, ds_log, dt_atualizacao , dt_atualizacao_nrec,
						nm_usuario, nm_usuario_nrec, nr_seq_lote  ) 
			values (nextval('pls_monitor_log_lote_seq'), wheb_usuario_pck.get_nm_maquina||' maquina '||dbms_utility.format_call_stack, LOCALTIMESTAMP, LOCALTIMESTAMP, 
						coalesce(wheb_usuario_pck.get_nm_usuario,NEW.nm_usuario), coalesce(wheb_usuario_pck.get_nm_usuario,NEW.nm_usuario), NEW.nr_sequencia);
	end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_monitor_tiss_lote_atual() FROM PUBLIC;

CREATE TRIGGER pls_monitor_tiss_lote_atual
	AFTER INSERT OR UPDATE ON pls_monitor_tiss_lote FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_monitor_tiss_lote_atual();

