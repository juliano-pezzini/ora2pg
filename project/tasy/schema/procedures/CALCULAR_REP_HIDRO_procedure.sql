-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_rep_hidro ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* Variáveis da tabela Prescr_Rep_HE */

qt_peso_w						double precision;
qt_idade_dia_w					bigint;
qt_idade_mes_w					bigint;
qt_idade_ano_w					bigint;
qt_altura_cm_w					bigint;
qt_kcal_total_w					double precision;
qt_kcal_kg_w					double precision;
qt_etapa_w						bigint;
qt_nec_hidrica_diaria_w			double precision;
qt_elem_calcio_w				double precision;
qt_teste_w						double precision;
qt_aporte_hidrico_diario_w		double precision;
qt_vel_inf_glicose_w			double precision;
qt_nec_kcal_kg_dia_w			double precision;
qt_nec_kcal_dia_w				double precision;
qt_equipo_w						double precision;
qt_soma_outros_w				double precision;
pr_conc_glic_solucao_w			double precision;
ie_magnesio_w					varchar(01);
ie_calculo_auto_w				varchar(01);
ie_correcao_w					varchar(01);
ie_peso_calorico_w				varchar(01);
hr_prim_horario_w				varchar(05);
qt_gotejo_w						double precision;
ie_emissao_w					varchar(01);
qt_be_w							double precision;
qt_vol_desconto_w				bigint;
qt_hora_validade_w				bigint;
qt_hora_fase_w					bigint;
nr_seq_glicose_w				bigint;
qt_g_glic_kg_dia_w				double precision;
qt_vol_glic_w					double precision;
qt_g_glic_dia_w					double precision;
ie_equilibrio_w					varchar(01);
nr_seq_elemento_w				bigint;
nr_seq_pac_elem_w				bigint;
nr_seq_glic_troca_w				bigint;
qt_vol_elemento_w				double precision;
qt_vol_total_w					double precision;
qt_conversao_ml_w				double precision;
qt_produto_w					integer;
qt_g_menor_w					double precision;
qt_g_maior_w					double precision;
qt_troca_glicose_w				bigint;
nr_seq_ele_rep_w				bigint;
qt_volume_w						double precision;
qt_vol_cor_w					double precision;
qt_vol_etapa_w					double precision;
qt_min_dia_w					bigint;
qt_gotas_w						bigint;
ie_processo_hidrico_w			varchar(1);

C01 CURSOR FOR
SELECT	a.nr_sequencia,
		b.qt_conversao_ml,
		a.nr_seq_ele_rep
from	nut_elem_material b,
		Prescr_Rep_HE_elem_mat a,
		Prescr_Rep_HE_elem e
where	a.nr_seq_ele_rep	= e.nr_sequencia
and		a.nr_seq_elem_mat	= b.nr_sequencia
and		e.nr_seq_elemento	= nr_seq_glicose_w
and		e.nr_seq_Rep_HE		= nr_sequencia_p
and		qt_g_menor_w		> 0
and		coalesce(b.ie_tipo,'NPT')	= 'NPT'
order by qt_conversao_ml desc;

C02 CURSOR FOR
SELECT	b.nr_sequencia
from	nut_elem_material b
where	b.nr_seq_elemento       = nr_seq_glicose_w
and		b.nr_sequencia  not in (	select	nr_seq_ele_rep
									from	Prescr_Rep_HE_elem_mat
									where	nr_seq_ele_rep = nr_seq_pac_elem_w)
and		qt_conversao_ml < qt_conversao_ml_w
and		coalesce(b.ie_tipo,'NPT')	= 'NPT'
order by qt_conversao_ml;

c03 CURSOR FOR
SELECT	b.nr_sequencia,
		b.qt_volume,
		b.qt_vol_cor
from	Prescr_Rep_HE_elem_mat b,
		Prescr_Rep_HE_elem a
where	a.nr_seq_Rep_HE	= nr_sequencia_p
and		a.nr_sequencia	= b.nr_seq_ele_rep
and		coalesce(b.qt_volume,0)	> 0;


BEGIN

CALL Gerar_Nut_Elemento_Pac_HE(nr_sequencia_p, nm_usuario_p);

select	qt_peso,
		qt_idade_dia,
		qt_idade_mes,
		qt_idade_ano,
		qt_altura_cm,
		qt_kcal_total,
		qt_kcal_kg,
		qt_nec_hidrica_diaria,
		qt_aporte_hidrico_diario,
		qt_vel_inf_glicose,
		qt_nec_kcal_kg_dia,
		pr_conc_glic_solucao,
		qt_equipo,
		coalesce(ie_correcao,'N'),
		coalesce(qt_etapa,1),
		coalesce(qt_hora_validade,24),
		coalesce(ie_magnesio,'N'),
		coalesce(ie_peso_calorico,'S'),
		coalesce(ie_processo_hidrico,'N')
