-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_item_conta_ret ( nr_interno_conta_p bigint, nr_seq_ret_item_p bigint, cd_item_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_item_w		varchar(240) := '';
nr_interno_conta_w	bigint;


BEGIN 
 
select	coalesce(max(nr_interno_conta),0) 
into STRICT	nr_interno_conta_w 
from	conta_paciente 
where	nr_interno_conta = nr_interno_conta_p;
 
if (nr_interno_conta_w = 0) then 
	select	coalesce(max(nr_interno_conta),0) 
	into STRICT	nr_interno_conta_w 
	from	convenio_retorno_item 
	where	nr_sequencia	= nr_seq_ret_item_p;
end if;
 
if (nr_interno_conta_w > 0) then 
 
	select	coalesce(max(b.ds_procedimento),'X') 
	into STRICT	ds_item_w 
	from	procedimento b, 
		procedimento_paciente a 
	where	a.cd_procedimento	= b.cd_procedimento 
	and	a.ie_origem_proced = b.ie_origem_proced 
	and	a.nr_interno_conta = nr_interno_conta_w 
	and	coalesce(somente_numero(a.cd_procedimento_convenio), a.cd_procedimento) = cd_item_p;
 
	if (ds_item_w = 'X') then 
		select	coalesce(max(b.ds_procedimento),'X') 
		into STRICT	ds_item_w 
		from	procedimento b, 
			procedimento_paciente a 
		where	a.cd_procedimento	= b.cd_procedimento 
		and	a.ie_origem_proced	= b.ie_origem_proced 
		and	a.nr_interno_conta	= nr_interno_conta_w 
		and	a.cd_procedimento	= cd_item_p;
	end if;
 
	if (ds_item_w = 'X') then 
		select	coalesce(max(b.ds_material),'X') 
		into STRICT	ds_item_w 
		from	material b, 
			material_atend_paciente a 
		where	a.cd_material		= b.cd_material 
		and	a.nr_interno_conta	= nr_interno_conta_w 
		and	coalesce(somente_numero(a.cd_material_convenio), a.cd_material) = cd_item_p;
	end if;
 
	if (ds_item_w = 'X') then 
		select	coalesce(max(b.ds_material),'X') 
		into STRICT	ds_item_w 
		from	material b, 
			material_atend_paciente a 
		where	a.cd_material		= b.cd_material 
		and	a.nr_interno_conta	= nr_interno_conta_w 
		and	a.cd_material		= cd_item_p;
	end if;
 
end if;
 
if (ds_item_w = 'X') then 
	ds_item_w := '';
end if;
 
return ds_item_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_item_conta_ret ( nr_interno_conta_p bigint, nr_seq_ret_item_p bigint, cd_item_p bigint) FROM PUBLIC;

