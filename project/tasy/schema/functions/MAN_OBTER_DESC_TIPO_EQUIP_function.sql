-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_desc_tipo_equip ( nr_seq_tipo_equip_p bigint) RETURNS varchar AS $body$
DECLARE


ds_tipo_equip_w				varchar(50);


BEGIN

if (nr_seq_tipo_equip_p IS NOT NULL AND nr_seq_tipo_equip_p::text <> '') then

	select	coalesce(max(ds_tipo_equip),'')
	into STRICT	ds_tipo_equip_w
	from	man_tipo_equipamento
	where	nr_sequencia = nr_seq_tipo_equip_p;

end if;

return ds_tipo_equip_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_desc_tipo_equip ( nr_seq_tipo_equip_p bigint) FROM PUBLIC;

