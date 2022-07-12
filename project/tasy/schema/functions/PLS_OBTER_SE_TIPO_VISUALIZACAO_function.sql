-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_tipo_visualizacao ( nr_seq_regra_visualizacao_p bigint, ds_tipo_despesa_p text, ie_tipo_guia_p text, ie_despesa_resumido_p text ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
nr_seq_modelo_item_w	bigint;
ds_tipo_despesa_w	bigint;
ie_participante_w	varchar(1);
ie_agrupar_w		varchar(1);
ie_resumo_w		varchar(1);
ie_resumo_ww		varchar(1);


BEGIN

select	CASE WHEN replace(ds_tipo_despesa_p,'R','P')='P1' THEN 3 WHEN replace(ds_tipo_despesa_p,'R','P')='P2' THEN 4 WHEN replace(ds_tipo_despesa_p,'R','P')='P3' THEN 5 WHEN replace(ds_tipo_despesa_p,'R','P')='P4' THEN 8 WHEN replace(ds_tipo_despesa_p,'R','P')='M1' THEN 7 WHEN replace(ds_tipo_despesa_p,'R','P')='M2' THEN 1 WHEN replace(ds_tipo_despesa_p,'R','P')='M3' THEN 2 WHEN replace(ds_tipo_despesa_p,'R','P')='M7' THEN 6 END
into STRICT	ds_tipo_despesa_w
;

/*Trata pora listar o rótulo do item*/

select	max(a.nr_sequencia)
into STRICT	nr_seq_modelo_item_w
from	pls_conta_modelo_item   a
where	a.nr_seq_modelo		= nr_seq_regra_visualizacao_p
and (a.ie_tipo_despesa 	= ds_tipo_despesa_w			or 	coalesce(a.ie_tipo_despesa::text, '') = '')
and (a.ie_tipo_guia		= coalesce(ie_tipo_guia_p,a.ie_tipo_guia) 	or 	coalesce(a.ie_tipo_guia::text, '') = '')
and	coalesce(ie_situacao,'A') 	= 'A';

begin
select	coalesce(a.ie_agrupar,'N')
into STRICT	ie_agrupar_w
from	pls_conta_modelo_item   a
where	a.nr_sequencia = nr_seq_modelo_item_w;
exception
when others then
	ie_agrupar_w := 'N';
end;

if (ie_despesa_resumido_p = 'N') then

	if (coalesce(nr_seq_modelo_item_w,0) > 0)  and (ie_agrupar_w = 'N') then
		ds_retorno_w := 'S';

		if (position('R' in ds_tipo_despesa_p) > 0) or (ie_tipo_guia_p = 6) then	-- A guia de honorário individual também deve ser considerada um participante.
			if (ie_despesa_resumido_p = 'N') then

				select	max(ie_participante)
				into STRICT	ie_participante_w
				from	pls_analise_conta_modelo
				where	nr_sequencia	= nr_seq_regra_visualizacao_p;

				/*Trata pora listar o rótulo do item*/

				if (coalesce(ie_participante_w,'S') = 'S') then
					ds_retorno_w	:= 'S';
				else
					ds_retorno_w	:= 'N';
				end if;

			else
				ds_retorno_w	:= 'N';
			end if;

		end if;
	end if;

elsif (ie_despesa_resumido_p = 'S') then

	if (ie_agrupar_w = 'S') then

		select	max(ie_resumo)
		into STRICT	ie_resumo_w
		from	pls_analise_conta_modelo
		where	nr_sequencia = nr_seq_regra_visualizacao_p;

		if (ie_resumo_w = 'S') then

			if (position('R' in ds_tipo_despesa_p) > 0) or (ie_tipo_guia_p = 6) then	-- A guia de honorário individual também deve ser considerada um participante.
				ds_retorno_w := 'N';
			else
				ds_retorno_w := 'S';
			end if;

		else
			ds_retorno_w := 'N';
		end if;

	else
		ds_retorno_w := 'N';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_tipo_visualizacao ( nr_seq_regra_visualizacao_p bigint, ds_tipo_despesa_p text, ie_tipo_guia_p text, ie_despesa_resumido_p text ) FROM PUBLIC;

