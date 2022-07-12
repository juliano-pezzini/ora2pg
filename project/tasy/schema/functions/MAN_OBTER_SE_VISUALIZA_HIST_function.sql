-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_visualiza_hist ( nr_seq_tipo_p bigint, ds_origem_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1);

BEGIN
ds_retorno_w := 'S';
if (coalesce(nr_seq_tipo_p,0) > 0) then
	begin
	if (ds_origem_p = 'TASY') then
		begin
		select	coalesce(max(ie_visualiza_tasy), 'S')
		into STRICT	ds_retorno_w
		from	man_tipo_hist
		where	nr_sequencia = nr_seq_tipo_p
		and	ie_situacao = 'A';
		end;
	end if;
	if (ds_origem_p = 'PDA') then
		begin
		select	coalesce(max(ie_visualiza_pda), 'S')
		into STRICT	ds_retorno_w
		from	man_tipo_hist
		where	nr_sequencia = nr_seq_tipo_p
		and	ie_situacao = 'A';
		end;
	end if;
	if (ds_origem_p = 'WEB') then
		begin
		select	coalesce(max(ie_visualiza_web), 'S')
		into STRICT	ds_retorno_w
		from	man_tipo_hist
		where	nr_sequencia = nr_seq_tipo_p
		and	ie_situacao = 'A';
		end;
	end if;
	end;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_visualiza_hist ( nr_seq_tipo_p bigint, ds_origem_p text) FROM PUBLIC;

