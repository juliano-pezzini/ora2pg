-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_gerar_solic_planej ( nr_seq_planejamento_p bigint, ie_aviso_chegada_p text, ie_aviso_aprov_oc_p text, cd_local_estoque_p bigint, dt_entrega_falta_p timestamp, ie_tipo_gerar_p text, nm_usuario_p text, nr_solic_compra_p INOUT bigint) AS $body$
DECLARE

 
/* 
ie_tipo_gerar_p 
P = Planejamento 
F = Falta 
*/
 
 
nr_sequencia_w			bigint;
cd_estabelecimento_w		smallint;
ds_planejamento_w			varchar(80);
cd_cnpj_w			varchar(14);
dt_periodo_inicial_w		timestamp;
dt_periodo_final_w			timestamp;
dt_primeira_entrega_w		timestamp;
qt_dia_compra_w			double precision;
qt_dia_consumo_w			double precision;
qt_dia_interv_entrega_w		double precision;
qt_entregas_w			double precision;
nr_solic_compra_w			bigint;
cd_material_w			bigint;
qt_consumo_diario_w		double precision;
qt_tot_compra_w			double precision;
qt_est_atual_w			double precision;
qt_entrega_prev_w			double precision;
qt_cons_prev_w			double precision;
qt_est_prev_entrega_w		double precision;
qt_falta_prim_entrega_w		double precision;
qt_entrega_w			double precision;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
qt_comprar_w			double precision;
qt_conv_compra_estoque_w		double precision;
nr_item_w			integer;
nr_item_entrega_w			integer;
cd_unidade_compra_w		varchar(30);
nr_seq_nf_w			bigint;
vl_ultima_compra_w		double precision := 0;
qt_entrega_ww			double precision;
dt_entrega_ww			timestamp;
qt_existe_falta_w			bigint := 0;
qt_total_entrega_ww		double precision;
qt_somatoria_entrega_w		double precision;
qt_entrega_real_w			double precision;
qt_somatoria_anterior_w		double precision;
qt_soma_entrega_w		double precision;
qt_dif_entrega_w			double precision;
ie_gerar_entrega_w			varchar(1);
qt_maximo_entrega_w		double precision;
qt_existe_w			bigint;
nr_item_solic_compra_w		integer;
ie_dia_nao_util_w			varchar(15);
ie_feriado_w			smallint;
dt_solic_item_w			timestamp;

C01 CURSOR FOR 
SELECT	nr_sequencia, 
	cd_material, 
	qt_consumo_diario, 
	CASE WHEN ie_tipo_gerar_p='P' THEN  CASE WHEN coalesce(qt_compra_ajustada,0)=0 THEN qt_tot_compra  ELSE qt_compra_ajustada END   ELSE qt_falta_prim_entrega END , 
	qt_est_atual, 
	qt_entrega_prev, 
	qt_cons_prev, 
	qt_est_prev_entrega, 
	qt_falta_prim_entrega, 
	qt_entrega 
from	sup_regra_planej_item 
where	nr_seq_planejamento = nr_seq_planejamento_p;

c02 CURSOR FOR 
SELECT	a.qt_entrega, 
	CASE WHEN rownum=1 THEN  		dt_primeira_entrega_w  ELSE dt_primeira_entrega_w + ((rownum - 1) * qt_dia_interv_entrega_w) END  
from	tabela_sistema b, 
	sup_regra_planej_item a 
where	a.nr_seq_planejamento = nr_seq_planejamento_p  
and	a.nr_sequencia = nr_sequencia_w 
and	ie_tipo_gerar_p = 'P' 
and	ie_gerar_entrega_w = 'S' 

union
 
SELECT	qt_comprar_w, 
	dt_entrega_falta_p 
 
where	ie_tipo_gerar_p = 'F' 
and	ie_gerar_entrega_w = 'S' 

union
 
select	qt_entrega, 
	dt_primeira_entrega_w 
from	sup_regra_planej_item 
where	nr_seq_planejamento = nr_seq_planejamento_p 
and	nr_sequencia = nr_sequencia_w 
and	ie_tipo_gerar_p in ('P','F') 
and	ie_gerar_entrega_w = 'N' LIMIT (qt_entregas_w);