into STRICT	qt_peso_w,
		qt_idade_dia_w,
		qt_idade_mes_w,
		qt_idade_ano_w,
		qt_altura_cm_w,
		qt_kcal_total_w,
		qt_kcal_kg_w,
		qt_nec_hidrica_diaria_w,
		qt_aporte_hidrico_diario_w,
		qt_vel_inf_glicose_w,
		qt_nec_kcal_kg_dia_w,
		pr_conc_glic_solucao_w,
		qt_equipo_w,
		ie_correcao_w,
		qt_etapa_w,
		qt_hora_validade_w,
		ie_magnesio_w,
		ie_peso_calorico_w,
		ie_processo_hidrico_w
from	prescr_rep_he
where	nr_sequencia			= nr_sequencia_p;

if (qt_peso_w = 0) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(198202);
end if;

if (ie_peso_calorico_w = 'S') then
	if (qt_peso_w <= 10) then

		update	prescr_rep_he
		set		qt_nec_hidrica_diaria	= (qt_peso_w * 100) / qt_peso_w,
				qt_nec_kcal_kg_dia	= (qt_peso_w * 100) / qt_peso_w,
				qt_nec_kcal_dia		 = (qt_peso_w * 100),
				qt_aporte_hidrico_diario = (qt_peso_w * 100)
		where	nr_sequencia		= nr_sequencia_p;
	elsif (qt_peso_w > 10) and (qt_peso_w <= 20) then

		update	prescr_rep_he
		set		qt_nec_hidrica_diaria	= ((1000 + ((qt_peso_w - 10) * 50)) / qt_peso_w),
				qt_nec_kcal_kg_dia	= ((1000 + ((qt_peso_w - 10) * 50)) / qt_peso_w),
				qt_nec_kcal_dia		 = (1000 + ((qt_peso_w - 10) * 50)),
				qt_aporte_hidrico_diario = (1000 + ((qt_peso_w - 10) * 50))
		where	nr_sequencia		= nr_sequencia_p;
	elsif (qt_peso_w > 20) then

		update	prescr_rep_he
		set		qt_nec_hidrica_diaria	= ((1500 + ((qt_peso_w - 20) * 20)) / qt_peso_w),
				qt_nec_kcal_kg_dia	= ((1500 + ((qt_peso_w - 20) * 20)) / qt_peso_w),
				qt_nec_kcal_dia		 = 1500 + ((qt_peso_w - 20) * 20),
				qt_aporte_hidrico_diario = 1500 + ((qt_peso_w - 20) * 20)
		where	nr_sequencia		= nr_sequencia_p;
	end if;

	select 	qt_nec_hidrica_diaria,
			qt_aporte_hidrico_diario,
			qt_nec_kcal_kg_dia
	into STRICT	qt_nec_hidrica_diaria_w,
			qt_aporte_hidrico_diario_w,
			qt_nec_kcal_kg_dia_w
	from	prescr_rep_he
	where	nr_sequencia			= nr_sequencia_p;

end if;
if (ie_peso_calorico_w <> 'S') then
	qt_aporte_hidrico_diario_w		:= qt_nec_hidrica_diaria_w * qt_peso_w;
end if;

select	coalesce(sum(obter_vol_elem_rep_he(a.nr_sequencia)),0)
into STRICT	qt_soma_outros_w
from	nut_elemento b,
		prescr_rep_he_elem a
where	a.nr_seq_rep_he		= nr_sequencia_p
and		a.nr_seq_elemento	= b.nr_sequencia
and		b.ie_tipo_elemento	<> 'C';

qt_nec_kcal_dia_w			:= qt_nec_kcal_kg_dia_w * qt_peso_w;
if (qt_vel_inf_glicose_w > 0) then
	qt_g_Glic_kg_dia_w			:= trunc(qt_vel_inf_glicose_w * 1.44,1);
else
	select	max(z.qt_dose_padrao)
	into STRICT	qt_g_Glic_kg_dia_w
	from	prescr_rep_he_elem x,
			nut_elemento z
	where	nr_seq_rep_he		= nr_sequencia_p
	and		z.nr_sequencia		= x.nr_seq_elemento
	and		z.ie_tipo_elemento	= 'C'
	and		coalesce(z.ie_situacao,'A')	= 'A';

	qt_g_glic_dia_w			:= qt_g_glic_kg_dia_w * qt_peso_w;
	qt_vel_inf_glicose_w	:= dividir(dividir((qt_g_glic_dia_w * 1000),qt_peso_w),1440);

	update	prescr_rep_he
	set		qt_vel_inf_glicose	= qt_vel_inf_glicose_w
	where	nr_sequencia		= nr_sequencia_p;
	commit;
