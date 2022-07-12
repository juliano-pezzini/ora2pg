-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS comprador_update ON comprador CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_comprador_update() RETURNS trigger AS $BODY$
declare

qt_existe_w	bigint;

BEGIN

if (OLD.IE_SITUACAO = 'A') and (NEW.IE_SITUACAO = 'I') then

	SELECT	count(*)
	INTO STRICT	qt_existe_w
	FROM	SUP_REGRA_RESP_COMPRAS
	WHERE	CD_COMPRADOR = NEW.CD_PESSOA_FISICA
	AND	CD_ESTABELECIMENTO = NEW.CD_ESTABELECIMENTO;

	if (qt_existe_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265950);
		--'Existem regras cadastradas no cadastro de Regras responsável compras para este comprador.');
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_comprador_update() FROM PUBLIC;

CREATE TRIGGER comprador_update
	BEFORE UPDATE ON comprador FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_comprador_update();
