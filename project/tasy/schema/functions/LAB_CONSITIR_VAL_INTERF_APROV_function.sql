-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_consitir_val_interf_aprov (nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS bigint AS $body$
DECLARE

qt_exames_consist_w	integer;
nr_seq_result_w		bigint;
qt_itens_w			bigint;
vl_resultado_w 		double precision;
nr_seq_regra_w		bigint;
ds_regra_w			varchar(255);
qt_resultado_desc_w varchar(15);

C01 CURSOR FOR
	SELECT 	b.nr_sequencia,
			b.ds_resultado,
			coalesce(a.qt_resultado,0)
	from 	lab_exame_valor_interf b,
			exame_lab_result_item a
	where	((a.nr_seq_exame = b.nr_seq_exame) or (b.nr_seq_grupo = obter_grupo_exame_lab(a.nr_seq_exame)))
	and		a.nr_seq_resultado = nr_seq_result_w
	and		a.nr_seq_prescr = nr_seq_prescr_p
	and		(a.qt_resultado IS NOT NULL AND a.qt_resultado::text <> '')
	and (b.ds_resultado like '%>%' or b.ds_resultado like '%<%' or b.ds_resultado like '%=%' or b.ds_resultado like '%between%');


BEGIN

select 	count(*)
into STRICT	qt_itens_w
from	lab_exame_valor_interf;

qt_exames_consist_w	:= 0;

if (qt_itens_w > 0) then

	select 	max(nr_seq_resultado)
	into STRICT	nr_seq_result_w
	from	exame_lab_resultado
	where	nr_prescricao_p = nr_prescricao;

	--tratamento para verificar apenas os exames que estão no formato. OS 538327 (ajustado na OS 557338 para 'exists' pois a ligação com a exame_lab_format_item não retornava valor para os analitos)
	SELECT  count(*)
	INTO STRICT	qt_exames_consist_w
	FROM 	exame_lab_result_item a,
			lab_exame_valor_interf b
	WHERE	a.nr_seq_prescr = nr_seq_prescr_p
	AND	((a.nr_seq_exame = b.nr_seq_exame) OR (b.nr_seq_grupo = obter_grupo_exame_lab(a.nr_seq_exame)))
	AND	a.qt_resultado	= b.qt_resultado
	AND	a.nr_seq_resultado = nr_seq_result_w
	AND	EXISTS (SELECT 1
			FROM   exame_lab_format_item x
			WHERE  x.nr_seq_exame = a.nr_seq_exame);

	if (qt_exames_consist_w = 0) then

		select 	count(*)
		into STRICT	qt_exames_consist_w
		from 	exame_lab_result_item a,
				lab_exame_valor_interf b,
				exame_laboratorio c
		where	nr_seq_prescr = nr_seq_prescr_p
		and		((a.nr_seq_exame = b.nr_seq_exame) or (b.nr_seq_grupo = obter_grupo_exame_lab(a.nr_seq_exame)))
		and		a.ds_resultado	= b.ds_resultado
		and		a.nr_Seq_exame = c.nr_seq_exame
		and		ie_formato_resultado in ('SM','D','DL','SDM','MS','S')
		and		a.nr_seq_resultado = nr_seq_result_w;

		if (qt_exames_consist_w = 0) then
			--tratamento para regra com simbolo de > , < e =
			open c01;
			loop
			fetch c01 into 	nr_seq_regra_w,
							ds_regra_w,
							qt_resultado_desc_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */

				vl_resultado_w := obter_valor_dinamico('select 1 from dual where ' || qt_resultado_desc_w || ds_regra_w, vl_resultado_w);

				if (coalesce(vl_resultado_w::text, '') = '') or (vl_resultado_w = 0) then
					vl_resultado_w := obter_valor_dinamico('select 1 from dual where ' || qt_resultado_desc_w || replace(ds_regra_w, ',', '.'), vl_resultado_w);
				end if;

				if (coalesce(vl_resultado_w,0) > 0) then
					qt_exames_consist_w := vl_resultado_w;
					exit;
				end if;

			end loop;
			close c01;

		end if;
	end if;
end if;

return qt_exames_consist_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_consitir_val_interf_aprov (nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

