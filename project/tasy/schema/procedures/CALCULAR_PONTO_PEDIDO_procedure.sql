-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE reg_medias AS ( 
	qt_consumo	double precision);


CREATE OR REPLACE PROCEDURE calcular_ponto_pedido ( cd_estabelecimento_p bigint, qt_meses_Consumo_p bigint, dt_parametro_p timestamp, dt_periodo_inicio_p timestamp, dt_periodo_final_p timestamp, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


type medias is table of reg_medias index by integer;

 
sql_errm_w			varchar(255);
cd_material_w			integer  := 0;
qt_estoque_minimo_w		double precision := 0;
qt_estoque_maximo_w		double precision := 0;
qt_ponto_pedido_w			double precision := 0;
qt_estoque_w			double precision := 0;
qt_dia_ressup_forn_w		smallint;
qt_dia_interv_ressup_w		smallint;
qt_dia_estoque_Minimo_w		smallint;
qt_consumo_w			double precision;
qt_consumo_ressup_w		double precision;
qt_consumo_mensal_w		double precision;
qt_consumo_mensal_ressup_w	double precision;
qt_consumo_diario_w		double precision;
qt_meses_consumo_w		smallint;
qt_meses_consumo_ressup_w	smallint;
qt_compra_w			double precision;
qt_Consumo_Mes_w		double precision;
qt_Consumo_Mes_ressup_w		double precision;
dt_mesano_referencia_w		timestamp;
dt_parametro_w			timestamp;
dt_parametro_inicio_w		timestamp;
qt_meses_w			smallint;
qt_dia_total_w			bigint;
nr_sequencia_w			bigint;
nr_minimo_cotacao_w		bigint;
cd_material_conta_w		bigint;
cd_kit_material_w			bigint;
qt_peso_kg_w			double precision;
ie_baixa_estoq_pac_w		varchar(01);
ie_material_estoque_w		varchar(01);
cd_estabelecimento_base_w		bigint;
qt_existe_peso_w			integer;
vl_peso_mes_w			double precision;
ie_mes_atual_consumo_w		varchar(1);
ie_regra_mes_consumo_w		varchar(1);
ie_soma_dias_min_fornec_w		varchar(1);
ie_soma_dias_max_fornec_w		varchar(1);
ie_ponto_so_ult_meses_w		varchar(1);
ie_atualiza_consumo_consig_w	varchar(1);
ie_consumo_ressup_w		varchar(1);

i				smallint	:= 0;
medias_w				medias;
soma_consumo_w			double precision;
variancia_w			double precision;
total_variancia_w			double precision;
qt_desvio_padrao_cons_w		double precision;
ie_arredonda_acima_ponto_w		varchar(1);

dt_periodo_final_w		timestamp;

 
c01 CURSOR FOR 
SELECT	/*+ INDEX(A) */ 
	a.cd_material, 
	coalesce(a.qt_dia_ressup_forn, qt_dia_ressup_forn_w), 
	coalesce(a.qt_dia_interv_ressup, qt_dia_interv_ressup_w) , 
	qt_dia_estoque_minimo, 
	a.qt_estoque_minimo, 
	a.qt_estoque_maximo, 
	a.qt_ponto_pedido, 
	(coalesce(a.qt_dia_ressup_forn,0) + coalesce(qt_dia_interv_ressup,0) + coalesce(a.qt_dia_estoque_minimo,0)) qt_dia_ressup, 
	coalesce(a.nr_minimo_cotacao,1) , 
	a.cd_material_conta, 
	a.cd_kit_material, 
	a.qt_peso_kg, 
	coalesce(a.ie_material_estoque,'N'), 
	coalesce(a.ie_baixa_estoq_pac,'N') 
from	estrutura_material_v b, 
	material_estab a 
where	a.cd_material = b.cd_material 
and	a.cd_estabelecimento = cd_estabelecimento_p 
and (b.cd_grupo_material = coalesce(cd_grupo_material_p,0) or coalesce(cd_grupo_material_p,0) = 0) 
and (b.cd_subgrupo_material = coalesce(cd_subgrupo_material_p,0) or coalesce(cd_subgrupo_material_p,0) = 0) 
and (b.cd_classe_material = coalesce(cd_classe_material_p,0) or coalesce(cd_classe_material_p,0) = 0) 
and	b.ie_situacao = 'A' 
and	exists( 
	SELECT	/*+ INDEX(SALESTO_I2 X) */ 
		cd_material 
	from	saldo_estoque x 
	where	x.cd_estabelecimento 	= a.cd_estabelecimento 
	and	x.cd_material		= a.cd_material 
	and	((ie_ponto_so_ult_meses_w = 'N') or (ie_ponto_so_ult_meses_w = 'S' and x.dt_mesano_referencia	>= PKG_DATE_UTILS.ADD_MONTH(dt_parametro_w,-3,0))));

c02 CURSOR FOR 
SELECT	/*+ INDEX(A) */ 
	a.dt_mesano_referencia, 
	sum(a.qt_consumo) 
from 	Operacao_estoque b, 
	Local_estoque c, 
	movto_estoque_operacao_v a 
where 	a.cd_material 		= cd_material_w 
and 	a.dt_mesano_referencia 	between dt_parametro_inicio_w and dt_parametro_w 
and	a.cd_operacao_estoque	= b.cd_operacao_estoque 
and	a.cd_local_estoque		= c.cd_local_estoque 
and	c.ie_proprio		= 'S' 
and	coalesce(b.ie_consumo,'N')	<> 'N' 
and	coalesce(a.ie_consignado,'N')	= 'N' 
and	coalesce(a.qt_consumo,0) 	<> 0 
and	a.cd_estabelecimento	= cd_estabelecimento_p 
and	coalesce(dt_periodo_inicio_p::text, '') = '' 
and	coalesce(dt_periodo_final_p::text, '') = '' 
group by	a.dt_mesano_referencia 
having	sum(a.qt_consumo) > 0 

union
 
SELECT	a.dt_mesano_referencia, 
	sum(qt_consumo) 
from	movimento_estoque_v a, 
	material m 
where	a.cd_material_estoque	= m.cd_material_estoque 
and	((a.ie_atualiza_estoque = 'S') or (a.ie_consignado in (2,3,4,5,6,7))) /*Somente movimentos que atualizaram estoque*/
 
and	m.cd_material		= cd_material_w 
and	a.cd_estabelecimento	= cd_estabelecimento_p 
and	a.dt_movimento_estoque	between dt_periodo_inicio_p and dt_periodo_final_w 
and	(dt_periodo_inicio_p IS NOT NULL AND dt_periodo_inicio_p::text <> '') 
and	(dt_periodo_final_p IS NOT NULL AND dt_periodo_final_p::text <> '') 
group by	a.dt_mesano_referencia 
having	sum(qt_consumo) > 0 
order by 1;

 
c03 CURSOR FOR 
SELECT	/*+ INDEX(A) */ 
	a.dt_mesano_referencia, 
	sum(a.qt_consumo) 
from 	Operacao_estoque b, 
	Local_estoque c, 
	movto_estoque_operacao_v a 
where 	a.cd_material 		= cd_material_w 
and 	a.dt_mesano_referencia 	between dt_parametro_inicio_w and dt_parametro_w 
and	a.cd_operacao_estoque	= b.cd_operacao_estoque 
and	a.cd_local_estoque		= c.cd_local_estoque 
and	c.ie_proprio		= 'S' 
and	coalesce(b.ie_consumo,'N')	<> 'N' 
and	coalesce(a.ie_consignado,'N')	= 'N' 
and	coalesce(a.qt_consumo,0) 	<> 0 
and	a.cd_estabelecimento	= cd_estabelecimento_p 
and	coalesce(dt_periodo_inicio_p::text, '') = '' 
and	coalesce(dt_periodo_final_p::text, '') = '' 
and	coalesce(b.ie_desconsidera_cons_ressup,'N') = 'N' 
group by	a.dt_mesano_referencia 
having	sum(a.qt_consumo) > 0 

union
 
SELECT	a.dt_mesano_referencia, 
	sum(qt_consumo) 
from	movimento_estoque_v a, 
	material m, 
	operacao_estoque o 
where	a.cd_material_estoque	= m.cd_material_estoque 
and	((a.ie_atualiza_estoque = 'S') or (a.ie_consignado in (2,3,4,5,6,7))) /*Somente movimentos que atualizaram estoque*/
 
and	m.cd_material		= cd_material_w 
and	a.cd_estabelecimento	= cd_estabelecimento_p 
and	a.cd_operacao_estoque	= o.cd_operacao_estoque 
and	a.dt_movimento_estoque	between dt_periodo_inicio_p and dt_periodo_final_w 
and	(dt_periodo_inicio_p IS NOT NULL AND dt_periodo_inicio_p::text <> '') 
and	(dt_periodo_final_p IS NOT NULL AND dt_periodo_final_p::text <> '') 
and	coalesce(o.ie_desconsidera_cons_ressup,'N') = 'N' 
group by	a.dt_mesano_referencia 
having	sum(qt_consumo) > 0 
order by 1;


BEGIN 
delete from w_calculo_ponto;
 
/*Tratamento OS 439428*/
 
dt_periodo_final_w := PKG_DATE_UTILS.END_OF(coalesce(dt_periodo_final_p,clock_timestamp()), 'DAY', 0);
		--(trunc(nvl(dt_periodo_final_p,sysdate),'dd') + 86399/86400); 
 
begin 
select	coalesce(qt_dia_ressup_forn,3), 
	coalesce(qt_dia_interv_ressup,10), 
	coalesce(qt_mes_consumo,12), 
	coalesce(ie_mes_atual_consumo, 'S'), 
	coalesce(ie_regra_mes_consumo, 'N'), 
	coalesce(ie_soma_dias_min_fornec, 'N'), 
	coalesce(ie_soma_dias_max_fornec, 'N'), 
	coalesce(ie_ponto_so_ult_meses,'S'), 
	coalesce(ie_ponto_consignado,'N'), 
	coalesce(ie_arredonda_acima_ponto,'N'), 
	coalesce(ie_consumo_ressup,'S')	 
into STRICT	qt_dia_ressup_forn_w, 
	qt_dia_interv_ressup_w, 
	qt_meses_w, 
	ie_mes_atual_consumo_w, 
	ie_regra_mes_consumo_w, 
	ie_soma_dias_min_fornec_w, 
	ie_soma_dias_max_fornec_w, 
	ie_ponto_so_ult_meses_w, 
	ie_atualiza_consumo_consig_w, 
	ie_arredonda_acima_ponto_w, 
	ie_consumo_ressup_w 
from	parametro_compras 
where	cd_estabelecimento	= cd_estabelecimento_p;
exception 
	when no_data_found then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(181892);
		/*r.aise_application_error(-20011,'Não foi encontrado os parametros de dias de ressuprimento nos parametros de compras');*/
 
end;
 
select	count(*) 
into STRICT	qt_existe_peso_w 
from	sup_peso_media_consumo 
where	cd_estabelecimento = cd_estabelecimento_p;
 
select	coalesce(max(cd_estabelecimento_base),0) 
into STRICT	cd_estabelecimento_base_w 
from	parametro_geral_tasy;
 
if (qt_meses_Consumo_p > 0) then 
	qt_meses_w		:= qt_meses_Consumo_p;
end if;
 
dt_parametro_w			:= PKG_DATE_UTILS.start_of(dt_parametro_p,'month',0);
dt_parametro_inicio_w		:= PKG_DATE_UTILS.ADD_MONTH(dt_parametro_w, (qt_meses_w -1) * -1, 0);
 
/*Identifica se considera mes atual. Se não simplesmesnte adiciona -1 nos meses de busca*/
 
if (ie_mes_atual_consumo_w = 'N') then 
	dt_parametro_w		:= PKG_DATE_UTILS.ADD_MONTH(dt_parametro_w, -1, 0);
	dt_parametro_inicio_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_parametro_inicio_w, -1, 0);
