-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_pf_agenda_cirurgica ( nm_pessoa_fisica_p text, cd_pessoa_fisica_p text, nr_seq_agenda_p bigint, ie_atualiza_status_p text DEFAULT 'N') AS $body$
DECLARE


ie_status_agenda_w agenda_paciente.ie_status_agenda%TYPE := 'N';


BEGIN
	IF (ie_atualiza_status_p <> 'N') THEN
		ie_status_agenda_w := obter_param_usuario(871, 78, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_status_agenda_w);
	END IF;
    IF (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') THEN
        UPDATE agenda_paciente
        SET
            nm_paciente = nm_pessoa_fisica_p,
            cd_pessoa_fisica = cd_pessoa_fisica_p,
            nm_usuario = obter_usuario_ativo,
            ie_status_agenda = CASE WHEN ie_atualiza_status_p='N' THEN  ie_status_agenda  ELSE ie_status_agenda_w END ,
            dt_atualizacao = clock_timestamp()
        WHERE
            nr_sequencia = nr_seq_agenda_p;

    END IF;

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_pf_agenda_cirurgica ( nm_pessoa_fisica_p text, cd_pessoa_fisica_p text, nr_seq_agenda_p bigint, ie_atualiza_status_p text DEFAULT 'N') FROM PUBLIC;
