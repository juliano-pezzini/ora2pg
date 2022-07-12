-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS centro_controle_tipo_atual ON centro_controle_tipo_gasto CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_centro_controle_tipo_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.ie_tipo_gasto = 'F') then
	NEW.pr_variavel	:= null;
elsif (NEW.ie_tipo_gasto = 'V') then
	NEW.pr_fixo		:= null;
elsif (NEW.ie_tipo_gasto = 'M') then
	BEGIN
	if (coalesce(NEW.pr_fixo,0) = 0) or (coalesce(NEW.pr_variavel,0) = 0) then
		/*Se o tipo de gasto for Misto, os percentuais de Custo fixo e variável' || chr(13) || chr(10) ||
						' não podem ser iguais a zero!#@#@');*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266384);
	end if;
	if	((coalesce(NEW.pr_fixo,0) + coalesce(NEW.pr_variavel,0)) <> 100) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266385);
	end if;
	end;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_centro_controle_tipo_atual() FROM PUBLIC;

CREATE TRIGGER centro_controle_tipo_atual
	BEFORE UPDATE ON centro_controle_tipo_gasto FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_centro_controle_tipo_atual();