end if;
 
insert into log_val_estoque( 
			cd_log, 
			ds_log, 
			dt_atualizacao, 
			nm_usuario, 
			cd_estabelecimento) 
		values (	3, 
			wheb_mensagem_pck.get_texto(310440,'DT_PARAMETRO_W='||to_char(dt_parametro_w,'dd/mm/yyyy')), 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p);
commit;
 
open c01;
loop 
fetch c01 into 
	cd_material_w, 
	qt_dia_ressup_forn_w, 
	qt_dia_interv_ressup_w, 
	qt_dia_estoque_minimo_w, 
	qt_estoque_minimo_w, 
	qt_estoque_maximo_w, 
	qt_ponto_pedido_w, 
	qt_dia_total_w, 
	nr_minimo_cotacao_w, 
	cd_material_conta_w, 
	cd_kit_material_w, 
	qt_peso_kg_w, 
	ie_material_estoque_w, 
	ie_baixa_estoq_pac_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	qt_desvio_padrao_cons_w		:= 0;
	qt_consumo_mensal_w		:= 0;
	qt_consumo_mensal_ressup_w	:= 0;
	qt_meses_consumo_w		:= 0;
	qt_meses_consumo_ressup_w	:= 0;
	i				:= 0;
	qt_consumo_w			:= 0;
	qt_consumo_ressup_w		:= 0;
	medias_w.delete;
 
	if (ie_soma_dias_min_fornec_w = 'S') then 
		qt_dia_estoque_minimo_w		:= qt_dia_estoque_minimo_w + qt_dia_ressup_forn_w;
	end if;
 
	open c02;
	loop 
	fetch c02 into 
		dt_mesano_referencia_w, 
		qt_Consumo_Mes_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		if (qt_consumo_mes_w > 0) then 
			begin 
			/*Sazionalidade do material OS28421*/
 
			if (qt_existe_peso_w > 0) then 
				select	obter_peso_media_consumo(PKG_DATE_UTILS.start_of(dt_mesano_referencia_w,'month',0), cd_material_w, cd_estabelecimento_p) 
				into STRICT	vl_peso_mes_w 
				;
				qt_consumo_mes_w	:= qt_consumo_mes_w * coalesce(vl_peso_mes_w,1);
			end if;
 
			qt_consumo_w 			:= qt_consumo_w + qt_consumo_mes_w;
			qt_meses_consumo_w		:= qt_meses_consumo_w + 1;
			i				:= i + 1;
			medias_w[i].qt_consumo		:= qt_consumo_mes_w;
 
			if (ie_regra_mes_consumo_w = 'S') then 
				qt_meses_consumo_w	:= qt_meses_w;
			end if;
			end;
		end if;
		end;
	end loop;
	close c02;
 
 
	if (qt_meses_consumo_w > 0) then 
		begin 
		qt_consumo_mensal_w	:= dividir(qt_consumo_w, qt_meses_consumo_w);
 
		/*Calculo do desvio padrao do consumo*/
 
		begin 
		total_variancia_w		:= 0;
		for i in 1..medias_w.Count loop 
			begin 
			soma_consumo_w		:= medias_w[i].qt_consumo - qt_consumo_mensal_w;		
			variancia_w		:= round((soma_consumo_w * soma_consumo_w)::numeric, 4);
			total_variancia_w	:= total_variancia_w + variancia_w;
			end;
		end loop;
		qt_desvio_padrao_cons_w		:= round((sqrt(dividir(total_variancia_w, qt_meses_consumo_w)))::numeric,4);
		exception when others then 
			qt_desvio_padrao_cons_w	:= 0;
			sql_errm_w		:= sqlerrm;
		end;
		end;
	end if;
	 
	/*Para calcular o consumo das operações que consideram no ressuprimento*/
 
	open c03;
	loop 
	fetch c03 into 
		dt_mesano_referencia_w, 
		qt_Consumo_Mes_ressup_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin 
		if (qt_Consumo_Mes_ressup_w > 0) then 
			begin 
			/*Sazionalidade do material OS28421*/
 
			if (qt_existe_peso_w > 0) then 
				select	obter_peso_media_consumo(PKG_DATE_UTILS.start_of(dt_mesano_referencia_w,'month',0), cd_material_w, cd_estabelecimento_p) 
				into STRICT	vl_peso_mes_w 
				;
				qt_Consumo_Mes_ressup_w	:= qt_Consumo_Mes_ressup_w * coalesce(vl_peso_mes_w,1);
			end if;
 
			qt_consumo_ressup_w		:= qt_consumo_ressup_w + qt_Consumo_Mes_ressup_w;
			qt_meses_consumo_ressup_w	:= qt_meses_consumo_ressup_w + 1;
			i				:= i + 1;
			medias_w[i].qt_consumo		:= qt_Consumo_Mes_ressup_w;
 
			if (ie_regra_mes_consumo_w = 'S') then 
				qt_meses_consumo_ressup_w	:= qt_meses_w;
			end if;
			end;
		end if;
		end;
	end loop;
	close c03;	
	 
	if (qt_meses_consumo_ressup_w > 0) then 
		begin 
		qt_consumo_mensal_ressup_w	:= dividir(qt_consumo_ressup_w, qt_meses_consumo_ressup_w);		
		end;
	end if;
	/*Fom alteração ressuprimento*/
 
 
	if (ie_consumo_ressup_w = 'N') then 
		qt_consumo_diario_w		:= round((dividir(qt_consumo_mensal_ressup_w, 30))::numeric,4);
	else 
		qt_consumo_diario_w		:= round((dividir(qt_consumo_mensal_w, 30))::numeric,4);
	end if;
 
	if (qt_dia_total_w > 0) then 
		begin 
		qt_estoque_minimo_w	:= round((qt_consumo_diario_w * coalesce(qt_dia_estoque_minimo_w,3)), 0);
		if (ie_arredonda_acima_ponto_w = 'S') then 
			qt_estoque_minimo_w	:= trunc(qt_consumo_diario_w * coalesce(qt_dia_estoque_minimo_w,3)) + 1;
		end if;
		 
		qt_ponto_pedido_w	:= qt_estoque_minimo_w + round((qt_consumo_diario_w * qt_dia_ressup_forn_w)::numeric, 0);
		qt_compra_w		:= round((qt_consumo_diario_w * qt_Dia_Interv_ressup_w)::numeric,0);
		if (ie_soma_dias_max_fornec_w = 'S') then 
			qt_compra_w		:= round((qt_consumo_diario_w * (qt_Dia_Interv_ressup_w + qt_dia_ressup_forn_w)),0);
		end if;
		qt_estoque_Maximo_w	:= qt_estoque_minimo_w + qt_compra_w;
		end;
	end if;		
 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_sequencia_w 
	from	material_estab 
	where	cd_estabelecimento	= cd_estabelecimento_p 
	and	cd_material	= cd_material_w;
 
	if (nr_sequencia_w = 0) then 
		select	nextval('material_estab_seq') 
		into STRICT	nr_sequencia_w 
		;
		insert into material_estab( 
			nr_sequencia,		cd_estabelecimento, 
			cd_material,		dt_atualizacao, 
			nm_usuario,		ie_baixa_estoq_pac, 
			ie_material_estoque,	qt_estoque_minimo, 
			qt_ponto_pedido,	qt_estoque_maximo, 
			qt_dia_interv_ressup,	qt_dia_ressup_forn, 
			qt_dia_estoque_minimo,	nr_minimo_cotacao, 
			qt_desvio_padrao_cons,	qt_consumo_mensal_ressup, 
			qt_consumo_mensal,	cd_material_conta, 
			cd_kit_material,	qt_peso_kg, 
			dt_atual_consumo,	qt_mes_consumo, 
			IE_RESSUPRIMENTO,	IE_CLASSIF_CUSTO, 
			ie_prescricao,		ie_padronizado, 
			ie_estoque_lote,	ie_requisicao, 
			ie_controla_serie) 
		values (	nr_sequencia_w,		cd_estabelecimento_p, 
			cd_material_w,		clock_timestamp(), 
			nm_usuario_p,		ie_baixa_estoq_pac_w, 
			ie_material_estoque_w,	qt_estoque_minimo_w, 
			qt_ponto_pedido_w,	qt_estoque_maximo_w, 
			qt_dia_interv_ressup_w,	qt_dia_ressup_forn_w, 
			qt_dia_estoque_minimo_w,nr_minimo_cotacao_w, 
			qt_desvio_padrao_cons_w,qt_consumo_mensal_ressup_w, 
			qt_consumo_mensal_w,	cd_material_conta_w, 
			cd_kit_material_w,	qt_peso_kg_w, 
			clock_timestamp(),		qt_meses_consumo_p, 
			'S',			'B', 
			'S',			'S', 
			'N',			'S', 
			'N');
	else 
		begin 
		update	material_estab 
		set 	qt_ponto_pedido			= qt_ponto_pedido_w, 
			qt_estoque_maximo		= qt_estoque_maximo_w, 
			qt_estoque_minimo		= qt_estoque_minimo_w, 
			qt_desvio_padrao_cons		= qt_desvio_padrao_cons_w, 
			qt_consumo_mensal		= qt_consumo_mensal_w, 
			qt_consumo_mensal_ressup	= qt_consumo_mensal_ressup_w, 
			qt_mes_consumo			= qt_meses_consumo_w, 
			dt_atual_consumo		= clock_timestamp() 
		where	nr_sequencia			= nr_sequencia_w;
 
		update	/*+ INDEX (A) */ 
			material_estab a 
		set 	a.qt_ponto_pedido		= qt_ponto_pedido_w, 
			a.qt_estoque_maximo		= qt_estoque_maximo_w, 
			a.qt_estoque_minimo		= qt_estoque_minimo_w, 
			a.qt_desvio_padrao_cons		= qt_desvio_padrao_cons_w, 
			a.qt_consumo_mensal		= qt_consumo_mensal_w, 
			qt_consumo_mensal_ressup	= qt_consumo_mensal_ressup_w, 
			a.qt_mes_consumo		= qt_meses_consumo_w, 
			a.dt_atual_consumo		= clock_timestamp() 
		where	a.cd_estabelecimento		= cd_estabelecimento_p 
		and	a.cd_material in ( 
			SELECT	b.cd_material 
			from	material b 
			where	b.cd_material_estoque = cd_material_w 
			and	b.cd_material <> cd_material_w);
		end;
	end if;
	 
	/* Comentado porque não se utiliza esses campos abaixo na tabela material. São usados na material estab 
	if	(cd_estabelecimento_p = cd_estabelecimento_base_w) then 
		update	/*+ INDEX(A) */ 
	/*		material a 
		set 	a.qt_ponto_pedido	= qt_ponto_pedido_w, 
			a.qt_estoque_maximo	= qt_estoque_maximo_w, 
			a.qt_estoque_minimo	= qt_estoque_minimo_w, 
			a.qt_consumo_mensal	= qt_consumo_mensal_w 
		where	a.cd_material		= cd_material_w; 
	end if;*/
 
	 
	insert into w_calculo_ponto( 
		nr_sequencia, 
		cd_estabelecimento, 
		cd_material, 
		dt_atualizacao, 
		nm_usuario, 
		qt_estoque_minimo, 
		qt_ponto_pedido, 
		qt_estoque_maximo, 
		qt_consumo_mensal, 
		qt_consumo_diario, 
		dt_atual_consumo, 
		qt_mes_consumo, 
		dt_mes_base_atual, 
		qt_dia_estoque_minimo, 
		qt_dia_ressup_forn, 
		qt_dia_interv_ressup, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec) 
	values (	nextval('w_calculo_ponto_seq'), 
		cd_estabelecimento_p, 
		cd_material_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		qt_estoque_minimo_w, 
		qt_ponto_pedido_w, 
		qt_estoque_maximo_w, 
		qt_consumo_mensal_w, 
		qt_consumo_diario_w, 
		clock_timestamp(), 
		qt_meses_consumo_w, 
		dt_parametro_p, 
		qt_dia_estoque_minimo_w, 
		qt_dia_ressup_forn_w, 
		qt_dia_interv_ressup_w, 
		clock_timestamp(), 
		nm_usuario_p);
	end;
end loop;
close c01;
 
 
if (ie_atualiza_consumo_consig_w = 'S') then 
	CALL atualizar_consumo_medio_consig(	cd_estabelecimento_p, 
				qt_meses_Consumo_p, 
				dt_parametro_p, 
				dt_periodo_inicio_p, 
				dt_periodo_final_p, 
				cd_grupo_material_p, 
				cd_subgrupo_material_p, 
				cd_classe_material_p, 
				nm_usuario_p);
end if;
 
insert into log_val_estoque( 
			cd_log, 
			ds_log, 
			dt_atualizacao, 
			nm_usuario, 
			cd_estabelecimento) 
		values (	3, 
			wheb_mensagem_pck.get_texto(310441,'DT_PARAMETRO_W='||to_char(dt_parametro_w,'dd/mm/yyyy')), 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p);
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_ponto_pedido ( cd_estabelecimento_p bigint, qt_meses_Consumo_p bigint, dt_parametro_p timestamp, dt_periodo_inicio_p timestamp, dt_periodo_final_p timestamp, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, nm_usuario_p text) FROM PUBLIC;
