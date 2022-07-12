-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_item_escala_sae ( nr_prescricao_p bigint, cd_empresa_p bigint, nr_seq_modelo_p bigint, cd_setor_pac_p text) RETURNS varchar AS $body$
DECLARE

retorno_w		varchar(4000) := 'N';
pendentes_w		varchar(4000);
todos_pendentes_w	varchar(4000);
total_pendentes_w	bigint := 0;

C01 CURSOR FOR
	SELECT	distinct a.ds_tipo_item||':'||b.ds_item
	FROM pe_regra_item_escala e, pe_item_tipo_item c, pe_tipo_item a, pe_item_examinar b
LEFT OUTER JOIN pe_sae_mod_item d ON (b.nr_sequencia = d.nr_seq_item)
WHERE a.cd_empresa	= cd_empresa_p and a.nr_sequencia	= c.nr_seq_tipo_item and b.nr_sequencia	= c.nr_seq_item  and e.nr_seq_item_sae	= b.nr_sequencia and (e.nr_seq_item_escala IS NOT NULL AND e.nr_seq_item_escala::text <> '') and e.ie_escala <> 105 and ((nr_seq_modelo_p = 0) or (d.nr_seq_modelo = nr_seq_modelo_p)) and ((d.cd_setor_pac = cd_setor_pac_p) or (coalesce(d.cd_setor_pac::text, '') = '')) and b.nr_sequencia not in (	SELECT   	distinct(nr_seq_item)
									from	pe_prescr_item_result a,
										pe_regra_item_escala c
									where	nr_seq_prescr = nr_prescricao_p
									and	a.nr_seq_item = c.nr_seq_item_sae
									and	(c.nr_seq_item_escala IS NOT NULL AND c.nr_seq_item_escala::text <> '')
									
union

									select  distinct(nr_seq_item)
									from    pe_result_item_diag b,
										pe_prescr_item_result a,
										pe_regra_item_escala c
									where   b.nr_seq_result = a.nr_seq_result
									and      a.nr_seq_item = c.nr_seq_item_sae
									and     (c.nr_seq_item_escala IS NOT NULL AND c.nr_seq_item_escala::text <> '')
									and     nr_seq_prescr = nr_prescricao_p) and c.nr_seq_tipo_item in (	select	distinct z.nr_seq_tipo_item
								from    pe_prescr_item_result x,
										pe_item_examinar y,
										pe_item_tipo_item z
								where  	nr_seq_prescr = nr_prescricao_p
								and		x.nr_seq_item = y.nr_sequencia
								and		y.nr_sequencia	= z.nr_seq_item) order by 1;

	/*Braden*/

	C02 CURSOR FOR
	SELECT	distinct a.ds_tipo_item||':'||b.ds_item
	FROM pe_item_tipo_item c, pe_tipo_item a, pe_item_examinar b
LEFT OUTER JOIN pe_sae_mod_item d ON (b.nr_sequencia = d.nr_seq_item)
WHERE a.cd_empresa	= cd_empresa_p and a.nr_sequencia	= c.nr_seq_tipo_item and b.nr_sequencia	= c.nr_seq_item  and (b.ie_braden IS NOT NULL AND b.ie_braden::text <> '') and ((nr_seq_modelo_p = 0) or (d.nr_seq_modelo = nr_seq_modelo_p)) and ((d.cd_setor_pac = cd_setor_pac_p) or (coalesce(d.cd_setor_pac::text, '') = '')) and b.nr_sequencia not in (	SELECT   	distinct(a.nr_seq_item)
									from	pe_prescr_item_result a,
										pe_item_resultado c
									where	nr_seq_prescr = nr_prescricao_p
									and	a.nr_seq_result = c.nr_sequencia
									and	(c.ie_item_braden IS NOT NULL AND c.ie_item_braden::text <> '')) and c.nr_seq_tipo_item in (	select	distinct z.nr_seq_tipo_item
								from    pe_prescr_item_result x,
										pe_item_examinar y,
										pe_item_tipo_item z
								where  	nr_seq_prescr = nr_prescricao_p
								and		x.nr_seq_item = y.nr_sequencia
								and		y.nr_sequencia	= z.nr_seq_item) order by 1;

	/*Morse*/

	C03 CURSOR FOR
	SELECT	distinct a.ds_tipo_item||':'||b.ds_item
	FROM pe_item_tipo_item c, pe_tipo_item a, pe_item_examinar b
LEFT OUTER JOIN pe_sae_mod_item d ON (b.nr_sequencia = d.nr_seq_item)
WHERE a.cd_empresa	= cd_empresa_p and a.nr_sequencia	= c.nr_seq_tipo_item and b.nr_sequencia	= c.nr_seq_item  and (b.ie_morse IS NOT NULL AND b.ie_morse::text <> '') and ((nr_seq_modelo_p = 0) or (d.nr_seq_modelo = nr_seq_modelo_p)) and ((d.cd_setor_pac = cd_setor_pac_p) or (coalesce(d.cd_setor_pac::text, '') = '')) and b.nr_sequencia not in (	SELECT   	distinct(a.nr_seq_item)
									from	pe_prescr_item_result a,
										pe_item_resultado c
									where	nr_seq_prescr = nr_prescricao_p
									and	a.nr_seq_result = c.nr_sequencia
									and	(c.ie_item_morse IS NOT NULL AND c.ie_item_morse::text <> '')) and c.nr_seq_tipo_item in (	select	distinct z.nr_seq_tipo_item
								from    pe_prescr_item_result x,
										pe_item_examinar y,
										pe_item_tipo_item z
								where  	nr_seq_prescr = nr_prescricao_p
								and		x.nr_seq_item = y.nr_sequencia
								and		y.nr_sequencia	= z.nr_seq_item) order by 1;


	/*Item ECA*/

	C04 CURSOR FOR
	SELECT	distinct a.ds_tipo_item||':'||b.ds_item
	FROM pe_item_tipo_item c, pe_tipo_item a, pe_item_examinar b
