-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_mapa_estoque_local (nr_seq_mapa_p bigint, nm_usuario_p text, ie_qt_vl_p text, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp, ie_consignado_p text) AS $body$
DECLARE

 
dt_mesano_consulta_w		timestamp;
dt_mesano_referencia_w		timestamp;
mes_anterior_w			timestamp;
cd_estabelecimento_w		smallint;
ie_tipo_w				varchar(1);
cd_material_w			integer;
cd_material_ww			integer;
cd_material_estoque_w		integer;
cd_operacao_estoque_w		smallint;
cd_local_estoque_w		integer;
qt_estoque_w			double precision;
vl_estoque_w			double precision;

qt_coluna_w			double precision;
qt_coluna1_w			double precision;
qt_coluna2_w			double precision;
qt_coluna3_w			double precision;
qt_coluna4_w			double precision;
qt_coluna5_w			double precision;
qt_coluna6_w			double precision;
qt_coluna7_w			double precision;
qt_coluna8_w			double precision;
qt_coluna9_w			double precision;
qt_coluna10_w			double precision;
qt_coluna11_w			double precision;
qt_coluna12_w			double precision;
qt_coluna13_w			double precision;
qt_saldo_anterior_w			double precision;
qt_saldo_atual_w			double precision;
qt_saldo_disponivel_w		double precision;
qt_emprestimo_ent_w		double precision;
qt_emprestimo_sai_w		double precision;

nr_seq_coluna_w			smallint;
ie_entrada_saida_w			varchar(2);
ie_mes_w				varchar(100);
dt_atualizacao_w			timestamp;
ie_mat_jafoi_w			varchar(1);

cd_local_estoque_ww		integer;
						
C01 CURSOR FOR 
	SELECT	distinct cd_local_estoque 
	from	saldo_estoque 
	where	dt_mesano_referencia = dt_mesano_referencia_p 
	and	cd_estabelecimento = cd_estabelecimento_w 
	and	cd_local_estoque = coalesce(cd_local_estoque_p, cd_local_estoque) 
	
union
 
	SELECT	distinct cd_local_estoque 
	from	movto_estoque_operacao_v 
	where	dt_mesano_referencia = dt_mesano_referencia_p 
	and	cd_estabelecimento = cd_estabelecimento_w 
	and	cd_local_estoque = coalesce(cd_local_estoque_p, cd_local_estoque);

C02 CURSOR FOR 
	/*Não consignados*/
 
	SELECT	8 ie_tipo, 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.qt_estoque  ELSE a.qt_estoque * -1 END ) qt_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.vl_estoque  ELSE a.vl_estoque * -1 END ) vl_estoque 
	from	operacao_estoque o, 
		movto_estoque_operacao_v a 
	where	a.dt_mesano_referencia	= mes_anterior_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_w 
	and	a.cd_operacao_estoque	= o.cd_operacao_estoque 
	and	a.ie_consignado		= 'N' 
	and	a.cd_local_estoque	= cd_local_estoque_ww 
	and exists ( 
		SELECT	1 
		from	mapa_est_item y, 
			mapa_est_item_oper x 
		where	x.nr_seq_item		= y.nr_sequencia 
		and	x.cd_operacao_estoque	= a.cd_operacao_estoque 
		and	y.nr_seq_mapa		= nr_seq_mapa_p 
		and	coalesce(y.ie_mes,'AT')	= 'AN') 
	and	ie_consignado_p = 'N' 
	group by 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque 
	
union all
 
	select	8 ie_tipo, 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.qt_estoque  ELSE a.qt_estoque * -1 END ) qt_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.vl_estoque  ELSE a.vl_estoque * -1 END ) vl_estoque 
	from	operacao_estoque o, 
		movto_estoque_operacao_v a 
	where	a.dt_mesano_referencia	= dt_mesano_referencia_p 
	and	a.cd_estabelecimento	= cd_estabelecimento_w 
	and	a.cd_operacao_estoque	= o.cd_operacao_estoque 
	and	a.ie_consignado		= 'N' 
	and	a.cd_local_estoque	= cd_local_estoque_ww 
	and exists ( 
		select	1 
		from	mapa_est_item y, 
			mapa_est_item_oper x 
		where	x.nr_seq_item		= y.nr_sequencia 
		and	x.cd_operacao_estoque	= a.cd_operacao_estoque 
		and	y.nr_seq_mapa		= nr_seq_mapa_p 
		and	coalesce(y.ie_mes,'AT')	<> 'AN') 
	and	ie_consignado_p = 'N' 
	group by 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque 
	
