-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_login_usuario ( nm_usuario_p text, nm_usuario_param_p text, ie_acao_p text) AS $body$
DECLARE


qt_registros_w	bigint;
vl_parametro_w	varchar(10);
vl_param87_w	varchar(255);


BEGIN

vl_param87_w := obter_valor_param_usuario(0,87,obter_perfil_ativo, nm_usuario_param_p, wheb_usuario_pck.get_cd_estabelecimento);

if (coalesce(vl_param87_w, '0') <> '13') then
	select	count(*)
	into STRICT	qt_registros_w
	from	funcao_param_usuario
	where	nm_usuario_param = nm_usuario_param_p
	and		cd_funcao = 0
	and		nr_sequencia = 87;

	if (ie_acao_p = 'I') then
		vl_parametro_w	:= '4';
	else
		vl_parametro_w	:= '1';
	end if;

	if (qt_registros_w > 0) then
		update	funcao_param_usuario
		set		vl_parametro = vl_parametro_w,
				nm_usuario = nm_usuario_param_p,
				dt_atualizacao = clock_timestamp()
		where	nm_usuario_param = nm_usuario_param_p
		and		cd_funcao = 0
		and		nr_sequencia = 87;
	else
		insert into funcao_param_usuario(
						cd_funcao,
						nr_sequencia,
						nm_usuario_param,
						dt_atualizacao,
						nm_usuario,
						vl_parametro,
						ds_observacao)
				values (
						0,
						87,
						nm_usuario_param_p,
						clock_timestamp(),
						nm_usuario_p,
						vl_parametro_w,
						'');
    end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_login_usuario ( nm_usuario_p text, nm_usuario_param_p text, ie_acao_p text) FROM PUBLIC;

