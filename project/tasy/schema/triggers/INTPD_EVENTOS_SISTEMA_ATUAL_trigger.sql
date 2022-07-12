-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS intpd_eventos_sistema_atual ON intpd_eventos_sistema CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_intpd_eventos_sistema_atual() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
if (NEW.ie_formato = 'XML') and (NEW.ie_conversao = 'I') and (NEW.nr_seq_regra_conv is null) then 
	--Deve ser informado o campo 'Regra conversão' para integrações com 'De/Para' definido como 'Interno'. 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(990509);
	 
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_intpd_eventos_sistema_atual() FROM PUBLIC;

CREATE TRIGGER intpd_eventos_sistema_atual
	BEFORE INSERT OR UPDATE ON intpd_eventos_sistema FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_intpd_eventos_sistema_atual();