union all
 
	select	9 ie_tipo, 
		a.dt_mesano_referencia, 
		a.cd_material, 
		null, 
		0 qt_estoque, 
		0 vl_estoque 
	from	saldo_estoque a 
	where	a.dt_mesano_referencia	= dt_mesano_referencia_p 
	and	a.cd_estabelecimento	= cd_estabelecimento_w 
	and	a.cd_local_estoque	= cd_local_estoque_ww 
	and not exists ( 
		select	1 
		from	movto_estoque_operacao_v x 
		where	x.dt_mesano_referencia	= a.dt_mesano_referencia 
		and	x.cd_estabelecimento	= a.cd_estabelecimento 
		and	x.cd_local_estoque	= a.cd_local_estoque 
		and	x.cd_material		= a.cd_material 
		and	x.ie_consignado		= 'N' 
		and exists ( 
			select	1 
			from	mapa_est_item y, 
				mapa_est_item_oper z 
			where	z.nr_seq_item		= y.nr_sequencia 
			and	z.cd_operacao_estoque	= x.cd_operacao_estoque 
			and	y.nr_seq_mapa		= nr_seq_mapa_p)) 
	and	ie_consignado_p = 'N' 
	group by 
		a.dt_mesano_referencia, 
		a.cd_material 
	
union all
 
	/*Consignados*/
 
	select	8 ie_tipo, 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.qt_estoque  ELSE a.qt_estoque * -1 END ) qt_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.vl_estoque  ELSE a.vl_estoque * -1 END ) vl_estoque 
	from	operacao_estoque o, 
		movto_estoque_operacao_v a 
	where	a.dt_mesano_referencia	= mes_anterior_w 
	and	a.cd_estabelecimento	= cd_estabelecimento_w 
	and	a.cd_operacao_estoque	= o.cd_operacao_estoque 
	and	a.ie_consignado		= 'S' 
	and	a.cd_local_estoque	= cd_local_estoque_ww 
	and exists ( 
		select	1 
		from	mapa_est_item y, 
			mapa_est_item_oper x 
		where	x.nr_seq_item		= y.nr_sequencia 
		and	x.cd_operacao_estoque	= a.cd_operacao_estoque 
		and	y.nr_seq_mapa		= nr_seq_mapa_p 
		and	coalesce(y.ie_mes,'AT')	= 'AN') 
	and	ie_consignado_p = 'S' 
	group by 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque 
	
union all
 
	select	8 ie_tipo, 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.qt_estoque  ELSE a.qt_estoque * -1 END ) qt_estoque, 
		sum(CASE WHEN o.ie_entrada_saida='E' THEN  a.vl_estoque  ELSE a.vl_estoque * -1 END ) vl_estoque 
	from	operacao_estoque o, 
		movto_estoque_operacao_v a 
	where	a.dt_mesano_referencia	= dt_mesano_referencia_p 
	and	a.cd_estabelecimento	= cd_estabelecimento_w 
	and	a.cd_operacao_estoque	= o.cd_operacao_estoque 
	and	a.ie_consignado		= 'S' 
	and	a.cd_local_estoque	= cd_local_estoque_ww 
	and exists ( 
		select	1 
		from	mapa_est_item y, 
			mapa_est_item_oper x 
		where	x.nr_seq_item		= y.nr_sequencia 
		and	x.cd_operacao_estoque	= a.cd_operacao_estoque 
		and	y.nr_seq_mapa		= nr_seq_mapa_p 
		and	coalesce(y.ie_mes,'AT')	<> 'AN') 
	and	ie_consignado_p = 'S' 
	group by 
		a.dt_mesano_referencia, 
		a.cd_material, 
		a.cd_operacao_estoque 
	
