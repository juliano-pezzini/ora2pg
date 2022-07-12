-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_if_nurse_initiated ( nr_seq_mat_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE


ds_return_w 		varchar(1) := 'N';
ie_ordered_on_behalf_w	cpoe_material.ie_ordered_on_behalf%type;


BEGIN

if (nr_seq_mat_cpoe_p IS NOT NULL AND nr_seq_mat_cpoe_p::text <> '') then
	select 	max(ie_ordered_on_behalf)
	into STRICT	ie_ordered_on_behalf_w
	from 	cpoe_material
	where	nr_sequencia	= nr_seq_mat_cpoe_p;

	if (coalesce(ie_ordered_on_behalf_w, 'N') = 'N') then

		select 	coalesce(max('S'),'N')
		into STRICT	ds_return_w
		from	cpoe_material a,
			usuario u
		where	a.nm_usuario_nrec = u.nm_usuario
		and 	u.ie_tipo_evolucao = '3'
		and 	u.ie_profissional <> 'NP'
		and 	a.nr_sequencia = nr_seq_mat_cpoe_p;

	end if;

end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_if_nurse_initiated ( nr_seq_mat_cpoe_p bigint) FROM PUBLIC;
