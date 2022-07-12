-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS df_carta_medica_trg ON df_carta_medica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_df_carta_medica_trg() RETURNS trigger AS $BODY$
DECLARE     v_id DF_CARTA_MEDICA.NR_SEQ_DIALECT_FIELD%TYPE;BEGIN     SELECT nextval('df_carta_medica_seq') INTO STRICT v_id;     NEW.NR_SEQ_DIALECT_FIELD := v_id; RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_df_carta_medica_trg() FROM PUBLIC;

CREATE TRIGGER df_carta_medica_trg
	BEFORE INSERT ON df_carta_medica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_df_carta_medica_trg();

