-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_cp_cta_filtro_atual ON pls_cp_cta_filtro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_cp_cta_filtro_atual() RETURNS trigger AS $BODY$
declare

BEGIN
-- Tratamento realizado para não permitir nulo nos campos de filtro
if (NEW.ie_filtro_beneficiario is null) then
	NEW.ie_filtro_beneficiario := 'N';
end if;

if (NEW.ie_filtro_conta is null) then
	NEW.ie_filtro_conta := 'N';
end if;

if (NEW.ie_filtro_contrato is null) then
	NEW.ie_filtro_contrato := 'N';
end if;

if (NEW.ie_filtro_intercambio is null) then
	NEW.ie_filtro_intercambio := 'N';
end if;

if (NEW.ie_filtro_material is null) then
	NEW.ie_filtro_material := 'N';
end if;

if (NEW.ie_filtro_participante is null) then
	NEW.ie_filtro_participante := 'N';
end if;

if (NEW.ie_filtro_prestador is null) then
	NEW.ie_filtro_prestador := 'N';
end if;

if (NEW.ie_filtro_procedimento is null) then
	NEW.ie_filtro_procedimento := 'N';
end if;

if (NEW.ie_filtro_produto is null) then
	NEW.ie_filtro_produto := 'N';
end if;

if (NEW.ie_filtro_protocolo is null) then
	NEW.ie_filtro_protocolo := 'N';
end if;

if (NEW.ie_filtro_servico is null) then
	NEW.ie_filtro_servico := 'N';
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_cp_cta_filtro_atual() FROM PUBLIC;

CREATE TRIGGER pls_cp_cta_filtro_atual
	BEFORE INSERT OR UPDATE ON pls_cp_cta_filtro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_cp_cta_filtro_atual();
