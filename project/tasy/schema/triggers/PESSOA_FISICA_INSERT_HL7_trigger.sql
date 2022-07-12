-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_insert_hl7 ON pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_insert_hl7() RETURNS trigger AS $BODY$
declare
ds_sep_bv_w		varchar(100);
ds_param_integ_hl7_w	varchar(4000);

BEGIN
ds_sep_bv_w := obter_separador_bv;

ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || NEW.cd_pessoa_fisica || ds_sep_bv_w;
CALL gravar_agend_integracao(71, ds_param_integ_hl7_w);

ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || NEW.cd_pessoa_fisica || ds_sep_bv_w;
CALL gravar_agend_integracao(144, ds_param_integ_hl7_w);

if (NEW.cd_pessoa_fisica is not null) then
  CALL call_bifrost_content('patient.create','person_json_pck.get_patient_message_clob('||NEW.cd_pessoa_fisica||')', NEW.nm_usuario);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_insert_hl7() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_insert_hl7
	AFTER INSERT ON pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_insert_hl7();
