-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION schematic_parent_breadcrumb (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_obj_sup_w		bigint;
ie_tipo_objeto_w		varchar(10);

ie_tipo_objeto_sup_w	varchar(10);
ie_tipo_componente_sup_w	varchar(10);


BEGIN

select	nr_seq_obj_sup,
	ie_tipo_objeto
into STRICT	nr_seq_obj_sup_w,
	ie_tipo_objeto_w
from	objeto_schematic
where	nr_sequencia	= nr_sequencia_p;

select	ie_tipo_objeto,
	ie_tipo_componente
into STRICT	ie_tipo_objeto_sup_w,
	ie_tipo_componente_sup_w
from	objeto_schematic
where	nr_sequencia	= nr_seq_obj_sup_w;

if (ie_tipo_objeto_sup_w = 'MN' and ie_tipo_objeto_w = 'BC') then
	return	nr_seq_obj_sup_w;

elsif (coalesce(nr_seq_obj_sup_w::text, '') = '') then
	return 	null;
else
	return SCHEMATIC_PARENT_BREADCRUMB(nr_seq_obj_sup_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION schematic_parent_breadcrumb (nr_sequencia_p bigint) FROM PUBLIC;

