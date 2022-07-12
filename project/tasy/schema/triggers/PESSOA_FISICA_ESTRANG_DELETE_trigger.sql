-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_estrang_delete ON pessoa_fisica_estrangeiro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_estrang_delete() RETURNS trigger AS $BODY$
DECLARE
  NR_CPF_W                PESSOA_FISICA.NR_CPF%TYPE;
  NR_CARTAO_ESTRANGEIRO_W PESSOA_FISICA.NR_CARTAO_ESTRANGEIRO%TYPE;
  NR_REG_GERAL_ESTRANG_W  PESSOA_FISICA.NR_REG_GERAL_ESTRANG%TYPE;
  DT_NASCIMENTO_W         PESSOA_FISICA.DT_NASCIMENTO%TYPE;
  IE_STATUS_CPF_W         PESSOA_FISICA_AUX.IE_MOTIVO_SEM_CPF%TYPE;
BEGIN
  SELECT MAX(PFA.IE_MOTIVO_SEM_CPF)
    INTO STRICT IE_STATUS_CPF_W
    FROM PESSOA_FISICA_AUX PFA
   WHERE PFA.CD_PESSOA_FISICA = OLD.CD_PESSOA_FISICA;

  IF (IE_STATUS_CPF_W = '4') THEN
     CALL ATUALIZA_MOTIVO_SEM_CPF_PF(OLD.CD_PESSOA_FISICA, NULL, OLD.NM_USUARIO, 'N');
  END IF;

  SELECT PF.NR_CPF,
         PF.NR_CARTAO_ESTRANGEIRO,
         PF.NR_REG_GERAL_ESTRANG,
         PF.DT_NASCIMENTO
    INTO STRICT NR_CPF_W,
         NR_CARTAO_ESTRANGEIRO_W,
         NR_REG_GERAL_ESTRANG_W,
         DT_NASCIMENTO_W
    FROM PESSOA_FISICA PF
   WHERE PF.CD_PESSOA_FISICA = OLD.CD_PESSOA_FISICA;

  SELECT CASE WHEN NR_CPF_W IS NOT NULL THEN '7'
              WHEN NR_CARTAO_ESTRANGEIRO_W IS NOT NULL
                OR NR_REG_GERAL_ESTRANG_W IS NOT NULL THEN '4'
              WHEN OBTER_IDADE(DT_NASCIMENTO_W, LOCALTIMESTAMP, 'A') < 18 THEN '2'
              WHEN OBTER_IDADE(DT_NASCIMENTO_W, LOCALTIMESTAMP, 'A') > 60 THEN '3'
         ELSE '6' END
    INTO STRICT IE_STATUS_CPF_W
;

  CALL ATUALIZA_MOTIVO_SEM_CPF_PF(OLD.CD_PESSOA_FISICA, IE_STATUS_CPF_W, OLD.NM_USUARIO, 'N');
RETURN OLD;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_estrang_delete() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_estrang_delete
	AFTER DELETE ON pessoa_fisica_estrangeiro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_estrang_delete();

