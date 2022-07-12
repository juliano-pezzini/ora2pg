-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS medico_after_update ON medico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_medico_after_update() RETURNS trigger AS $BODY$
declare

reg_integracao_p	gerar_int_padrao.reg_integracao;
ds_param_integ_hl7_w			varchar(4000);
ds_sep_bv_w				varchar(100);
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	BEGIN
	ds_sep_bv_w := obter_separador_bv;
	CALL send_physician_intpd(NEW.cd_pessoa_fisica, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, 'U');
	ds_param_integ_hl7_w := 'cd_pessoa_fisica=' || NEW.cd_pessoa_fisica || ds_sep_bv_w||
							'ie_acao='||'MUP'||ds_sep_bv_w;
	CALL gravar_agend_integracao(853, ds_param_integ_hl7_w); /* Tasy -> SCC (MFN_M02) - Doctor registration */
	end;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_medico_after_update() FROM PUBLIC;

CREATE TRIGGER medico_after_update
	AFTER UPDATE ON medico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_medico_after_update();