LEFT OUTER JOIN pe_sae_mod_item d ON (b.nr_sequencia = d.nr_seq_item)
WHERE a.cd_empresa	= cd_empresa_p and a.nr_sequencia	= c.nr_seq_tipo_item and b.nr_sequencia	= c.nr_seq_item  and (b.nr_seq_item IS NOT NULL AND b.nr_seq_item::text <> '') and ((nr_seq_modelo_p = 0) or (d.nr_seq_modelo = nr_seq_modelo_p)) and ((d.cd_setor_pac = cd_setor_pac_p) or (coalesce(d.cd_setor_pac::text, '') = '')) and b.nr_sequencia not in (	SELECT   	distinct(a.nr_seq_item)
									from	pe_prescr_item_result a,
										pe_item_resultado c
									where	nr_seq_prescr = nr_prescricao_p
									and	a.nr_seq_result = c.nr_sequencia
									and	(c.nr_seq_result IS NOT NULL AND c.nr_seq_result::text <> '')) and c.nr_seq_tipo_item in (	select	distinct z.nr_seq_tipo_item
								from    pe_prescr_item_result x,
										pe_item_examinar y,
										pe_item_tipo_item z
								where  	nr_seq_prescr = nr_prescricao_p
								and		x.nr_seq_item = y.nr_sequencia
								and		y.nr_sequencia	= z.nr_seq_item) order by 1;

	/*Score flex - Retirado a consistência, devido que esse tipo de escala possui consistência Sim ou Não( bollean) , sendo desnecessário a utilização desta forma

	Cursor C05 is
	select	distinct a.ds_tipo_item||':'||b.ds_item
	from	pe_item_tipo_item c,
			pe_item_examinar b,
			pe_tipo_item a,
			pe_sae_mod_item d
	where	a.cd_empresa	= cd_empresa_p
	and		a.nr_sequencia	= c.nr_seq_tipo_item
	and		b.nr_sequencia	= c.nr_seq_item
	and		b.nr_sequencia	= d.nr_seq_item(+)
	and		b.nr_seq_score_flex is not null
	and	    b.nr_seq_score_flex_item is not null
	and		((nr_seq_modelo_p = 0) or (d.nr_seq_modelo = nr_seq_modelo_p))
	and		((d.cd_setor_pac = cd_setor_pac_p) or (d.cd_setor_pac is null))
	and		b.nr_sequencia not in (	select   	distinct(a.nr_seq_item)
									from	pe_prescr_item_result a,
										pe_item_resultado c
									where	nr_seq_prescr = nr_prescricao_p
									and	a.nr_seq_result = c.nr_sequencia
									and	c.ie_resultado_score_flex is not null)
	and c.nr_seq_tipo_item in (	select	distinct z.nr_seq_tipo_item
								from    pe_prescr_item_result x,
										pe_item_examinar y,
										pe_item_tipo_item z
								where  	nr_seq_prescr = nr_prescricao_p
								and		x.nr_seq_item = y.nr_sequencia
								and		y.nr_sequencia	= z.nr_seq_item)
	order by 1;
	*/
BEGIN

open C01;
loop
fetch C01 into
	pendentes_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		if (pendentes_w IS NOT NULL AND pendentes_w::text <> '') then
			todos_pendentes_w := substr(todos_pendentes_w||pendentes_w||';'||chr(10)||chr(13),1,3900);
			total_pendentes_w := total_pendentes_w + 1;
		end if;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	pendentes_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
		if (pendentes_w IS NOT NULL AND pendentes_w::text <> '') then
			todos_pendentes_w := substr(todos_pendentes_w||pendentes_w||';'||chr(10)||chr(13),1,3900);
			total_pendentes_w := total_pendentes_w + 1;
		end if;
	end;
end loop;
close C02;

open C03;
loop
fetch C03 into
	pendentes_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
		if (pendentes_w IS NOT NULL AND pendentes_w::text <> '') then
			todos_pendentes_w := substr(todos_pendentes_w||pendentes_w||';'||chr(10)||chr(13),1,3900);
			total_pendentes_w := total_pendentes_w + 1;
		end if;
	end;
end loop;
close C03;

open C04;
loop
fetch C04 into
	pendentes_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin
		if (pendentes_w IS NOT NULL AND pendentes_w::text <> '') then
			todos_pendentes_w := substr(todos_pendentes_w||pendentes_w||';'||chr(10)||chr(13),1,3900);
			total_pendentes_w := total_pendentes_w + 1;
		end if;
	end;
end loop;
close C04;

/*Score flex - Retirado a consistência, devido que esse tipo de escala possui consistência Sim ou Não( bollean) , sendo desnecessário a utilização desta forma
open C05;
loop
fetch C05 into
	pendentes_w;
exit when C05%notfound;
	begin
		if (pendentes_w is not null) then
			todos_pendentes_w := substr(todos_pendentes_w||pendentes_w||';'||chr(10)||chr(13),1,3900);
			total_pendentes_w := total_pendentes_w + 1;
		end if;
	end;
end loop;
close C05;
*/
retorno_w := todos_pendentes_w;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_item_escala_sae ( nr_prescricao_p bigint, cd_empresa_p bigint, nr_seq_modelo_p bigint, cd_setor_pac_p text) FROM PUBLIC;

