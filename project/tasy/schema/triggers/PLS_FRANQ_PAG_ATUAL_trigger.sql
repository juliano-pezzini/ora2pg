-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_franq_pag_atual ON pls_franq_pag CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_franq_pag_atual() RETURNS trigger AS $BODY$
declare
 
ie_status_w	pls_lote_pagamento.ie_status%type;
 
BEGIN 
 
if (NEW.nr_seq_lote_pgto is not null) and (coalesce(OLD.nr_seq_lote_pgto, -1) <> NEW.nr_seq_lote_pgto) then 
	select	max(ie_status) 
	into STRICT	ie_status_w 
	from	pls_lote_pagamento 
	where	nr_sequencia	= NEW.nr_seq_lote_pgto;
	 
	if (ie_status_w <> 'P') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(329060); -- O lote de pagamento de produção médica informado deve estar com status provisório! 
	end if;
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_franq_pag_atual() FROM PUBLIC;

CREATE TRIGGER pls_franq_pag_atual
	BEFORE INSERT OR UPDATE ON pls_franq_pag FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_franq_pag_atual();
