-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ehr_elemento_atual ON ehr_elemento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ehr_elemento_atual() RETURNS trigger AS $BODY$
declare

BEGIN
/*Trigger para o controle da sequencia dos registros.
De zero a 9000000 sequencia da Wheb.
Apartir de 9000000 sequencia dos clientes.
*/
if (coalesce(NEW.ie_origem,'W')	= 'W') and (NEW.nr_sequencia	>= 9000000) then
	--Elemento cadastrado ultrapassou o limite de 9000000 de registros. Faixa de valores do cliente. #@#@');
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261591);
elsif (coalesce(NEW.ie_origem,'W')	= 'C') and (NEW.nr_sequencia	<9000000) then
	/*Sequence do elemento dentro da faixa de cadastros da Wheb. '||
					'Favor entrar em contato com a Wheb para posicionar a sequence #@#@');*/
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261593);
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ehr_elemento_atual() FROM PUBLIC;

CREATE TRIGGER ehr_elemento_atual
	BEFORE INSERT OR UPDATE ON ehr_elemento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ehr_elemento_atual();
