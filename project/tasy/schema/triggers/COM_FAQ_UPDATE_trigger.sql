-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS com_faq_update ON com_faq CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_com_faq_update() RETURNS trigger AS $BODY$
declare

ie_aprovador_w		varchar(2);
ie_aprovado_w		varchar(2);

BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_aprovador_w
from	funcao_grupo_sup
where	cd_funcao = NEW.cd_funcao
and	nm_usuario_exec = NEW.nm_usuario;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_aprovado_w
from	com_faq_aprov
where	nr_seq_faq = NEW.nr_sequencia
and		dt_aprovacao is not null;

if (OLD.ie_revisado = 'S') and (ie_aprovador_w = 'N') then
BEGIN
	NEW.ie_revisado:= 'N';

	if (ie_aprovado_w = 'S') then
		NEW.ie_revisado:= 'S';
	end if;
end;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_com_faq_update() FROM PUBLIC;

CREATE TRIGGER com_faq_update
	BEFORE UPDATE ON com_faq FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_com_faq_update();
