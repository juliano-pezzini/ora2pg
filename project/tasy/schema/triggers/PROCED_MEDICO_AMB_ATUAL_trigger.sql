-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proced_medico_amb_atual ON proced_medico_ambulatorial CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proced_medico_amb_atual() RETURNS trigger AS $BODY$
DECLARE

ie_situacao_w	varchar(1);

BEGIN

select	coalesce(max(ie_situacao),'A')
into STRICT	ie_situacao_w
from	procedimento
where 	cd_procedimento = NEW.cd_procedimento
and	ie_origem_proced = NEW.ie_origem_proced;

if (ie_situacao_w <> 'A')  then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(279413);
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proced_medico_amb_atual() FROM PUBLIC;

CREATE TRIGGER proced_medico_amb_atual
	BEFORE INSERT OR UPDATE ON proced_medico_ambulatorial FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proced_medico_amb_atual();