union all
 
	select	9 ie_tipo, 
		a.dt_mesano_referencia, 
		a.cd_material, 
		null, 
		0 qt_estoque, 
		0 vl_estoque 
	from	fornecedor_mat_consignado a 
	where	a.dt_mesano_referencia	= dt_mesano_referencia_p 
	and	a.cd_estabelecimento	= cd_estabelecimento_w 
	and	a.cd_local_estoque	= cd_local_estoque_ww 
	and not exists ( 
		select	1 
		from	movto_estoque_operacao_v x 
		where	x.dt_mesano_referencia	= a.dt_mesano_referencia 
		and	x.cd_estabelecimento	= a.cd_estabelecimento 
		and	x.cd_local_estoque	= a.cd_local_estoque 
		and	x.cd_material		= a.cd_material 
		and	x.ie_consignado		= 'S') 
	and	ie_consignado_p = 'S' 
	group by 
		a.dt_mesano_referencia, 
		a.cd_material 
	order by 
		cd_material;
		
c03 CURSOR FOR 
	SELECT	b.nr_seq_coluna, 
		b.ie_entrada_saida, 
		coalesce(b.ie_mes,'AT') ie_mes 
	from	mapa_est_item b, 
		mapa_est_item_oper a 
	where	a.nr_seq_item		= b.nr_sequencia 
	and	a.cd_operacao_estoque	= cd_operacao_estoque_w 
	and	b.nr_seq_mapa		= nr_seq_mapa_p 
	
union all
 
	SELECT	b.nr_seq_coluna, 
		a.ie_tipo_informacao, 
		coalesce(b.ie_mes,'AT') ie_mes 
	from	mapa_est_item b, 
		mapa_est_item_oper a 
	where	a.nr_seq_item		= b.nr_sequencia 
	and	coalesce(a.cd_operacao_estoque::text, '') = '' 
	and	a.ie_tipo_informacao <> 'OP' 
	and	ie_mat_jafoi_w		= 'N' 
	and	b.nr_seq_mapa		= nr_seq_mapa_p;
	

BEGIN 
delete 
from	w_mapa_estoque_coluna 
where	nm_usuario	= nm_usuario_p;
commit;
 
mes_anterior_w		:= PKG_DATE_UTILS.ADD_MONTH(dt_mesano_referencia_p, -1, 0);
dt_atualizacao_w	:= clock_timestamp();
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	mapa_estoque 
where	nr_sequencia = nr_seq_mapa_p;
 
