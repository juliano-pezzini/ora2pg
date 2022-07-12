-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_centro_custo_atual ON pls_regra_centro_custo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_centro_custo_atual() RETURNS trigger AS $BODY$
declare
nr_seq_contrato_w	pls_contrato.nr_sequencia%type;

BEGIN

if (NEW.ie_prestador_codificacao is null and NEW.nr_seq_prestador is not null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1110523);
end if;

select 	max(nr_sequencia) nr_seq_contrato
into STRICT	nr_seq_contrato_w
from 	pls_contrato
where 	nr_contrato = NEW.nr_contrato;

NEW.nr_seq_contrato := nr_seq_contrato_w;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_centro_custo_atual() FROM PUBLIC;

CREATE TRIGGER pls_regra_centro_custo_atual
	BEFORE INSERT OR UPDATE ON pls_regra_centro_custo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_centro_custo_atual();

