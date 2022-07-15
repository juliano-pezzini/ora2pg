-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_result_import_conv_ext ( cd_interno_p w_result_import_conversao.cd_interno%type, cd_externo_p w_result_import_conversao.cd_externo%type, cd_externo_old_p w_result_import_conversao.cd_externo_old%type, nm_usuario_p w_result_import_conversao.nm_usuario%type, nm_tabela_p w_result_import_conversao.nm_tabela%type, nm_atributo_p w_result_import_conversao.nm_atributo%type, ie_sistema_externo_p w_result_import_conversao.ie_sistema_externo%type, ie_envio_receb_p w_result_import_conversao.ie_envio_receb%type, ie_envio_recebe_old_p w_result_import_conversao.ie_envio_recebe_old%type, cd_sistema_codificacao_p w_result_import_conversao.cd_sistema_codificacao%type, cd_sistema_codificacao_old_p w_result_import_conversao.cd_sistema_codificacao_old%type, ie_ret_importacao_p w_result_import_conversao.ie_ret_importacao%type, ds_motivo_p w_result_import_conversao.ds_motivo%type, nr_linha_p w_result_import_conversao.nr_linha%type ) AS $body$
BEGIN

    insert into w_result_import_conversao(
        nr_sequencia,
        cd_interno,
        cd_externo,
        cd_externo_old,
        nm_usuario,
        nm_tabela,
        nm_atributo,
        ie_sistema_externo,
        ie_envio_receb,
        ie_envio_recebe_old,
        cd_sistema_codificacao,
        cd_sistema_codificacao_old,
        ie_ret_importacao,
        ds_motivo,
        nr_linha
    ) values (
        nextval('w_result_import_conversao_seq'),
        cd_interno_p,
        cd_externo_p,
        cd_externo_old_p,
        nm_usuario_p,
        nm_tabela_p,
        nm_atributo_p,
        ie_sistema_externo_p,
        ie_envio_receb_p,
        ie_envio_recebe_old_p,
        cd_sistema_codificacao_p,
        cd_sistema_codificacao_old_p,
        ie_ret_importacao_p,
        ds_motivo_p,
        nr_linha_p
    );

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_result_import_conv_ext ( cd_interno_p w_result_import_conversao.cd_interno%type, cd_externo_p w_result_import_conversao.cd_externo%type, cd_externo_old_p w_result_import_conversao.cd_externo_old%type, nm_usuario_p w_result_import_conversao.nm_usuario%type, nm_tabela_p w_result_import_conversao.nm_tabela%type, nm_atributo_p w_result_import_conversao.nm_atributo%type, ie_sistema_externo_p w_result_import_conversao.ie_sistema_externo%type, ie_envio_receb_p w_result_import_conversao.ie_envio_receb%type, ie_envio_recebe_old_p w_result_import_conversao.ie_envio_recebe_old%type, cd_sistema_codificacao_p w_result_import_conversao.cd_sistema_codificacao%type, cd_sistema_codificacao_old_p w_result_import_conversao.cd_sistema_codificacao_old%type, ie_ret_importacao_p w_result_import_conversao.ie_ret_importacao%type, ds_motivo_p w_result_import_conversao.ds_motivo%type, nr_linha_p w_result_import_conversao.nr_linha%type ) FROM PUBLIC;

