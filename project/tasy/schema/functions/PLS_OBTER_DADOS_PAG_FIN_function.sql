-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_pag_fin ( nr_seq_pagador_fin_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255)	:= '';
cd_portador_w		pls_contrato_pagador_fin.cd_portador%type;

/*
	CDP - Código do Portador
	DSP - Descrição do Portador
*/
BEGIN

if (ie_tipo_p in ('CDP','DSP')) then
	select 	max(cd_portador)
	into STRICT	cd_portador_w
	from	pls_contrato_pagador_fin
	where 	nr_sequencia	= nr_seq_pagador_fin_p;

	if (ie_tipo_p = 'DSP') then
		select	max(ds_portador)
		into STRICT 	ds_retorno_w
		from	portador
		where	cd_portador    = cd_portador_w;
	elsif (ie_tipo_p = 'CDP') then
		ds_retorno_w	:= cd_portador_w;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_pag_fin ( nr_seq_pagador_fin_p bigint, ie_tipo_p text) FROM PUBLIC;