c03 CURSOR FOR 
SELECT	a.nr_item_solic_compra 
from	solic_compra_item a 
where	a.nr_solic_compra = nr_solic_compra_w 
and exists (	SELECT	1 
		from	solic_compra_item_entrega b 
		where	a.nr_solic_compra = b.nr_solic_compra 
		and	a.nr_item_solic_compra = b.nr_item_solic_compra);


BEGIN 
 
select	cd_estabelecimento, 
	ds_planejamento, 
	cd_cnpj, 
	dt_periodo_inicial, 
	dt_periodo_final, 
	dt_primeira_entrega, 
	qt_dia_compra, 
	qt_dia_consumo, 
	qt_dia_interv_entrega, 
	qt_entregas, 
	ie_gerar_entrega, 
	ie_dia_nao_util 
into STRICT	cd_estabelecimento_w, 
	ds_planejamento_w, 
	cd_cnpj_w, 
	dt_periodo_inicial_w, 
	dt_periodo_final_w, 
	dt_primeira_entrega_w, 
	qt_dia_compra_w, 
	qt_dia_consumo_w, 
	qt_dia_interv_entrega_w, 
	qt_entregas_w, 
	ie_gerar_entrega_w, 
	ie_dia_nao_util_w 
from	sup_planejamento_compras 
where	nr_sequencia = nr_seq_planejamento_p;
 
if (ie_tipo_gerar_p = 'F') then 
	select	count(*) 
	into STRICT	qt_existe_falta_w 
	from	sup_regra_planej_item 
	where	nr_seq_planejamento = nr_seq_planejamento_p 
	and	qt_falta_prim_entrega > 0;
end if;
 
if (ie_tipo_gerar_p = 'P') or 
	(ie_tipo_gerar_p = 'F' AND qt_existe_falta_w > 0) then 
	nr_solic_compra_w := gerar_solic_compra(cd_estabelecimento_w, ie_aviso_chegada_p, ie_aviso_aprov_oc_p, cd_local_estoque_p, nm_usuario_p, nr_solic_compra_w);
 
	update	solic_compra 
	set	ds_observacao = CASE WHEN ie_tipo_gerar_p='P' THEN wheb_mensagem_pck.get_texto(307049,'NR_SEQ_PLANEJAMENTO_P='||nr_seq_planejamento_p||';DS_PLANEJAMENTO_W='||ds_planejamento_w) WHEN ie_tipo_gerar_p='F' THEN  wheb_mensagem_pck.get_texto(307050,'NR_SEQ_PLANEJAMENTO_P='||nr_seq_planejamento_p||';DS_PLANEJAMENTO_W='||ds_planejamento_w) END , 
		nr_seq_planejamento = nr_seq_planejamento_p 
	where	nr_solic_compra = nr_solic_compra_w;
end if;
 
