-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_auto_ger_itens_atual ON pls_auto_ger_itens CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_auto_ger_itens_atual() RETURNS trigger AS $BODY$
declare
qt_registro_w	bigint;

BEGIN

select	count(1)
into STRICT	qt_registro_w
from	pls_lote_auto_gerado
where	nr_sequencia = NEW.nr_seq_lote
and	ie_status = 'F';

if (qt_registro_w = 0) then
	-- para garantir que o percentual sempre estará correto
	NEW.pr_total	:= 100 * (dividir(NEW.vl_calculo_auto_ger, NEW.vl_calculo_total));
else
	-- aqui avisa que não pode ser feita alterações em lotes fechados
	CALL wheb_mensagem_pck.exibir_mensagem_abort(285148);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_auto_ger_itens_atual() FROM PUBLIC;

CREATE TRIGGER pls_auto_ger_itens_atual
	BEFORE INSERT OR UPDATE ON pls_auto_ger_itens FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_auto_ger_itens_atual();

