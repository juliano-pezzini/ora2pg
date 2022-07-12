-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_proced_oml_021_tie ON prescr_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_proced_oml_021_tie() RETURNS trigger AS $BODY$
DECLARE

  NR_PRESCRICAO_W        PRESCR_MEDICA.NR_PRESCRICAO%TYPE;
  CD_PESSOA_FISICA_W     PRESCR_MEDICA.CD_PESSOA_FISICA%TYPE;
  NR_ATENDIMENTO_W       PRESCR_MEDICA.NR_ATENDIMENTO%TYPE;
  CD_MEDICO_W            PRESCR_MEDICA.CD_MEDICO%TYPE;
  CD_SETOR_ATENDIMENTO_W PRESCR_MEDICA.CD_SETOR_ATENDIMENTO%TYPE;
  NR_SEQ_AGENDA_W        PRESCR_MEDICA.NR_SEQ_AGENDA%TYPE;
  CD_ESTABELECIMENTO_W   PRESCR_MEDICA.CD_ESTABELECIMENTO%TYPE;

  PROCEDURE PROCESS_EVENT_SEND_OML_021_TIE IS
    JSON_W                   PHILIPS_JSON := PHILIPS_JSON();
    JSON_PATIENT_W           PHILIPS_JSON := PHILIPS_JSON();
    JSON_PRESC_MED_W         PHILIPS_JSON := PHILIPS_JSON();
    JSON_PRESC_PROCED_W      PHILIPS_JSON := PHILIPS_JSON();
    JSON_LIST_PRESC_PROCED_W PHILIPS_JSON_LIST := PHILIPS_JSON_LIST();
    JSON_DATA_W              text;

    NM_PESSOA_FISICA_W       PESSOA_FISICA.NM_PESSOA_FISICA%TYPE;
    DT_NASCIMENTO_W          PESSOA_FISICA.DT_NASCIMENTO%TYPE;
    IE_SEXO_W                PESSOA_FISICA.IE_SEXO%TYPE;

    DS_GIVEN_NAME_W          PERSON_NAME.DS_GIVEN_NAME%TYPE;
    DS_FAMILY_NAME_W         PERSON_NAME.DS_FAMILY_NAME%TYPE;
    DS_COMPONENT_NAME_1_W    PERSON_NAME.DS_COMPONENT_NAME_1%TYPE;

    IE_TIPO_ATENDIMENTO_W    ATENDIMENTO_PACIENTE.IE_TIPO_ATENDIMENTO%TYPE;
    DT_AGENDA_W              AGENDA_PACIENTE.DT_AGENDA%TYPE;

    PROCEDURE OBTER_DADOS_PF(CD_PESSOA_FISICA_P PESSOA_FISICA.CD_PESSOA_FISICA%TYPE) IS
      NR_SEQ_PERSON_NAME_W PESSOA_FISICA.NR_SEQ_PERSON_NAME%TYPE;
    BEGIN
      NM_PESSOA_FISICA_W    := NULL;
      DT_NASCIMENTO_W       := NULL;
      IE_SEXO_W             := NULL;
      DS_GIVEN_NAME_W       := NULL;
      DS_FAMILY_NAME_W      := NULL;
      DS_COMPONENT_NAME_1_W := NULL;

      SELECT PF.NM_PESSOA_FISICA, PF.DT_NASCIMENTO, PF.IE_SEXO, PF.NR_SEQ_PERSON_NAME
        INTO STRICT NM_PESSOA_FISICA_W, DT_NASCIMENTO_W, IE_SEXO_W, NR_SEQ_PERSON_NAME_W
        FROM PESSOA_FISICA PF
       WHERE PF.CD_PESSOA_FISICA = CD_PESSOA_FISICA_P;

      IF (NR_SEQ_PERSON_NAME_W IS NOT NULL) THEN
        SELECT MAX(PN.DS_GIVEN_NAME), MAX(PN.DS_FAMILY_NAME), MAX(PN.DS_COMPONENT_NAME_1)
          INTO STRICT DS_GIVEN_NAME_W, DS_FAMILY_NAME_W, DS_COMPONENT_NAME_1_W
          FROM PERSON_NAME PN
         WHERE PN.NR_SEQUENCIA = NR_SEQ_PERSON_NAME_W;
      END IF;

      IF (trim(both DS_GIVEN_NAME_W) IS NULL
      AND trim(both DS_FAMILY_NAME_W) IS NULL
      AND trim(both DS_COMPONENT_NAME_1_W) IS NULL) THEN
        SELECT OBTER_PARTE_NOME_PF(NM_PESSOA_FISICA_W, 'nome'),
               OBTER_PARTE_NOME_PF(NM_PESSOA_FISICA_W, 'sobrenome'),
               OBTER_PARTE_NOME_PF(NM_PESSOA_FISICA_W, 'restonome')
          INTO STRICT DS_GIVEN_NAME_W, DS_FAMILY_NAME_W, DS_COMPONENT_NAME_1_W
