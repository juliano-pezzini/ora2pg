-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_acesso_web (ds_login_p text, ie_acesso_invalido_p text, cd_estabelecimento_p bigint, nr_seq_log_p INOUT bigint) AS $body$
DECLARE

/*
ie_acesso_invalido = S, N
*/
qt_acesso_w bigint := 0;
qt_acesso_inv_param_w bigint := 0;
ie_acao_excesso_w varchar(255) := '';

BEGIN
	if (ie_acesso_invalido_p = 'N') then
		delete from 	controle_acesso_web
		where		ds_login = ds_login_p;
		commit;
		SELECT * FROM tasy_gravar_log_acesso(ds_login_p, '', '', 'N', '', '', nr_seq_log_p, ie_acao_excesso_w) INTO STRICT nr_seq_log_p, ie_acao_excesso_w;
	else
	 	select	obter_valor_param_usuario(0, 84, null, null, cd_estabelecimento_p)
		into STRICT	qt_acesso_inv_param_w
		;
		select 	coalesce(max(qt_acesso_invalido), 0)
		into STRICT	qt_acesso_w
		from	controle_acesso_web
		where	ds_login = ds_login_p;
		if ( qt_acesso_w = 0) then
			insert 	into controle_acesso_web(
				nr_sequencia,
				dt_acesso,
				qt_acesso_invalido,
				ie_situacao,
				ds_login
			) values (
				nextval('controle_acesso_web_seq'),
				clock_timestamp(),
				1,
				'A',
				ds_login_p
			);
		elsif ( qt_acesso_w = qt_acesso_inv_param_w ) then
			update	controle_acesso_web
			set	ie_situacao = 'B',
				dt_acesso = clock_timestamp()
			where	ds_login = ds_login_p;
		else
			update	controle_acesso_web
			set	qt_acesso_invalido = qt_acesso_invalido + 1,
				dt_acesso = clock_timestamp()
			where	ds_login = ds_login_p;
		end if;
		commit;
		SELECT * FROM tasy_gravar_log_acesso(ds_login_p, '', '', 'T', '', '', nr_seq_log_p, ie_acao_excesso_w) INTO STRICT nr_seq_log_p, ie_acao_excesso_w;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_acesso_web (ds_login_p text, ie_acesso_invalido_p text, cd_estabelecimento_p bigint, nr_seq_log_p INOUT bigint) FROM PUBLIC;

