-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS df_procedimento_rotina_trg ON df_procedimento_rotina CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_df_procedimento_rotina_trg() RETURNS trigger AS $BODY$
DECLARE     v_id DF_PROCEDIMENTO_ROTINA.NR_SEQ_DIALECT_FIELD%TYPE;BEGIN     SELECT nextval('df_procedimento_rotina_seq') INTO STRICT v_id;     NEW.NR_SEQ_DIALECT_FIELD := v_id; RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_df_procedimento_rotina_trg() FROM PUBLIC;

CREATE TRIGGER df_procedimento_rotina_trg
	BEFORE INSERT ON df_procedimento_rotina FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_df_procedimento_rotina_trg();

