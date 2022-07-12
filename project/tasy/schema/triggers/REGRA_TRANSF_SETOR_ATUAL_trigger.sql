-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_transf_setor_atual ON regra_transferencia_setor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_transf_setor_atual() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.ds_mensagem_bloqueio is not null and coalesce(NEW.ie_permite_transferencia,'S') = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 1046036);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_transf_setor_atual() FROM PUBLIC;

CREATE TRIGGER regra_transf_setor_atual
	BEFORE INSERT OR UPDATE ON regra_transferencia_setor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_transf_setor_atual();
