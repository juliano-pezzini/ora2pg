-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS partograma_atual ON partograma CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_partograma_atual() RETURNS trigger AS $BODY$
declare

ie_ultima_hora_registrada_w	smallint;
dt_registro_hora_w		timestamp;
novo_ie_hora_w			bigint;

pragma autonomous_transaction;

BEGIN

if (NEW.ie_hora is null) then
	select	max(ie_hora)
	into STRICT	ie_ultima_hora_registrada_w
	from	partograma
	where	nr_atendimento = NEW.nr_atendimento;

	if (ie_ultima_hora_registrada_w is null) then
		NEW.ie_hora	:= 0;
	else
		select	min(dt_registro)
		into STRICT	dt_registro_hora_w
		from	partograma
		where	nr_atendimento = NEW.nr_atendimento
		and	ie_hora = ie_ultima_hora_registrada_w;

		novo_ie_hora_w	:= ie_ultima_hora_registrada_w + trunc((NEW.dt_registro - dt_registro_hora_w)*24);

		if (novo_ie_hora_w < 0) then
			NEW.ie_hora	:= 0;
		elsif (novo_ie_hora_w > 23) then
			NEW.ie_hora	:= null;
		else
			NEW.ie_hora	:= novo_ie_hora_w;
		end if;
	end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_partograma_atual() FROM PUBLIC;

CREATE TRIGGER partograma_atual
	BEFORE INSERT OR UPDATE ON partograma FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_partograma_atual();
