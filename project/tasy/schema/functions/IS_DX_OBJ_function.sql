-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_dx_obj ( nr_sequencia_p bigint, nr_seq_tipo_schematic_p bigint, ie_tipo_objeto_p text, ie_tipo_obj_master_regiao_p text, ie_tipo_obj_painel_p text, ie_tipo_obj_navegador_p text, ie_tipo_componente_p text, ds_version_p text default '1.1') RETURNS varchar AS $body$
DECLARE


retorno_w	varchar(1);

BEGIN

retorno_w := 'N';

begin
select	'S'
into STRICT	retorno_w
from	tipo_schematic_dx
where	nr_seq_tipo_schematic 	= nr_seq_tipo_schematic_p
and	ds_version		<= ds_version_p  LIMIT 1;
exception
when no_data_found or too_many_rows then
	retorno_w := 'N';
end;

if (ie_tipo_objeto_p = 'C') then
	begin
	select	'S'
	into STRICT	retorno_w
	from	tipo_schematic_dx
	where	ie_tipo_componente = ie_tipo_componente_p
	and	ds_version <= ds_version_p  LIMIT 1;
	exception
	when no_data_found or too_many_rows then
		retorno_w := 'N';
	end;

	--IF uses CRUD rule, so the object is not compatible yet
	if (ie_tipo_componente_p = 'WDBP') then
		begin
            select	'N'
            into STRICT	retorno_w
            from	opcoes_crud
            where	nr_seq_objeto_schematic = nr_sequencia_p
            and	    ds_version_p < '1.2'  LIMIT 1;
		exception
		when no_data_found or too_many_rows then
			begin
                select	'N'
                into STRICT	retorno_w
                from	objeto_schematic_legenda
                where	nr_seq_objeto = nr_sequencia_p
                and	    ds_version_p < '1.1'  LIMIT 1;
			exception
			when no_data_found or too_many_rows then
				retorno_w := 'S';
			end;
		end;
	elsif (ie_tipo_componente_p = 'WCP') then
		begin
            select	'N'
            into STRICT	retorno_w
            from	objeto_schematic_legenda
            where	nr_seq_objeto = nr_sequencia_p
            and	ds_version_p < '1.1'  LIMIT 1;
		exception
		when no_data_found or too_many_rows then
			retorno_w := 'S';
		end;
	elsif (ie_tipo_componente_p = 'WPOPUP') then

		begin
            select	'N'
            into STRICT	retorno_w
            from	REGRA_CONDICAO a
            where	a.NR_SEQ_OBJETO_SCHEMATIC = nr_sequencia_p
            and	ds_version_p < '1.3'  LIMIT 1;
		exception
		when no_data_found or too_many_rows then
			retorno_w := 'S';
		end;

		if (retorno_w = 'S') then
			begin
                select	'N'
                into STRICT	retorno_w
                from	obj_schematic_evento a
                where	a.nr_seq_objeto = nr_sequencia_p
                and	ds_version_p < '1.1'  LIMIT 1;
			exception
			when no_data_found or too_many_rows then
				retorno_w := 'S';
			end;
		end if;
		
	elsif (ie_tipo_componente_p = 'WVT') then	
		
		if (retorno_w = 'S') then
			begin
                select	'N'
                into STRICT	retorno_w
                from	objeto_schematic_legenda a
                where	a.nr_seq_objeto = nr_sequencia_p
                and	ds_version_p <= '1.3'  LIMIT 1;
			exception
			when no_data_found or too_many_rows then
				retorno_w := 'S';
			end;
		end if;
		
	end if;

elsif (ie_tipo_objeto_p = 'MR') then
	begin
        select	'S'
        into STRICT	retorno_w
        from	tipo_schematic_dx
        where	ie_tipo_obj_master_regiao = ie_tipo_obj_master_regiao_p
        and	ds_version		<= ds_version_p  LIMIT 1;
	exception
	when no_data_found or too_many_rows then
		retorno_w := 'N';
	end;
elsif (ie_tipo_objeto_p = 'MN') then
	begin
        select	'S'
        into STRICT	retorno_w
        from	tipo_schematic_dx
        where	ie_tipo_obj_navegador = ie_tipo_obj_navegador_p
        and	ds_version		<= ds_version_p  LIMIT 1;
	exception
	when no_data_found or too_many_rows then
		retorno_w := 'N';
	end;
elsif (ie_tipo_objeto_p = 'P') then
	begin
        select	'S'
        into STRICT	retorno_w
        from	tipo_schematic_dx
        where	ie_tipo_obj_painel = ie_tipo_obj_painel_p
        and	ds_version		<= ds_version_p  LIMIT 1;
	exception
	when no_data_found or too_many_rows then
		retorno_w := 'N';
	end;
else
	begin
        select	'S'
        into STRICT	retorno_w
        from	tipo_schematic_dx
        where	ie_tipo_objeto = ie_tipo_objeto_p
        and	ds_version		<= ds_version_p  LIMIT 1;
	exception
	when no_data_found or too_many_rows then
		retorno_w := 'N';
	end;

	if (ie_tipo_objeto_p = 'BTN') then
		begin
            select	'N'
            into STRICT	retorno_w
            from	obj_schematic_evento a
            where	a.nr_seq_objeto = nr_sequencia_p
            and	ds_version_p < '1.1'  LIMIT 1;
		exception
		when no_data_found or too_many_rows then
			retorno_w := 'S';
		end;
	end if;

end if;

if (retorno_w = 'S') and (ds_version_p in ('1.0','1.1','1.2')) then

    begin
        select  'N'
        into STRICT    retorno_w
        from    objeto_schematic a
        where   a.nr_sequencia = nr_sequencia_p
        and     a.ie_configuravel = 'S'  LIMIT 1;
    exception
    when no_data_found or too_many_rows then
        retorno_w := 'S';
    end;

end if;

return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_dx_obj ( nr_sequencia_p bigint, nr_seq_tipo_schematic_p bigint, ie_tipo_objeto_p text, ie_tipo_obj_master_regiao_p text, ie_tipo_obj_painel_p text, ie_tipo_obj_navegador_p text, ie_tipo_componente_p text, ds_version_p text default '1.1') FROM PUBLIC;
