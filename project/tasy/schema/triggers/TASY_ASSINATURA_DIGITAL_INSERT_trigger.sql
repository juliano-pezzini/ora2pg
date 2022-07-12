-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tasy_assinatura_digital_insert ON tasy_assinatura_digital CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tasy_assinatura_digital_insert() RETURNS trigger AS $BODY$
BEGIN

INSERT INTO TASY_ASSINAT_DIG_PEND(DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DT_ATUALIZACAO, NM_USUARIO, NR_SEQ_ASSINATURA, CD_PERFIL, NR_SEQ_PROJ_ASS)
VALUES (LOCALTIMESTAMP, NEW.NM_USUARIO, NEW.DT_REGISTRO, NEW.NM_USUARIO, NEW.NR_SEQUENCIA, wheb_usuario_pck.get_cd_perfil, NEW.NR_SEQ_PROJ_ASS);

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tasy_assinatura_digital_insert() FROM PUBLIC;

CREATE TRIGGER tasy_assinatura_digital_insert
	BEFORE INSERT ON tasy_assinatura_digital FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tasy_assinatura_digital_insert();

