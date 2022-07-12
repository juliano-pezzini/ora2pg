-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gedipa_obter_saldo_sep (cd_material_p bigint, cd_unidade_medida_p text, qt_saldo_barras_p bigint, nr_seq_area_prep_p bigint, nr_seq_etapa_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w				double precision;
cd_unidade_medida_cons_w	varchar(30);
qt_saldo_estoque_w			double precision;
qt_dose_w					double precision;
nr_seq_ficha_tecnica_w		bigint;


BEGIN
qt_retorno_w := qt_saldo_barras_p;
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (cd_unidade_medida_p IS NOT NULL AND cd_unidade_medida_p::text <> '') and (qt_saldo_barras_p IS NOT NULL AND qt_saldo_barras_p::text <> '') and (nr_seq_area_prep_p IS NOT NULL AND nr_seq_area_prep_p::text <> '')	then
	
	select 	max(nr_seq_ficha_tecnica)
	into STRICT	nr_seq_ficha_tecnica_w
	from	material
	where	cd_material = cd_material_p;

	select 	coalesce(sum(a.qt_dose),0)
	into STRICT	qt_dose_w
    from 	gedipa_etapa_hor a,
     		prescr_material b,
     		prescr_medica c,
     		pessoa_fisica d,
     		material e,
     		prescr_mat_hor f,
    		gedipa_etapa_producao g
    where 	a.nr_seq_horario 		= f.nr_sequencia
    and 	f.nr_prescricao 		= b.nr_prescricao
    and 	f.nr_seq_material 		= b.nr_sequencia
    and 	b.nr_prescricao 		= c.nr_prescricao
    and 	c.cd_pessoa_fisica 		= d.cd_pessoa_fisica
    and 	a.cd_material 			= e.cd_material
    and 	g.nr_sequencia 			= a.nr_seq_etapa_gedipa	
    and 	((a.cd_material 		= cd_material_p) or (e.nr_seq_ficha_tecnica = nr_seq_ficha_tecnica_w))
	and		a.dt_horario			> clock_timestamp() - interval '15 days'
	and		f.nr_seq_area_prep 		= nr_seq_area_prep_p	
    and		a.ie_status_preparo	  	=	'P'
	and		g.nr_sequencia 			<>	nr_seq_etapa_p;

	select	coalesce(sum(a.qt_estoque),0)
	into STRICT	qt_saldo_estoque_w
	from	gedipa_estoque_cabine a,
			material b
	where	a.cd_material	=	b.cd_material	
	and		a.qt_estoque > 0
	and		((a.cd_material 			= cd_material_p) or (b.nr_seq_ficha_tecnica = nr_seq_ficha_tecnica_w))
	and		a.nr_seq_area_prep	=	nr_seq_area_prep_p;
	
	if (qt_dose_w > qt_saldo_estoque_w) then
		qt_dose_w := qt_saldo_estoque_w;
	end if;

    qt_retorno_w := qt_saldo_barras_p - (qt_saldo_estoque_w - qt_dose_w);

    if (qt_retorno_w < 0) then
    	qt_retorno_w := 0;
    end if;	
	
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gedipa_obter_saldo_sep (cd_material_p bigint, cd_unidade_medida_p text, qt_saldo_barras_p bigint, nr_seq_area_prep_p bigint, nr_seq_etapa_p bigint) FROM PUBLIC;

