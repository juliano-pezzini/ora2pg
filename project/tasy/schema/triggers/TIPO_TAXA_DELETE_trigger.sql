-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tipo_taxa_delete ON tipo_taxa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tipo_taxa_delete() RETURNS trigger AS $BODY$
DECLARE

cont_w	bigint;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
select	count(*)
into STRICT	cont_w
from	titulo_pagar
where	cd_tipo_taxa_juro	= OLD.cd_tipo_taxa
or	cd_tipo_taxa_multa	= OLD.cd_tipo_taxa;

if (cont_w > 0) then
	/*Nao e possivel excluir este tipo de taxa!
	Ja existem titulos gerados com este tipo de taxa!*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(267027);
end if;	

select	count(*)
into STRICT	cont_w
from	titulo_receber
where	cd_tipo_taxa_juro	= OLD.cd_tipo_taxa
or	cd_tipo_taxa_multa	= OLD.cd_tipo_taxa;

if (cont_w > 0) then
	/*Nao e possivel excluir este tipo de taxa!
	Ja existem titulos gerados com este tipo de taxa!*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(267027);
end if;	
end if;

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tipo_taxa_delete() FROM PUBLIC;

CREATE TRIGGER tipo_taxa_delete
	BEFORE DELETE ON tipo_taxa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tipo_taxa_delete();

