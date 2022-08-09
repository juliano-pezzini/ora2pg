-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_ajuste_versao_cliente (cd_versao_p text, nr_release_p text, ds_comando_p text, nr_ordem_p bigint, nm_responsavel_p text, ds_motivo_p text, nm_usuario_p text, cd_funcao_p bigint default 0, ie_tipo_script_p text default 'N', nr_pacote_p text default '0', nr_seq_ordem_serv_p text default '0', nr_service_pack_p text default null, ie_hotfix_p text default 'N') AS $body$
BEGIN
if (not coalesce(cd_funcao_p::text, '') = '') then
    insert into ajuste_versao_cliente(nr_sequencia,
                nm_usuario,
                dt_atualizacao,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                cd_versao,
                nr_release,
                ds_comando,
                nr_ordem,
                nm_responsavel,
                ie_compila,
                ds_motivo,
                dt_ini_aplicacao,
                dt_fim_aplicacao,
                nm_usuario_aplicacao,
                cd_funcao,
				ie_tipo_script,
				nr_pacote,
                nr_service_pack,
				nr_seq_ordem_serv,
				ie_hotfix)
            values (nextval('ajuste_versao_cliente_seq'),
                nm_usuario_p,
                clock_timestamp(),
                clock_timestamp(),
                nm_usuario_p,
                cd_versao_p,
                nr_release_p,
                ds_comando_p,
                nr_ordem_p,
                nm_responsavel_p,
                'N',
                ds_motivo_p,
                null,
                null,
                null,
                cd_funcao_p,
                ie_tipo_script_p,
				nr_pacote_p,
                nr_service_pack_p,
				nr_seq_ordem_serv_p,
				ie_hotfix_p);
else
    insert into ajuste_versao_cliente(nr_sequencia,
                nm_usuario,
                dt_atualizacao,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                cd_versao,
                nr_release,
                ds_comando,
                nr_ordem,
                nm_responsavel,
                ie_compila,
                ds_motivo,
                dt_ini_aplicacao,
                dt_fim_aplicacao,
                nm_usuario_aplicacao,
                cd_funcao,
	ie_tipo_script,
	nr_pacote,
    nr_service_pack,
	nr_seq_ordem_serv,
	ie_hotfix)
            values (nextval('ajuste_versao_cliente_seq'),
                nm_usuario_p,
                clock_timestamp(),
                clock_timestamp(),
                nm_usuario_p,
                cd_versao_p,
                nr_release_p,
                ds_comando_p,
                nr_ordem_p,
                nm_responsavel_p,
                'N',
                ds_motivo_p,
                null,
                null,
                null,
                null,
	'N',
	nr_pacote_p,
    nr_service_pack_p,
	nr_seq_ordem_serv_p,
	ie_hotfix_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_ajuste_versao_cliente (cd_versao_p text, nr_release_p text, ds_comando_p text, nr_ordem_p bigint, nm_responsavel_p text, ds_motivo_p text, nm_usuario_p text, cd_funcao_p bigint default 0, ie_tipo_script_p text default 'N', nr_pacote_p text default '0', nr_seq_ordem_serv_p text default '0', nr_service_pack_p text default null, ie_hotfix_p text default 'N') FROM PUBLIC;
