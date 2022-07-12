-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS eclipse_conversion_update ON eclipse_conversion CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_eclipse_conversion_update() RETURNS trigger AS $BODY$
declare

nm_atribute_w	eclipse_attribute.nm_eclipse_field%type;
ds_value_w		eclipse_value.ds_value%type;

pragma autonomous_transaction;

BEGIN

if (NEW.ds_tasy_value is not null and NEW.ds_default_value is not null) then
	
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(1112245);

end if;

if (NEW.ds_tasy_value is not null or NEW.ds_default_value is not null) then

	select	max(c.nm_eclipse_field),
			max(b.ds_value)
	into STRICT	nm_atribute_w,
			ds_value_w
	from	eclipse_conversion a,
			eclipse_value b,
			eclipse_attribute c
	where	c.nr_Sequencia = (	SELECT 	max(c.nr_sequencia)
								from 	eclipse_conversion a,
										eclipse_value b,
										eclipse_attribute c
								where  	c.nr_sequencia = b.nr_seq_attribute
								and		b.nr_sequencia = NEW.nr_seq_value
								and (a.ds_tasy_value = NEW.ds_tasy_value
								or		a.ds_default_value	= NEW.ds_tasy_value
								or    	a.ds_tasy_value = NEW.ds_default_value
								or		a.ds_default_value = NEW.ds_default_value))
	and		c.nr_sequencia = b.nr_seq_attribute
	and		b.nr_sequencia =  a.nr_seq_value
	and (a.ds_tasy_value = NEW.ds_tasy_value
	or		a.ds_default_value	= NEW.ds_tasy_value
	or		a.ds_tasy_value = NEW.ds_default_value
	or		a.ds_default_value = NEW.ds_default_value);

	if (nm_atribute_w is not null) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(1112160, 'NM_ATRIBUTO='||nm_atribute_w || ' (Eclipse Value: ' || ds_value_w || ')');
	end if;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_eclipse_conversion_update() FROM PUBLIC;

CREATE TRIGGER eclipse_conversion_update
	BEFORE INSERT OR UPDATE ON eclipse_conversion FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_eclipse_conversion_update();
