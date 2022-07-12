-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS evolucao_paciente_tie ON evolucao_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_evolucao_paciente_tie() RETURNS trigger AS $BODY$
DECLARE
  IE_EXISTS_INT_W      varchar(1);
  IE_EVENT_TYPE_W      varchar(1);
  IE_USE_INTEGRATION_W varchar(1);

BEGIN
  IE_USE_INTEGRATION_W := OBTER_PARAM_USUARIO(9041, 10, OBTER_PERFIL_ATIVO, NEW.NM_USUARIO, OBTER_ESTABELECIMENTO_ATIVO, IE_USE_INTEGRATION_W);

  IF (IE_USE_INTEGRATION_W = 'S'
  AND LOWER(NEW.NM_USUARIO) <> 'integration') THEN
    SELECT (CASE WHEN MAX(EPI.NR_SEQUENCIA) IS NOT NULL THEN 'S' ELSE 'N' END)
      INTO STRICT IE_EXISTS_INT_W
      FROM EVOLUCAO_PACIENTE_INT EPI
     WHERE EPI.NR_SEQ_EVOLUCAO = NEW.CD_EVOLUCAO;

    IF (IE_EXISTS_INT_W = 'N') THEN
      IF (OLD.DT_LIBERACAO IS NULL AND NEW.DT_LIBERACAO IS NOT NULL) THEN
        IE_EVENT_TYPE_W := 'A';
      ELSIF (OLD.DT_INATIVACAO IS NULL AND NEW.DT_INATIVACAO IS NOT NULL) THEN
        IE_EVENT_TYPE_W := 'I';
      END IF;
    END IF;

    IF (trim(both IE_EVENT_TYPE_W) IS NOT NULL) THEN
      CALL EXEC_SUBMIT_JOB_COMMAND('GENERATE_EVO_PACIENTE_REQ_TIE(' || NEW.CD_EVOLUCAO || ', ''' || IE_EVENT_TYPE_W || ''');',
                              NEW.NM_USUARIO);
    END IF;
  END IF;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_evolucao_paciente_tie() FROM PUBLIC;

CREATE TRIGGER evolucao_paciente_tie
	AFTER INSERT OR UPDATE ON evolucao_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_evolucao_paciente_tie();