open C01;
loop 
fetch C01 into	 
	cd_local_estoque_ww;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	cd_material_ww := 0;
	open c02;
	LOOP 
	FETCH C02 INTO 
		ie_tipo_w, 
		dt_mesano_referencia_w, 
		cd_material_w, 
		cd_operacao_estoque_w, 
		qt_estoque_w, 
		vl_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */	
		begin 
 
		select	cd_material_estoque 
		into STRICT	cd_material_estoque_w 
		from	material 
		where	cd_material = cd_material_w;
 
		 
		qt_coluna_w		:= qt_estoque_w;
		if (ie_qt_vl_p = 'V') then 
			qt_coluna_w	:= vl_estoque_w;
		end if;
 
		/* Verifica a coluna a ser incluido a quantidade e insere a quantidade no campo que deve ser somado*/
 
		qt_coluna1_w	:= 0;
		qt_coluna2_w	:= 0;
		qt_coluna3_w	:= 0;
		qt_coluna4_w	:= 0;
		qt_coluna5_w	:= 0;
		qt_coluna6_w	:= 0;
		qt_coluna7_w	:= 0;
		qt_coluna8_w	:= 0;
		qt_coluna9_w	:= 0;
		qt_coluna10_w	:= 0;
		qt_coluna11_w	:= 0;
		qt_coluna12_w	:= 0;
		qt_coluna13_w	:= 0;
 
		ie_mat_jafoi_w	:= 'N';
		if (cd_material_w = coalesce(cd_material_ww, 0)) then 
			ie_mat_jafoi_w	:= 'S';
		end if;
		cd_material_ww		:= cd_material_w;
 
		open c03;
		LOOP 
		FETCH C03 INTO 
			nr_seq_coluna_w, 
			ie_entrada_saida_w, 
			ie_mes_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */	
			begin 
 
			/* Informação referente as colunas 
			CM       Custo médio 
			CO       Consumo mensal 
			EE       Empréstimo de entrada 
			ES       Empréstimo de saida 
			OP       Operação de estoque 
			SD       Saldo disponível 
			SE		Saldo contábil 
			*/
 
 
			--tratamento para considerar o mes anterior tambem nos casos de buscar o valor quando não é operacao_estoque 
					 
			dt_mesano_consulta_w		:= dt_mesano_referencia_w;
			if (ie_mes_w = 'AN') then 
				dt_mesano_consulta_w	:= mes_anterior_w;
			end if;
 
			if (ie_entrada_saida_w = 'CM') then 
				qt_coluna_w	:= obter_custo_medio_material( 
							cd_estabelecimento_w, 
							PKG_DATE_UTILS.start_of(dt_mesano_consulta_w,'month',0), 
							cd_material_w);
 
			elsif (ie_entrada_saida_w = 'CO') then 
				qt_coluna_w	:= obter_mat_estabelecimento( 
							cd_estabelecimento_w, 
							NULL, 
							cd_material_w, 
							'CM');
				if (ie_qt_vl_p = 'V') then 
					qt_coluna_w	:= qt_coluna_w * obter_custo_medio_material( 
										cd_estabelecimento_w, 
										PKG_DATE_UTILS.start_of(dt_mesano_consulta_w,'month',0), 
										cd_material_w);
				end if;
 
			elsif (ie_entrada_saida_w = 'EE') then 
				select	/*+ INDEX(b empmate_i1) index (c emprest_pk) */ 
					coalesce(sum(b.qt_material),0) 
				into STRICT	qt_coluna_w 
				from	emprestimo c, 
					emprestimo_material b 
				where	b.cd_material	= cd_material_w 
				and	b.nr_emprestimo	= c.nr_emprestimo 
				and	PKG_DATE_UTILS.start_of(c.dt_emprestimo,'month',0) = dt_mesano_consulta_w 
				and	c.ie_situacao	= 'A' 
				and	b.qt_material	> 0 
				and	c.ie_tipo	= 'E';
				if (ie_qt_vl_p = 'V') then 
					qt_coluna_w	:= qt_coluna_w * obter_custo_medio_material( 
										cd_estabelecimento_w, 
										PKG_DATE_UTILS.start_of(dt_mesano_consulta_w,'month',0), 
										cd_material_w);
				end if;
 
			elsif (ie_entrada_saida_w = 'ES') then 
				select	/*+ INDEX(b empmate_i1) index (c emprest_pk) */ 
					coalesce(sum(b.qt_material),0) 
				into STRICT	qt_coluna_w 
				from	emprestimo c, 
					emprestimo_material b 
				where	b.cd_material	= cd_material_w 
				and	b.nr_emprestimo	= c.nr_emprestimo 
				and	PKG_DATE_UTILS.start_of(c.dt_emprestimo,'month',0) = dt_mesano_consulta_w 
				and	c.ie_situacao	= 'A' 
				and	b.qt_material	> 0 
				and	c.ie_tipo	= 'S';
				if (ie_qt_vl_p = 'V') then 
					qt_coluna_w	:= qt_coluna_w * obter_custo_medio_material( 
										cd_estabelecimento_w, 
										PKG_DATE_UTILS.start_of(dt_mesano_consulta_w,'month',0), 
										cd_material_w);
				end if;
 
			elsif (ie_entrada_saida_w = 'SD') then 
				begin 
				--Obrigatóriamente deve ser sysdate porque não existe disponivel do mes passado					 
				if (ie_qt_vl_p = 'V') then 
					begin 
					if (ie_consignado_p = 'N') then					 
						qt_coluna_w	:= sup_obter_valor_estoque( 
										cd_estabelecimento_w, 
										PKG_DATE_UTILS.start_of(clock_timestamp(),'month',0), 
										cd_local_estoque_ww, 
										cd_material_w);
					else 
						qt_coluna_w	:= obter_valor_estoque_consig( 
										cd_estabelecimento_w, 
										PKG_DATE_UTILS.start_of(clock_timestamp(),'month',0), 
										cd_local_estoque_ww, 
										cd_material_w, 
										null);
					end if;
					end;
				else 
					begin 
					if (ie_consignado_p = 'N') then 
						qt_coluna_w	:= sup_obter_saldo_disp_estoque( 
									cd_estabelecimento_w, 
									cd_material_w, 
									cd_local_estoque_ww, 
									PKG_DATE_UTILS.start_of(clock_timestamp(),'month',0));
					else				 
						qt_coluna_w	:= obter_saldo_disp_consig( 
									cd_estabelecimento_w, 
									null, 
									cd_material_w, 
									cd_local_estoque_ww);
					end if;
					end;
				end if;
				end;
			elsif (ie_entrada_saida_w = 'SE') then 
				begin								 
				 
				if (ie_qt_vl_p = 'V') then 
					begin 
					if (ie_consignado_p = 'N') then 
						qt_coluna_w	:= sup_obter_valor_estoque( 
									cd_estabelecimento_w, 
									PKG_DATE_UTILS.start_of(dt_mesano_consulta_w,'month',0), 
									cd_local_estoque_ww, 
									cd_material_w);
					else 
						qt_coluna_w	:= obter_valor_estoque_consig( 
										cd_estabelecimento_w, 
										PKG_DATE_UTILS.start_of(dt_mesano_consulta_w,'month',0), 
										cd_local_estoque_ww, 
										cd_material_w, 
										null);
					end if;
					end;
				else 
					begin 
					if (ie_consignado_p = 'N') then 
						qt_coluna_w	:= sup_obter_saldo_estoque( 
									cd_estabelecimento_W, 
									dt_mesano_consulta_w, 
									cd_local_estoque_ww, 
									cd_material_W);
					else 
						select	coalesce(sum(a.qt_estoque),0) 
						into STRICT	qt_coluna_w 
						from	fornecedor_mat_consignado a 
						where	a.cd_estabelecimento	= cd_estabelecimento_w 
						and	a.cd_material		= cd_material_w 
						and	a.cd_local_estoque	= cd_local_estoque_ww 
						and	a.dt_mesano_referencia	= PKG_DATE_UTILS.start_of(dt_mesano_consulta_w,'month',0);
					end if;
								 
					qt_coluna_w := coalesce(qt_coluna_w,0);
					end;
				end if;
				end;
			end if;
 
			if (nr_seq_coluna_w = 1) then 
				qt_coluna1_w	:= qt_coluna1_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 2) then 
				qt_coluna2_w	:= qt_coluna2_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 3) then 
				qt_coluna3_w	:= qt_coluna3_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 4) then 
				qt_coluna4_w	:= qt_coluna4_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 5) then 
				qt_coluna5_w	:= qt_coluna5_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 6) then 
				qt_coluna6_w	:= qt_coluna6_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 7) then 
				qt_coluna7_w	:= qt_coluna7_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 8) then 
				qt_coluna8_w	:= qt_coluna8_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 9) then 
				qt_coluna9_w	:= qt_coluna9_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 10) then 
				qt_coluna10_w	:= qt_coluna10_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 11) then 
				qt_coluna11_w	:= qt_coluna11_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 12) then 
				qt_coluna12_w	:= qt_coluna12_w + qt_coluna_w;
			elsif (nr_seq_coluna_w = 13) then 
				qt_coluna13_w	:= qt_coluna13_w + qt_coluna_w;
			end if;
 
			end;
		END LOOP;
		CLOSE C03;
 
 
		insert into w_mapa_estoque_coluna( 
			dt_atualizacao, 
			nm_usuario, 
			cd_material, 
			cd_local_estoque, 
			qt_coluna_1, 
			qt_coluna_2, 
			qt_coluna_3, 
			qt_coluna_4, 
			qt_coluna_5, 
			qt_coluna_6, 
			qt_coluna_7, 
			qt_coluna_8, 
			qt_coluna_9, 
			qt_coluna_10, 
			qt_coluna_11, 
			qt_coluna_12, 
			qt_coluna_13) 
		values (	dt_atualizacao_w, 
			nm_usuario_p, 
			cd_material_w, 
			cd_local_estoque_ww, 
			qt_coluna1_w, 
			qt_coluna2_w, 
			qt_coluna3_w, 
			qt_coluna4_w, 
			qt_coluna5_w, 
			qt_coluna6_w, 
			qt_coluna7_w, 
			qt_coluna8_w, 
			qt_coluna9_w, 
			qt_coluna10_w, 
			qt_coluna11_w, 
			qt_coluna12_w, 
			qt_coluna13_w);
		end;
	END LOOP;
	CLOSE C02;
	end;
end loop;
close C01;
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_mapa_estoque_local (nr_seq_mapa_p bigint, nm_usuario_p text, ie_qt_vl_p text, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp, ie_consignado_p text) FROM PUBLIC;
