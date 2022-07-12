-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE import_stammdaten.newlog ( cd_log_p log_mov.cd_log%type, ds_log_p log_mov.ds_log%type) AS $body$
BEGIN
		PERFORM set_config('import_stammdaten.nm_usuario_w', wheb_usuario_pck.get_nm_usuario(), false);
		PERFORM set_config('import_stammdaten.dt_atual_w', clock_timestamp(), false);
		
		begin
			insert into log_mov(
				cd_log,
				ds_log,
				dt_atualizacao,
				nm_usuario)
			values (
				cd_log_p,
				ds_log_p,
				current_setting('import_stammdaten.dt_atual_w')::timestamp,
				current_setting('import_stammdaten.nm_usuario_w')::varchar(15));
		exception when others then
			rollback;
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1023582);
		end;
		
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
			commit;
		end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_stammdaten.newlog ( cd_log_p log_mov.cd_log%type, ds_log_p log_mov.ds_log%type) FROM PUBLIC;