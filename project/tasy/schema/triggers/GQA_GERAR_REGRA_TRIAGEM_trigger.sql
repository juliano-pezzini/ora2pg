-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS gqa_gerar_regra_triagem ON triagem_pronto_atend CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_gqa_gerar_regra_triagem() RETURNS trigger AS $BODY$
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger <> 'N') then

RETURN NEW;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_gqa_gerar_regra_triagem() FROM PUBLIC;

CREATE TRIGGER gqa_gerar_regra_triagem
	AFTER INSERT OR UPDATE ON triagem_pronto_atend FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_gqa_gerar_regra_triagem();

