-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_prestador_guia ( nr_seq_prestador_p bigint, nr_seq_prestador_guia_p bigint, nr_seq_conta_p bigint) RETURNS varchar AS $body$
DECLARE


ie_prestador_w			varchar(10) := 'N';
cd_pessoa_fisica_w		varchar(20);
cd_cgc_w			varchar(20);
qt_conta_medico_exec_w		bigint;

BEGIN
begin
select	cd_pessoa_fisica,
	cd_cgc
into STRICT	cd_pessoa_fisica_w,
	cd_cgc_w
from	pls_prestador
where	nr_sequencia	= nr_seq_prestador_guia_p;
exception
when others then
	cd_pessoa_fisica_w	:= '';
	cd_cgc_w		:= '';
end;

if (coalesce(cd_pessoa_fisica_w,0)	<> 0) then
	select	count(*)
	into STRICT	qt_conta_medico_exec_w
	from	pls_conta
	where	nr_sequencia		= nr_seq_conta_p
	and	cd_medico_executor	= cd_pessoa_fisica_w;
	if (qt_conta_medico_exec_w > 0) then
		begin
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_prestador_w
		from	pls_prestador_medico
		where	nr_seq_prestador	= nr_seq_prestador_p
		and	cd_medico		= cd_pessoa_fisica_w
		and	ie_tipo_vinculo		= 'C'
		and	ie_situacao		= 'A'
		and	trunc(clock_timestamp(),'dd') between trunc(coalesce(dt_inclusao,clock_timestamp()),'dd') and  fim_dia(coalesce(dt_exclusao,clock_timestamp()));
		exception
		when others then
			ie_prestador_w	:= 'N';
		end;
	else
		ie_prestador_w	:= 'N';
	end if;
elsif (coalesce(cd_cgc_w,0) <> 0) then
	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_p;

	begin
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_prestador_w
	from	pls_prestador_medico
	where	nr_seq_prestador	= nr_seq_prestador_guia_p
	and	cd_medico		= cd_pessoa_fisica_w
	and	ie_tipo_vinculo		= 'C'
	and	ie_situacao		= 'A'
	and	trunc(clock_timestamp(),'dd') between trunc(coalesce(dt_inclusao,clock_timestamp()),'dd') and  fim_dia(coalesce(dt_exclusao,clock_timestamp()));
	exception
	when others then
		ie_prestador_w	:= 'N';
	end;
end if;
if (nr_seq_prestador_p	= nr_seq_prestador_guia_p) then
	ie_prestador_w	:= 'S';
end if;

return	ie_prestador_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_prestador_guia ( nr_seq_prestador_p bigint, nr_seq_prestador_guia_p bigint, nr_seq_conta_p bigint) FROM PUBLIC;