end if;
qt_vol_Glic_w				:= trunc(qt_aporte_hidrico_diario_w - qt_soma_outros_w); /* Ignora demais */
qt_g_glic_dia_w				:= qt_g_glic_kg_dia_w * qt_peso_w;

qt_kcal_total_w				:= qt_g_glic_dia_w * 4;
qt_kcal_kg_w				:= Dividir(qt_kcal_total_w, qt_peso_w);
pr_conc_glic_solucao_w		:= Dividir((qt_g_glic_dia_w * 100), qt_aporte_hidrico_diario_w);
qt_hora_fase_w				:= Dividir(qt_hora_validade_w, qt_etapa_w);

select 	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_glicose_w
from	nut_elemento
where	ie_tipo_elemento		= 'C';

if (ie_peso_calorico_w = 'S') then
	qt_g_glic_dia_w			:= qt_aporte_hidrico_diario_w	* 0.08;
	qt_g_Glic_kg_dia_w		:= dividir(qt_g_glic_dia_w, qt_peso_w);
	qt_vel_inf_glicose_w	:= dividir(dividir((qt_g_glic_dia_w * 1000),qt_peso_w),1440);

	update	prescr_rep_he
	set		qt_vel_inf_glicose	= qt_vel_inf_glicose_w
	where	nr_sequencia		= nr_sequencia_p;

end if;

update	prescr_rep_he_elem
set		qt_elem_kg_dia		= qt_g_Glic_kg_dia_w,
		qt_diaria			= qt_g_glic_dia_w
where	nr_seq_rep_he		= nr_sequencia_p
and		nr_seq_elemento		= nr_seq_glicose_w;

update	prescr_rep_he
set		qt_kcal_total				= coalesce(qt_kcal_total_w,0),
		qt_kcal_kg					= coalesce(qt_kcal_kg_w,0),
		qt_aporte_hidrico_diario	= CASE WHEN ie_peso_calorico_w='S' THEN  qt_aporte_hidrico_diario  ELSE qt_aporte_hidrico_diario_w END ,
		qt_nec_kcal_dia				= CASE WHEN ie_peso_calorico_w='S' THEN qt_nec_kcal_dia  ELSE qt_nec_kcal_dia_W END ,
		pr_conc_glic_solucao		= pr_conc_glic_solucao_w,
		qt_etapa					= qt_etapa_w,
		qt_hora_validade			= qt_hora_validade_w,
		qt_hora_fase				= qt_hora_fase_w
where	nr_sequencia				= nr_sequencia_p;

CALL calcular_nut_elemento_pac_he(nr_sequencia_p, nm_usuario_p);

if (ie_magnesio_w = 'S') then
	select	max(qt_elem_kg_dia)
	into STRICT	qt_elem_calcio_w
	from	prescr_rep_he_elem x,
			nut_elemento z
	where	nr_seq_rep_he		= nr_sequencia_p
	and		z.nr_sequencia		= x.nr_seq_elemento
	and		z.ie_tipo_elemento	= 'I'
	and		coalesce(z.ie_situacao,'A')	= 'A';

	begin
	update	prescr_rep_he_elem x
	set		qt_elem_kg_dia		= coalesce(dividir(qt_elem_calcio_w,4),0)
	where	nr_seq_rep_he		= nr_sequencia_p
	and		qt_elem_calcio_w	> 0
	and		x.nr_seq_elemento	= (	SELECT	max(z.nr_sequencia)
									from	nut_elemento z
									where	z.ie_tipo_elemento	= 'M'
									and		coalesce(z.ie_situacao,'A')	= 'A');
	exception when others then
		null;
	end;
end if;

/* Equilibrar Glicose x Balanço Hidrico */

qt_produto_w				:= 0;
qt_vol_total_w				:= 0;
ie_equilibrio_w				:= 'S';
qt_troca_glicose_w			:= 0;
qt_g_menor_w				:= 999;

select	qt_aporte_hidrico_diario
into STRICT	qt_aporte_hidrico_diario_w
from	prescr_rep_he
where	nr_sequencia = nr_sequencia_p;

open C01;
loop
fetch C01	into
	nr_seq_elemento_w,
	qt_conversao_ml_w,
	nr_seq_pac_elem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	qt_produto_w			:= qt_produto_w + 1;
	if (qt_produto_w = 1) then
		qt_vol_elemento_w	:= qt_g_glic_dia_w * qt_conversao_ml_w;
		qt_vol_total_w		:= qt_vol_elemento_w;
		qt_g_menor_w		:= qt_g_glic_dia_w;
		qt_g_maior_w		:= 0;
		nr_seq_glic_Troca_w	:= nr_seq_elemento_w;
	else
		qt_vol_elemento_w	:= 0;
	end if;

	update	prescr_rep_he_elem_mat
	set		qt_volume		= qt_vol_elemento_w,
			qt_vol_cor		= 0
	where	nr_sequencia	= nr_seq_elemento_w;