;
      END IF;
    END;

  BEGIN
    JSON_W.PUT('sendingApplication', 'TASY');
    JSON_W.PUT('sendingFacility', 'PHILIPS');
    JSON_W.PUT('receivingApplication', 'COLPOX');
    JSON_W.PUT('receivingFacility', 'TESI');
    JSON_W.PUT('processingID', 'P');

    PERFORM OBTER_DADOS_PF(CD_PESSOA_FISICA_W);

    JSON_PATIENT_W.PUT('internalID', CD_PESSOA_FISICA_W);
    JSON_PATIENT_W.PUT('givenName', coalesce(DS_GIVEN_NAME_W, NM_PESSOA_FISICA_W));
    JSON_PATIENT_W.PUT('surname', DS_FAMILY_NAME_W);
    JSON_PATIENT_W.PUT('ownSurname', DS_COMPONENT_NAME_1_W);
    JSON_PATIENT_W.PUT('dateOfBirth', TO_CHAR(DT_NASCIMENTO_W, 'MM/DD/YYYY'));
    JSON_PATIENT_W.PUT('sex', IE_SEXO_W);

    JSON_W.PUT('patient', JSON_PATIENT_W.TO_JSON_VALUE());

    SELECT AP.IE_TIPO_ATENDIMENTO
      INTO STRICT IE_TIPO_ATENDIMENTO_W
      FROM ATENDIMENTO_PACIENTE AP
     WHERE AP.NR_ATENDIMENTO = NR_ATENDIMENTO_W;

    PERFORM OBTER_DADOS_PF(CD_MEDICO_W);

    JSON_PRESC_MED_W.PUT('patientClass', IE_TIPO_ATENDIMENTO_W);
    JSON_PRESC_MED_W.PUT('patientLocation', CD_SETOR_ATENDIMENTO_W);
    JSON_PRESC_MED_W.PUT('attendingDoctor', CD_MEDICO_W);
    JSON_PRESC_MED_W.PUT('doctorGivenName', coalesce(DS_GIVEN_NAME_W, NM_PESSOA_FISICA_W));
    JSON_PRESC_MED_W.PUT('doctorSurname', DS_FAMILY_NAME_W);
    JSON_PRESC_MED_W.PUT('doctorOwnSurname', DS_COMPONENT_NAME_1_W);
    JSON_PRESC_MED_W.PUT('patientType', 'N');
    JSON_PRESC_MED_W.PUT('visitNumber', NR_ATENDIMENTO_W);

    JSON_W.PUT('medicalOrder', JSON_PRESC_MED_W.TO_JSON_VALUE());

    IF (NR_SEQ_AGENDA_W IS NOT NULL) THEN
      SELECT AP.DT_AGENDA
        INTO STRICT DT_AGENDA_W
        FROM AGENDA_PACIENTE AP
       WHERE AP.NR_SEQUENCIA = NR_SEQ_AGENDA_W;
    END IF;

    JSON_PRESC_PROCED_W.PUT('orderControl', 'CA');
    JSON_PRESC_PROCED_W.PUT('placerOrderNumber', NEW.NR_ACESSO_DICOM);
    JSON_PRESC_PROCED_W.PUT('fillerOrderNumber', NEW.NR_ACESSO_DICOM);
    JSON_PRESC_PROCED_W.PUT('placerGroupNumber', NEW.NR_ACESSO_DICOM);
    JSON_PRESC_PROCED_W.PUT('enteredBy', NEW.NM_USUARIO_NREC);
    JSON_PRESC_PROCED_W.PUT('orderingProvider', NEW.NM_USUARIO_NREC);
    JSON_PRESC_PROCED_W.PUT('universalServiceIdentifier', NEW.NR_SEQ_PROC_INTERNO);
    JSON_PRESC_PROCED_W.PUT('universalServiceName', OBTER_DESC_PROC_INTERNO(NEW.NR_SEQ_PROC_INTERNO));
    JSON_PRESC_PROCED_W.PUT('observationDateTime', TO_CHAR(LOCALTIMESTAMP, 'MM/DD/YYYY HH24:MI:SS'));
    JSON_PRESC_PROCED_W.PUT('collectionVolume', '1');
    JSON_PRESC_PROCED_W.PUT('diagnosticServiceSectionID', 'IMG');
    IF (DT_AGENDA_W IS NOT NULL) THEN
      JSON_PRESC_PROCED_W.PUT('scheduledDateTime', TO_CHAR(DT_AGENDA_W, 'MM/DD/YYYY HH24:MI:SS'));
    END IF;

    JSON_LIST_PRESC_PROCED_W.APPEND(JSON_PRESC_PROCED_W.TO_JSON_VALUE());

    JSON_W.PUT('prescriptionProcedures', JSON_LIST_PRESC_PROCED_W);

    DBMS_LOB.CREATETEMPORARY(JSON_DATA_W, TRUE);
    JSON_W.(JSON_DATA_W);

    JSON_DATA_W := BIFROST.SEND_INTEGRATION_CONTENT('send.laboratory.order.OML_O21', JSON_DATA_W, NEW.NM_USUARIO);
  END;

