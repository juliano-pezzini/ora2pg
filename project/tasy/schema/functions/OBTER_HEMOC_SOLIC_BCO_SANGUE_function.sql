-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hemoc_solic_bco_sangue ( nr_prescricao_p bigint, nr_seq_solic_p bigint, nr_seq_derivado_p bigint) RETURNS varchar AS $body$
DECLARE



ie_aliquotado_w		varchar(1);
ie_filtrado_w		varchar(1);
ie_irradiado_w		varchar(1);
ie_lavado_w		varchar(1);
ds_derivado_w		varchar(100);
ds_inf_adicional_w	varchar(255);
ds_retorno_w		varchar(2000);
qt_derivado_w		bigint;

C01 CURSOR FOR
SELECT	SUBSTR(obter_desc_san_derivado(nr_seq_derivado),1,100),
	qt_procedimento,
	ie_aliquotado,
	ie_filtrado,
	ie_irradiado,
	ie_lavado
from	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and	nr_seq_solic_sangue = nr_seq_solic_p
and	((nr_seq_derivado = nr_seq_derivado_p) or (coalesce(nr_seq_derivado_p,0) = 0));


BEGIN

open C01;
loop
fetch C01 into
	ds_derivado_w,
	qt_derivado_w,
	ie_aliquotado_w,
	ie_filtrado_w,
	ie_irradiado_w,
	ie_lavado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	if (ie_aliquotado_w = 'S') or (ie_filtrado_w 	 = 'S') or (ie_irradiado_w  = 'S') or (ie_lavado_w 	 = 'S') then

		ds_inf_adicional_w := '(';

		if (ie_aliquotado_w = 'S') then
			ds_inf_adicional_w := ds_inf_adicional_w || 'A' || ', ';
		end if;

		if (ie_filtrado_w = 'S') then
			ds_inf_adicional_w := ds_inf_adicional_w || 'F' || ', ';
		end if;

		if (ie_irradiado_w = 'S') then
			ds_inf_adicional_w := ds_inf_adicional_w || 'I' || ', ';
		end if;

		if (ie_lavado_w = 'S') then
			ds_inf_adicional_w := ds_inf_adicional_w || 'L' || ', ';
		end if;

		ds_inf_adicional_w := substr(ds_inf_adicional_w, 1, (length(trim(both ds_inf_adicional_w))-1)) || ')';

	end if;
	ds_retorno_w := ds_retorno_w || ds_derivado_w || ' ' || ds_inf_adicional_w || '  Qtde. ' || qt_derivado_w || ', ';
end loop;
close C01;

return	substr(ds_retorno_w,1,length(trim(both ds_retorno_w))-1);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hemoc_solic_bco_sangue ( nr_prescricao_p bigint, nr_seq_solic_p bigint, nr_seq_derivado_p bigint) FROM PUBLIC;

