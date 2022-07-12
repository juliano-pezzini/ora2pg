-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_plano_meta_tipo_os (nr_seq_gerencia_p bigint, nr_seq_ordem_serv_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_os_meta_w		varchar(03);
nr_seq_plano_w			bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_plano_w
from	desenvolvimento_plano_meta
where	nr_seq_gerencia		= nr_seq_gerencia_p
and		coalesce(dt_meta_real::text, '') = '';

if (nr_seq_plano_w > 0) then
	begin

	select	max(ie_tipo_os_meta)
	into STRICT	ie_tipo_os_meta_w
	from	desenv_plano_meta_os
	where	nr_seq_plano		= nr_seq_plano_w
	and		nr_seq_ordem_serv	= nr_seq_ordem_serv_p;

	end;
end if;

return	ie_tipo_os_meta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_plano_meta_tipo_os (nr_seq_gerencia_p bigint, nr_seq_ordem_serv_p bigint) FROM PUBLIC;
