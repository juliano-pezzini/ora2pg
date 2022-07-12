-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_cpoe_notes ( nr_seq_cpoe_p bigint, ie_tipo_item_p text default 'M') RETURNS varchar AS $body$
DECLARE


ds_observacao_w 	cpoe_material.ds_observacao%type := '';


BEGIN
if (pkg_i18n.get_user_locale() = 'en_AU') then
	
	if (nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '') then
	
		if (ie_tipo_item_p = 'D') then
			
			select 	ds_observacao
			into STRICT 	ds_observacao_w
			from 	cpoe_dieta
			where 	nr_sequencia = nr_seq_cpoe_p;

		else
			
			select 	ds_observacao
			into STRICT 	ds_observacao_w
			from 	cpoe_material
			where 	nr_sequencia = nr_seq_cpoe_p;

		end if;

	end if;

	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		return  wheb_mensagem_pck.get_texto(357657, null) || ' ' || ds_observacao_w ||  chr(10) || chr(13);
	end if;

end if;

return '';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_cpoe_notes ( nr_seq_cpoe_p bigint, ie_tipo_item_p text default 'M') FROM PUBLIC;

