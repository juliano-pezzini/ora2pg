-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verif_benef_lib_dossie_web (nr_seq_segurado_p pls_segurado.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

					
/* verifica se o beneficiario esta liberado para consulta no dossie beneficiario do portal web */
			

qt_regra_dossie_web_w	integer;
ie_tipo_segurado_w	pls_segurado.ie_tipo_segurado%type;
qt_benef_w		integer;
ds_retorno_w		varchar(5)	:= 'S';


BEGIN

select	count(1)
into STRICT	qt_regra_dossie_web_w
from	pls_regra_dossie_web;

if (qt_regra_dossie_web_w > 0)	then
	
	select	ie_tipo_segurado
	into STRICT	ie_tipo_segurado_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	select	count(1)
	into STRICT	qt_benef_w
	from	pls_regra_dossie_web
	where	((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_w))
	and	ie_permite_visualizar	= 'N';
	
	if (qt_benef_w > 0) then		
		ds_retorno_w := 'N';		
	else
		qt_benef_w := 0;
		
		select	count(1)
		into STRICT	qt_benef_w
		from	pls_regra_dossie_web
		where	((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_w))
		and	ie_permite_visualizar = 'S';
		
		if (qt_benef_w > 0 ) then			
			ds_retorno_w := 'S';			
		else	
			ds_retorno_w := 'N';
		end if;
	end if;
else
	ds_retorno_w := 'S';
end if;	

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verif_benef_lib_dossie_web (nr_seq_segurado_p pls_segurado.nr_sequencia%type) FROM PUBLIC;

