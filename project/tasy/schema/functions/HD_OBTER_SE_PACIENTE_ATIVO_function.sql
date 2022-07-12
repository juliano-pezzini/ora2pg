-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_paciente_ativo ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

				
qt_registro_w		bigint;
ie_retorno_w		varchar(1)	:= 'N';
qt_trat_w		bigint;


BEGIN

select 	count(*)
into STRICT	qt_trat_w
from	paciente_tratamento
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

if (qt_trat_w > 0) then

	select	count(*)
	into STRICT	qt_registro_w
	from	paciente_tratamento
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tratamento		in ('HD','CH','CHD','CHDF','CHDI','PAF','SCUF','SLED','DPA','CPI','CO','CAPD','PL','DPAV','DDC','IHF','IHDF')
	and	(dt_inicio_tratamento IS NOT NULL AND dt_inicio_tratamento::text <> '')
	and	coalesce(dt_final_tratamento::text, '') = '';
end if;

if (qt_trat_w = 0) then
		ie_retorno_w		:= 'S';
elsif (qt_registro_w > 0) then
	ie_retorno_w		:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_paciente_ativo ( cd_pessoa_fisica_p text) FROM PUBLIC;
