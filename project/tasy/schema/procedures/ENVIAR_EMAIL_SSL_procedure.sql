-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_ssl ( ds_assunto_p text, ds_conteudo_p text, ds_email_remetente_p text, ds_email_destinararios_p text, nm_usuario_email_p text, ds_senha_email_p text, ds_smtp_p text, nr_porta_p text, ie_ssl_p text, ie_confirma_receb_p text, ie_prioridade_p text ) AS $body$
DECLARE

    params params_java_ws_pck.param_tab := params_java_ws_pck.param_tab();
    address varchar(255) := obter_valor_param_usuario(0,227,0,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);

BEGIN
    IF (address IS NOT NULL AND address::text <> '') THEN
        params.extend;
        params[1].ds_key := 'dsAssunto';
        params[1].ds_value := ds_assunto_p;
        params.extend;
        params[2].ds_key := 'dsConteudo';
        params[2].ds_value := ds_conteudo_p;
        params.extend;
        params[3].ds_key := 'dsEmailRemetente';
        params[3].ds_value := ds_email_remetente_p;
        params.extend;
        params[4].ds_key := 'dsEmailDestinararios';
        params[4].ds_value := ds_email_destinararios_p;
        params.extend;
        params[5].ds_key := 'usuarioEmail';
        params[5].ds_value := nm_usuario_email_p;
        params.extend;
        params[6].ds_key := 'senhaEmail';
        params[6].ds_value := ds_senha_email_p;
        params.extend;
        params[7].ds_key := 'smtp';
        params[7].ds_value := ds_smtp_p;
        params.extend;
        params[8].ds_key := 'nrPorta';
        params[8].ds_value := nr_porta_p;
        params.extend;
        params[9].ds_key := 'ieSSL';
        params[9].ds_value := ie_ssl_p;
        params.extend;
        params[10].ds_key := 'ieConfirmaRecebimento';
        params[10].ds_value := ie_confirma_receb_p;
        params.extend;
        params[11].ds_key := 'iePrioridade';
        params[11].ds_value := ie_prioridade_p;
        address := call_java_ws('/br/com/wheb/funcoes/WEmailSSL/enviar',params);
    ELSE
        enviar_email_ssl_leg(
            ds_assunto_p,
            ds_conteudo_p,
            ds_email_remetente_p,
            ds_email_destinararios_p,
            nm_usuario_email_p,
            ds_senha_email_p,
            ds_smtp_p,
            nr_porta_p,
            ie_ssl_p,
            ie_confirma_receb_p,
            ie_prioridade_p);
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_ssl ( ds_assunto_p text, ds_conteudo_p text, ds_email_remetente_p text, ds_email_destinararios_p text, nm_usuario_email_p text, ds_senha_email_p text, ds_smtp_p text, nr_porta_p text, ie_ssl_p text, ie_confirma_receb_p text, ie_prioridade_p text ) FROM PUBLIC;
