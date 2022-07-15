-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_log_alt_parametros ( nm_usuario_p text, cd_estabelecimento_p text, cd_estab_param_p text, cd_estab_param_old_p text, cd_perfil_param_p text, cd_perfil_param_old_p text, nm_usuario_param_p text, nm_usuario_param_old_p text, nr_seq_param_p text, vl_param_p text, vl_param_old_p text, ie_tipo_param_p text, cd_funcao_p text) AS $body$
DECLARE


qt_registros_w bigint;
ie_permite_log_w varchar(1);
qt_registros_max_w varchar(10);
nr_registros_max_w bigint;
nr_seq_ult_w varchar(20);


BEGIN

ie_permite_log_w := obter_param_usuario(6001, 153, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_permite_log_w);

if (ie_permite_log_w = 'S') then
begin

	if (ie_tipo_param_p = 'U') then
	begin
		insert into log_alt_parametros_w(nr_sequencia,
			cd_funcao,
			dt_atualizacao,
			nm_usuario_param_atual,
			nm_usuario_param_old,
			nm_usuario,
			vl_parametro_old,
			vl_parametro_atual,
			cd_parametro)
		values (nextval('log_alt_parametros_w_seq'),
				cd_funcao_p,
				clock_timestamp(),
				nm_usuario_param_p,
				nm_usuario_param_old_p,
				nm_usuario_p,
				vl_param_old_p,
				vl_param_p,
				nr_seq_param_p);
	end;
	elsif (ie_tipo_param_p = 'P') then
	begin
		insert into log_alt_parametros_w(nr_sequencia,
			cd_funcao,
			dt_atualizacao,
			cd_perfil_atual,
			cd_perfil_old,
			nm_usuario,
			vl_parametro_old,
			vl_parametro_atual,
			cd_parametro)
		values (nextval('log_alt_parametros_w_seq'),
				cd_funcao_p,
				clock_timestamp(),
				cd_perfil_param_p,
				cd_perfil_param_old_p,
				nm_usuario_p,
				vl_param_old_p,
				vl_param_p,
				nr_seq_param_p);
	end;
	elsif (ie_tipo_param_p = 'E') then
	begin
		insert into log_alt_parametros_w(nr_sequencia,
			cd_funcao,
			dt_atualizacao,
			CD_ESTABELECIMENTO_ATUAL,
			CD_ESTABELECIMENTO_OLD,
			nm_usuario,
			vl_parametro_old,
			vl_parametro_atual,
			cd_parametro)
		values (nextval('log_alt_parametros_w_seq'),
				cd_funcao_p,
				clock_timestamp(),
				cd_estab_param_p,
				cd_estab_param_old_p,
				nm_usuario_p,
				vl_param_old_p,
				vl_param_p,
				nr_seq_param_p);
	end;
	end if;


	qt_registros_max_w := obter_param_usuario(6001, 154, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_registros_max_w);
	nr_registros_max_w:= (qt_registros_max_w)::numeric +1;



	select count(*)
	into STRICT qt_registros_w
	from log_alt_parametros_w;

	if (qt_registros_w = nr_registros_max_w) then
		begin
		select min(nr_sequencia)
		into STRICT nr_seq_ult_w
		from log_alt_parametros_w;


		delete from log_alt_parametros_w
		where nr_sequencia = nr_seq_ult_w;
		end;
	end if;

end;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_log_alt_parametros ( nm_usuario_p text, cd_estabelecimento_p text, cd_estab_param_p text, cd_estab_param_old_p text, cd_perfil_param_p text, cd_perfil_param_old_p text, nm_usuario_param_p text, nm_usuario_param_old_p text, nr_seq_param_p text, vl_param_p text, vl_param_old_p text, ie_tipo_param_p text, cd_funcao_p text) FROM PUBLIC;

