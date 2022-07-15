-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cirurgia_hist (nr_cirurgia_p bigint, ie_acao_p text, nm_usuario_hist_p text, ds_historico_p text, ie_commit_p text default 'S', cd_motivo_alteracao_p bigint default null, ds_observacao_alteracao_p text default null) AS $body$
DECLARE


nr_seq_hist_w           bigint;
ds_log_hist_cir_w	varchar(2000);


BEGIN
begin

if 	((coalesce(nr_cirurgia_p,0) > 0) and (ie_acao_p IS NOT NULL AND ie_acao_p::text <> '') and (ds_historico_p IS NOT NULL AND ds_historico_p::text <> '') and (nm_usuario_hist_p IS NOT NULL AND nm_usuario_hist_p::text <> '')) then

        /*select  cirurgia_historico_acao_seq.nextval
	into    nr_seq_hist_w
	from    dual;*/
	ds_log_hist_cir_w := substr(	' '|| wheb_mensagem_pck.get_texto(455603) ||' : '|| wheb_usuario_pck.get_cd_funcao || chr(13) ||chr(10)||	--Função ativa
					' '|| wheb_mensagem_pck.get_texto(455610) ||': '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);	--455610 CallStack
		insert into cirurgia_historico_acao(nr_sequencia,
						       nr_cirurgia,
						       dt_atualizacao,
						       nm_usuario,
						       ie_acao,
						       ds_historico,
						       ds_stack,
						       cd_funcao,
						       cd_perfil,
						       cd_motivo_alteracao,
						       ds_observacao_alteracao)
		values (nextval('cirurgia_historico_acao_seq'),
							nr_cirurgia_p,
							 clock_timestamp(),
							 nm_usuario_hist_p,
							 ie_acao_p,
							 substr(ds_historico_p,1,4000),
							 substr(ds_log_hist_cir_w,1,4000),
							 wheb_usuario_pck.get_cd_funcao,
							 wheb_usuario_pck.get_cd_perfil,
							 cd_motivo_alteracao_p,
							 ds_observacao_alteracao_p);

		if (ie_commit_p = 'S') then
			commit;
		end if;
end if;
exception
	when others then
	null;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cirurgia_hist (nr_cirurgia_p bigint, ie_acao_p text, nm_usuario_hist_p text, ds_historico_p text, ie_commit_p text default 'S', cd_motivo_alteracao_p bigint default null, ds_observacao_alteracao_p text default null) FROM PUBLIC;