BEGIN

  IF(OLD.DT_SUSPENSAO IS NULL AND NEW.DT_SUSPENSAO IS NOT NULL) THEN

    SELECT PM.NR_PRESCRICAO,
           PM.CD_PESSOA_FISICA,
           PM.NR_ATENDIMENTO,
           PM.CD_MEDICO,
           PM.CD_SETOR_ATENDIMENTO,
           PM.NR_SEQ_AGENDA,
           PM.CD_ESTABELECIMENTO
      INTO STRICT NR_PRESCRICAO_W,
           CD_PESSOA_FISICA_W,
           NR_ATENDIMENTO_W,
           CD_MEDICO_W,
           CD_SETOR_ATENDIMENTO_W,
           NR_SEQ_AGENDA_W,
           CD_ESTABELECIMENTO_W
      FROM PRESCR_MEDICA PM
	  WHERE PM.NR_PRESCRICAO = NEW.NR_PRESCRICAO;

    IF (OBTER_SE_INTEGR_PROC_INTERNO(NEW.NR_SEQ_PROC_INTERNO, 23 /* COLPOX */
, NULL, NEW.IE_LADO, CD_ESTABELECIMENTO_W) = 'S') THEN
      PROCESS_EVENT_SEND_OML_021_TIE;
    END IF;
  END IF;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_proced_oml_021_tie() FROM PUBLIC;

CREATE TRIGGER prescr_proced_oml_021_tie
	BEFORE UPDATE ON prescr_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_proced_oml_021_tie();

