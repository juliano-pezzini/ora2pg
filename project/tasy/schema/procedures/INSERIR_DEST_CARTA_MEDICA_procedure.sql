-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_dest_carta_medica (cd_pessoa_fisica_p destinatario_carta_medica.cd_pessoa_fisica%type, ds_justificativa_p destinatario_carta_medica.ds_justificativa_alteracao%type, ie_envia_medicalnet_p destinatario_carta_medica.ie_envia_medicalnet%type, nm_destinatario_p destinatario_carta_medica.nm_destinatario%type, nr_seq_carta_mae_p destinatario_carta_medica.nr_seq_carta_mae%type, nm_usuario_p destinatario_carta_medica.nm_usuario%type) AS $body$
BEGIN

    insert into destinatario_carta_medica(cd_pessoa_fisica,
                                          ds_justificativa_alteracao,
                                          dt_atualizacao,
                                          dt_atualizacao_nrec,
                                          ie_envia_medicalnet,
                                          nm_destinatario,
                                          nr_seq_carta_mae,
                                          nm_usuario,
                                          nm_usuario_nrec,
                                          nr_sequencia)
    values (cd_pessoa_fisica_p,
           ds_justificativa_p,
           clock_timestamp(),
           clock_timestamp(),
           ie_envia_medicalnet_p,
           nm_destinatario_p,
           nr_seq_carta_mae_p,
           nm_usuario_p,
           nm_usuario_p,
           nextval('destinatario_carta_medica_seq'));

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_dest_carta_medica (cd_pessoa_fisica_p destinatario_carta_medica.cd_pessoa_fisica%type, ds_justificativa_p destinatario_carta_medica.ds_justificativa_alteracao%type, ie_envia_medicalnet_p destinatario_carta_medica.ie_envia_medicalnet%type, nm_destinatario_p destinatario_carta_medica.nm_destinatario%type, nr_seq_carta_mae_p destinatario_carta_medica.nr_seq_carta_mae%type, nm_usuario_p destinatario_carta_medica.nm_usuario%type) FROM PUBLIC;

