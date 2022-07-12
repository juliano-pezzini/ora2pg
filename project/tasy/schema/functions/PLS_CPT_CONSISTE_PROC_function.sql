-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_cpt_consiste_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


cd_tipo_procedimento_w		smallint;
ie_complexidade_w		varchar(2);
qt_registro_w			integer	:= 0;
ds_retorno_w			varchar(1)	:= 'S';


BEGIN

select	coalesce(max(cd_tipo_procedimento),0)
into STRICT	cd_tipo_procedimento_w
from	procedimento
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

/* aaschlote 19/10/2010 - OS 259056
ie_complexidade_w	:= pls_obter_se_proc_cpt_pac(cd_procedimento_p, ie_origem_proced_p, 'C'); */
ie_complexidade_w	:= '';

select	count(*)
into STRICT	qt_registro_w
from	pls_cpt_regra_proc
where	ie_situacao	= 'A';

if (qt_registro_w	> 0) and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	select	count(*)
	into STRICT	qt_registro_w
	from	pls_cpt_regra_proc
	where	ie_situacao	= 'A'
	and	((ie_tipo_procedimento = cd_tipo_procedimento_w) or (coalesce(ie_tipo_procedimento::text, '') = ''))
	and	((ie_complexidade = coalesce(ie_complexidade_w,ie_complexidade)) or (coalesce(ie_complexidade::text, '') = ''));

	if (qt_registro_w	= 0) then
		ds_retorno_w	:= 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cpt_consiste_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;
