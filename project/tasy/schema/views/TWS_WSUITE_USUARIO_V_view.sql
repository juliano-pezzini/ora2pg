-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_wsuite_usuario_v (nr_sequencia, dt_atualizacao, ie_situacao, cd_estabelecimento, nm_usuario_web, cd_pessoa_fisica, nr_seq_segurado, ds_login, ds_alternative_login, dt_envio_confirmacao, ds_hash_ativacao, id_subject, dt_ativacao, nr_seq_perfil_wsuite) AS select  nr_sequencia,
        dt_atualizacao,
        ie_situacao,
        cd_estabelecimento,
        nm_usuario_web,
        cd_pessoa_fisica,
        nr_seq_segurado,
        ds_login,
        ds_alternative_login,
        dt_envio_confirmacao,
        ds_hash_ativacao,
        id_subject,
        dt_ativacao,
        nr_seq_perfil_wsuite
FROM    wsuite_usuario;
