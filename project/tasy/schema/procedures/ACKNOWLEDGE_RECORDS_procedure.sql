-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE acknowledge_records ( nr_sequencias_p text ) AS $body$
DECLARE


ie_param1_w      varchar(2);
cd_medico_w      pessoa_fisica.cd_pessoa_fisica%TYPE;


BEGIN

    cd_medico_w := obter_pf_usuario(obter_usuario_ativo, 'C');
    if (nr_sequencias_p IS NOT NULL AND nr_sequencias_p::text <> '') then
        EXECUTE
        'update delegacao_logs
        set
            dt_ack_log      = sysdate,
            ie_status_ack   = ''S'',
            nm_usuario_ack  = wheb_usuario_pck.get_nm_usuario,
            dt_atualizacao  = sysdate,
            nm_usuario      = wheb_usuario_pck.get_nm_usuario
        where
            nr_sequencia in (' || nr_sequencias_p || ')';
    else
        ie_param1_w := obter_valor_param_usuario(443, 1, obter_perfil_ativo, obter_usuario_ativo, wheb_usuario_pck.get_cd_estabelecimento);

		update delegacao_logs
        set
            dt_ack_log  = clock_timestamp(),
            ie_status_ack = 'S',
            nm_usuario_ack = wheb_usuario_pck.get_nm_usuario,
            dt_atualizacao = clock_timestamp(),
            nm_usuario = wheb_usuario_pck.get_nm_usuario
        where   cd_perfil in (SELECT    cd_perfil
                              from      medico_perfil_delegado
                              where (ie_param1_w = 'N' and cd_medico = cd_medico_w
                                            or ie_param1_w = 'S'))
        and     coalesce(dt_ack_log::text, '') = ''
        and     coalesce(nm_usuario_ack::text, '') = ''
        and     ie_status_ack = 'N';
    end if;
    commit;
    CALL check_ack_notifications(cd_medico_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE acknowledge_records ( nr_sequencias_p text ) FROM PUBLIC;

