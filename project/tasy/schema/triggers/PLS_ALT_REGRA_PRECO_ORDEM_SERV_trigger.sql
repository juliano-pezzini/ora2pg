-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_alt_regra_preco_ordem_serv ON pls_regra_preco_ordem_serv CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_alt_regra_preco_ordem_serv() RETURNS trigger AS $BODY$
declare
qt_registro_w	integer;
BEGIN
-- esta trigger tem apenas a finalidade de especificar na tabela pls_regra_preco_controle se as views de preço precisam ser geradas novamente
select	count(1)
into STRICT	qt_registro_w
from	pls_regra_preco_controle;

if (qt_registro_w > 0) then
	update	pls_regra_preco_controle set
		ie_gera_novamente = 'S';
else
	insert into pls_regra_preco_controle(ie_gera_novamente) values ('S');
end if;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_alt_regra_preco_ordem_serv() FROM PUBLIC;

CREATE TRIGGER pls_alt_regra_preco_ordem_serv
	BEFORE INSERT OR UPDATE OR DELETE ON pls_regra_preco_ordem_serv FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_alt_regra_preco_ordem_serv();