end loop;
close C01;

if (qt_vol_total_w <= qt_vol_glic_w) then
	ie_equilibrio_w			:= 'S';
elsif (qt_produto_w	= 2) then
	ie_equilibrio_w			:= 'N';
end if;
while(ie_equilibrio_w = 'N') loop
	if (qt_vol_total_w > 0) and (qt_vol_total_w <= qt_vol_glic_w) then
		ie_equilibrio_w		:= 'S';
	elsif (qt_vol_total_w = 0) and (qt_troca_glicose_w > 7) then
		ie_equilibrio_w		:= 'S';
	elsif (qt_vol_total_w = 0) or (qt_g_menor_w < 0) then
		nr_seq_elemento_w		:= 0;
		open C02;
		loop
		fetch C02	into
			nr_seq_elemento_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			nr_seq_elemento_w	:= nr_seq_elemento_w;
		end loop;
		close C02;
		if (nr_seq_elemento_w > 0) then
			qt_troca_glicose_w	:= qt_troca_glicose_w + 1;
			update	prescr_rep_he_elem_mat
			set		nr_seq_elem_mat = nr_seq_elemento_w
			where	nr_sequencia	= nr_seq_glic_Troca_w;
		else
			ie_equilibrio_w	:= 'S';
		end if;
	else
		qt_g_menor_w		:= qt_g_menor_w - 1;
		qt_g_maior_w		:= qt_g_maior_w + 1;
		qt_vol_total_w		:= 0;
		open C01;
		loop
		fetch C01	into
			nr_seq_elemento_w,
			qt_conversao_ml_w,
			nr_seq_pac_elem_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			if (qt_vol_total_w = 0) then
				qt_vol_elemento_w	:= qt_g_menor_w * qt_conversao_ml_w;
			else
				qt_vol_elemento_w	:= qt_g_maior_w * qt_conversao_ml_w;
			end if;
			qt_vol_total_w		:= qt_vol_total_w + qt_vol_elemento_w;

			update	Prescr_Rep_HE_elem_mat
			set		qt_volume	= qt_vol_elemento_w
			where	nr_sequencia	= nr_seq_elemento_w;
		end loop;
		close C01;
	end if;
end loop;

select	sum(b.qt_volume)
into STRICT	qt_vol_total_w
from	Prescr_Rep_HE_elem_mat b,
		prescr_rep_he_elem a
where	a.nr_seq_Rep_HE	= nr_sequencia_p
and		a.nr_sequencia	= b.nr_seq_ele_rep;

open C03;
loop
fetch C03	into
	nr_seq_ele_rep_w,
	qt_volume_w,
	qt_vol_cor_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	if (coalesce(qt_aporte_hidrico_diario_w,0) > 0) then
		qt_vol_cor_w		:= round(qt_volume_w * ((qt_aporte_hidrico_diario_w + qt_equipo_w) / qt_aporte_hidrico_diario_w),4);
		qt_vol_etapa_w		:= dividir(qt_vol_cor_w, coalesce(qt_etapa_w,1));
	end if;
	update 	prescr_rep_he_elem_mat
	set		qt_vol_cor		= qt_vol_cor_w,
			qt_vol_etapa	= qt_vol_etapa_w
	where	nr_sequencia	= nr_seq_ele_rep_w;
end loop;
close C03;

update	prescr_rep_he_elem a
set		qt_volume_corrigido	= (	SELECT	coalesce(sum(b.qt_vol_cor),0)
								from	prescr_rep_he_elem_mat b
								where	a.nr_sequencia= b.nr_seq_ele_rep),
		qt_volume_etapa		= (	select	coalesce(sum(b.qt_vol_etapa),0)
								from	prescr_rep_he_elem_mat b
								where	a.nr_sequencia= b.nr_seq_ele_rep),
		qt_volume			= (	select	coalesce(sum(b.qt_volume),0)
								from	prescr_rep_he_elem_mat b
								where	a.nr_sequencia= b.nr_seq_ele_rep)
where	nr_seq_rep_he	= nr_sequencia_p;

/* Calcular o gotejo em gotas por minuto */

qt_min_dia_w	:= 60 * qt_hora_validade_w;
qt_gotas_w		:= 20 * qt_vol_total_w;
qt_gotejo_w		:= round((dividir(qt_gotas_w, qt_min_dia_w))::numeric,0);

update	prescr_rep_he
set		qt_gotejo		= qt_gotejo_w
where	nr_sequencia	= nr_sequencia_p;

commit;

if (ie_processo_hidrico_w = 'N') then
	CALL Ajustar_Vol_Glic_TREV(nr_sequencia_p,nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_rep_hidro ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