open C01;
loop 
fetch C01 into 
	nr_sequencia_w, 
	cd_material_w, 
	qt_consumo_diario_w, 
	qt_tot_compra_w, 
	qt_est_atual_w, 
	qt_entrega_prev_w, 
	qt_cons_prev_w, 
	qt_est_prev_entrega_w, 
	qt_falta_prim_entrega_w, 
	qt_entrega_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	 
	if (ie_tipo_gerar_p = 'P') or 
		(ie_tipo_gerar_p = 'F' AND qt_falta_prim_entrega_w > 0) then 
		begin 
 
		select	max(Obter_Dados_Material(cd_material_w, 'QCE')), 
			max(Obter_Dados_Material(cd_material_w, 'UMP')) 
		into STRICT	qt_conv_compra_estoque_w, 
			cd_unidade_compra_w 
		;
 
		qt_comprar_w	:= qt_tot_compra_w;
		if (qt_comprar_w > 0) and (qt_comprar_w < 1) then 
			qt_comprar_w	:= 1;
		else 
			qt_comprar_w	:= round((qt_comprar_w)::numeric, 0);
		end if;	
 
		if (qt_comprar_w > 0) then 
			begin 
			select	coalesce(max(nr_item_solic_compra),0) + 1 
			into STRICT	nr_item_w 
			from	solic_compra_item 
			where	nr_solic_compra = nr_solic_compra_w;
 
			SELECT * FROM Obter_ultima_compra_material( 
					cd_estabelecimento_w, cd_material_w, cd_unidade_compra_w, 'C', clock_timestamp() - interval '90 days', nr_seq_nf_w, vl_ultima_compra_w) INTO STRICT nr_seq_nf_w, vl_ultima_compra_w;
 
			/*Pega a data que vai ser inserida na SOLIC_COMPRA_ITEM*/
 
			select	CASE WHEN ie_tipo_gerar_p='P' THEN dt_primeira_entrega_w WHEN ie_tipo_gerar_p='F' THEN dt_entrega_falta_p END  
			into STRICT	dt_solic_item_w 
			;
 
			/*Verifica se a data de entrega é um dia útil, caso não, vai realizar a ação conforme cadastro do planejamento*/
 
			if (coalesce(ie_dia_nao_util_w,'M') <> 'M') then 
				select	coalesce(substr(obter_se_feriado(cd_estabelecimento_w, dt_solic_item_w),1,1),'0') 
				into STRICT	ie_feriado_w 
				;
 
				if (ie_feriado_w > 0) or (pkg_date_utils.is_business_day(dt_solic_item_w) = 0 ) then 
					begin 
					if (ie_dia_nao_util_w = 'A') then /*antecipar*/
 
						dt_solic_item_w := obter_dia_anterior_util(cd_estabelecimento_w, dt_solic_item_w);
					elsif (ie_dia_nao_util_w = 'P') then /*postergar*/
 
						dt_solic_item_w := obter_proximo_dia_util(cd_estabelecimento_w, dt_solic_item_w);
					end if;
					end;
				end if;
			end if;
 
			insert into solic_compra_item( 
				nr_solic_compra, 
				nr_item_solic_compra, 
				cd_material, 
				cd_unidade_medida_compra, 
				qt_material, 
				dt_atualizacao, 
				nm_usuario, 
				ie_situacao, 
				dt_solic_item, 
				vl_unit_previsto, 
				ie_geracao, 
				qt_conv_compra_est_orig, 
				qt_saldo_disp_estoque) 
			values (nr_solic_compra_w, 
				nr_item_w, 
				cd_material_w, 
				cd_unidade_compra_w, 
				qt_comprar_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				'A', 
				dt_solic_item_w, 
				vl_ultima_compra_w, 
				'S', 
				obter_dados_material(cd_material_w,'QCE'), 
				obter_saldo_disp_estoque(cd_estabelecimento_w, cd_material_w, cd_local_estoque_p, trunc(clock_timestamp(),'mm')));
 
			qt_total_entrega_ww	:= 0;
			qt_somatoria_entrega_w	:= 0;
			qt_entrega_real_w	:= 0;
			qt_soma_entrega_w	:= 0;
			 
			select	coalesce(sup_obter_regra_planej_compra(cd_estabelecimento_w, cd_material_w,'Q'),0) 
			into STRICT	qt_maximo_entrega_w 
			;
			 
			if (qt_maximo_entrega_w > 0) and (qt_comprar_w > qt_maximo_entrega_w) then 
				qt_entregas_w := trunc(dividir(qt_comprar_w, qt_maximo_entrega_w));
				if (mod(qt_comprar_w, qt_maximo_entrega_w) > 0) then 
					qt_entregas_w := qt_entregas_w + 1;
				end if;
			end if;
			 
			open C02;
			loop 
			fetch C02 into 
				qt_entrega_ww, 
				dt_entrega_ww;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin 
				/*Exemplo para facilitar ao debugar 
				1,4 - 2 - 2 
				2,8 - 1 - 3 
				4,2 - 2 - 5 
				5,6 - 1 - 6 
				7,0 - 1 - 7*/
 
 
				select	coalesce(max(nr_item_solic_compra_entr),0) + 1 
				into STRICT	nr_item_entrega_w 
				from	solic_compra_item_entrega 
				where	nr_solic_compra = nr_solic_compra_w 
				and	nr_item_solic_compra = nr_item_w;
			 
 
				/*Somatoria das quantidades em cada entrega*/
 
				qt_total_entrega_ww	:= qt_total_entrega_ww + qt_entrega_ww;
 
				/* arredonda pra cima*/
 
				qt_somatoria_entrega_w	:= qt_total_entrega_ww;
				if (qt_somatoria_entrega_w > trunc(qt_somatoria_entrega_w)) then 
					qt_somatoria_entrega_w	:= trunc(qt_somatoria_entrega_w) + 1;
				end if;
 
				/* Se for a primeira entrega, não faz o calculo da diferenca*/
 
				if (qt_entrega_real_w = 0) then 
					qt_entrega_real_w	:= qt_somatoria_entrega_w;
				else 
					qt_entrega_real_w	:= qt_somatoria_entrega_w - qt_somatoria_anterior_w;
				end if;
 
				qt_somatoria_anterior_w		:= qt_somatoria_entrega_w;
 
 
				if (qt_entrega_real_w = 0) then 
					qt_entrega_real_w	:= 1;
				end if;
 
				select	coalesce(sum(qt_entrega_solicitada), 0) 
				into STRICT	qt_soma_entrega_w 
				from	solic_compra_item_entrega 
				where	nr_solic_compra = nr_solic_compra_w 
				and	nr_item_solic_compra = nr_item_w;
 
				/*Verifica se a data de entrega é um dia útil, caso não, vai realizar a ação conforme cadastro do planejamento*/
 
				if (coalesce(ie_dia_nao_util_w,'M') <> 'M') then 
					select	coalesce(substr(obter_se_feriado(cd_estabelecimento_w, dt_entrega_ww),1,1),'0') 
					into STRICT	ie_feriado_w 
					;
 
					if (ie_feriado_w > 0) or (pkg_date_utils.is_business_day(dt_entrega_ww) = 0 ) then 
						begin 
						if (ie_dia_nao_util_w = 'A') then /*antecipar*/
 
							dt_entrega_ww := obter_dia_anterior_util(cd_estabelecimento_w, dt_entrega_ww);
						elsif (ie_dia_nao_util_w = 'P') then /*postergar*/
 
							dt_entrega_ww := obter_proximo_dia_util(cd_estabelecimento_w, dt_entrega_ww);
						end if;
						end;
					end if;
				end if;
				 
				 
				if (qt_soma_entrega_w < qt_comprar_w) then 
					insert into solic_compra_item_entrega( 
						nr_solic_compra, 
						nr_item_solic_compra, 
						nr_item_solic_compra_entr, 
						qt_entrega_solicitada, 
						dt_entrega_solicitada, 
						dt_atualizacao, 
						nm_usuario, 
						ds_observacao) 
					values (nr_solic_compra_w, 
						nr_item_w, 
						nr_item_entrega_w, 
						qt_entrega_real_w, 
						dt_entrega_ww, 
						clock_timestamp(), 
						nm_usuario_p, 
						null);
				end if;
				end;
			end loop;
			close c02;
 
			/*Ajusta se ficou diferença*/
 
			select	coalesce(sum(qt_entrega_solicitada), 0) 
			into STRICT	qt_soma_entrega_w 
			from	solic_compra_item_entrega 
			where	nr_solic_compra = nr_solic_compra_w 
			and	nr_item_solic_compra = nr_item_w;
			 
			if (qt_soma_entrega_w <> qt_comprar_w) then 
				qt_dif_entrega_w	:= qt_comprar_w - qt_soma_entrega_w;
			end if;
 
			if (qt_soma_entrega_w <> qt_comprar_w) then 
				update	solic_compra_item_entrega 
				set	qt_entrega_solicitada = qt_entrega_solicitada + qt_dif_entrega_w 
				where	nr_solic_compra = nr_solic_compra_w 
				and	nr_item_solic_compra = nr_item_w 
				and	nr_item_solic_compra_entr = nr_item_entrega_w;
			end if;
			end;
		end if;
		end;
	end if;
	end;
end loop;
close c01;
 
select	count(*) 
into STRICT	qt_existe_w 
from	regra_planej_calendario 
where	cd_estabelecimento = cd_estabelecimento_w;
 
if (qt_existe_w > 0) then 
	 
	open C03;
	loop 
	fetch C03 into	 
		nr_item_solic_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		CALL gerar_ent_calendario_planej(nr_solic_compra_w, nr_item_solic_compra_w, nm_usuario_p);
		end;
	end loop;
	close C03;
end if;
 
nr_solic_compra_p	:= nr_solic_compra_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gerar_solic_planej ( nr_seq_planejamento_p bigint, ie_aviso_chegada_p text, ie_aviso_aprov_oc_p text, cd_local_estoque_p bigint, dt_entrega_falta_p timestamp, ie_tipo_gerar_p text, nm_usuario_p text, nr_solic_compra_p INOUT bigint) FROM PUBLIC;

