-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS medico_delete ON medico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_medico_delete() RETURNS trigger AS $BODY$
declare
ds_param_integ_hl7_w			varchar(4000);
ds_sep_bv_w				varchar(100);
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S' ) then
	ds_sep_bv_w := obter_separador_bv;
	ds_param_integ_hl7_w := 'cd_pessoa_fisica=' || OLD.cd_pessoa_fisica || ds_sep_bv_w||
								'ie_acao='||'MDL'||ds_sep_bv_w;
	CALL gravar_agend_integracao(853, ds_param_integ_hl7_w); /* Tasy -> SCC (MFN_M02) - Doctor registration */
end if;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_medico_delete() FROM PUBLIC;

CREATE TRIGGER medico_delete
	BEFORE DELETE ON medico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_medico_delete();

