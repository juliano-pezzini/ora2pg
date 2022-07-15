-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_waiting_list_query (NR_SEQ_REGULACAO_P bigint, CD_PESSOA_FISICA_P bigint, CD_PROCEDIMENTO_P bigint DEFAULT NULL, IE_ORIGEM_PROCEDIMENTO_P text DEFAULT NULL, QT_SOLICITADO_P bigint DEFAULT NULL, CD_MATERIAL_P bigint DEFAULT NULL, CD_MATERIAL_ENVIO_P bigint DEFAULT NULL, NM_USUARIO_P text DEFAULT NULL) AS $body$
DECLARE

NM_USUARIO_W varchar(15);

BEGIN
  IF (NR_SEQ_REGULACAO_P IS NOT NULL AND NR_SEQ_REGULACAO_P::text <> '' AND CD_PESSOA_FISICA_P IS NOT NULL AND CD_PESSOA_FISICA_P::text <> '') THEN
    NM_USUARIO_W := coalesce(WHEB_USUARIO_PCK.GET_NM_USUARIO,NM_USUARIO_P);
    INSERT INTO AGENDA_LISTA_ESPERA(
            NR_SEQUENCIA,
            CD_PROCEDIMENTO,
            IE_ORIGEM_PROCED,
            QT_PROCEDIMENTO,
            CD_PESSOA_FISICA,
            DT_AGENDAMENTO,
            DT_ATUALIZACAO,
            DT_ATUALIZACAO_NREC,
            DT_PERIODO_INICIAL,
            IE_STATUS_ESPERA,
            NM_USUARIO_AGENDA,
            NM_USUARIO,
            NM_USUARIO_NREC,
            NR_SEQ_REGULACAO,
            CD_MATERIAL,
            CD_MATERIAL_ENVIO)
            VALUES (
            nextval('agenda_lista_espera_seq'),
            CD_PROCEDIMENTO_P,
            IE_ORIGEM_PROCEDIMENTO_P,
            QT_SOLICITADO_P,
            CD_PESSOA_FISICA_P,
            clock_timestamp(),
            clock_timestamp(),
            clock_timestamp(),
            clock_timestamp(),
            'A',
            NM_USUARIO_W,
            NM_USUARIO_W,
            NM_USUARIO_W,
            NR_SEQ_REGULACAO_P,
            CD_MATERIAL_P,
            CD_MATERIAL_ENVIO_P);
    COMMIT;
  END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_waiting_list_query (NR_SEQ_REGULACAO_P bigint, CD_PESSOA_FISICA_P bigint, CD_PROCEDIMENTO_P bigint DEFAULT NULL, IE_ORIGEM_PROCEDIMENTO_P text DEFAULT NULL, QT_SOLICITADO_P bigint DEFAULT NULL, CD_MATERIAL_P bigint DEFAULT NULL, CD_MATERIAL_ENVIO_P bigint DEFAULT NULL, NM_USUARIO_P text DEFAULT NULL) FROM PUBLIC;

