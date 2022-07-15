-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_mapa_estoque (nr_seq_mapa_p bigint, nm_usuario_p text, ie_qt_vl_p text, ie_agrupa_p text, cd_local_estoque_p bigint, ie_disp_estoque_p text, dt_mesano_referencia_p timestamp) AS $body$
DECLARE


ie_tipo_w			varchar(1);
cd_estabelecimento_w		smallint;
cd_codigo_w			integer;
ds_descricao_w		varchar(100);
cd_operacao_estoque_w	smallint;
qt_estoque_w			double precision;
mes_anterior_w		timestamp;
qt_saldo_anterior_w		double precision;
qt_saldo_atual_w		double precision;
qt_saldo_atual_w2		double precision;
qt_saldo_disponivel_w	double precision;
qt_emprestimo_ent_w		double precision;
qt_emprestimo_sai_w		double precision;
nr_seq_coluna_w		smallint;
ie_entrada_saida_w		varchar(1);
qt_entrada1_w			double precision := 0;
qt_entrada2_w			double precision := 0;
qt_entrada3_w			double precision := 0;
qt_entrada4_w			double precision := 0;
qt_entrada5_w			double precision := 0;
qt_saida1_w			double precision := 0;
qt_saida2_w			double precision := 0;
qt_saida3_w			double precision := 0;
qt_saida4_w			double precision := 0;
qt_saida5_w			double precision;
qt_existe_w			bigint;

c01 CURSOR FOR
	/*Busca o saldo anterior*/

	SELECT	0 ie_tipo,
		CASE WHEN ie_agrupa_p='G' THEN  e.cd_grupo_material WHEN ie_agrupa_p='S' THEN  e.cd_subgrupo_material WHEN ie_agrupa_p='C' THEN  e.cd_classe_material WHEN ie_agrupa_p='M' THEN  a.cd_material END  cd_codigo,
		0,
		CASE WHEN ie_qt_vl_p='Q' THEN  sum(a.qt_estoque)  ELSE sum(a.vl_estoque) END  qt_estoque_w,
		0 qt_saldo_atual_w2
	from	estrutura_material_v e,
		saldo_estoque a
	where	a.cd_material = e.cd_material
	and	a.dt_mesano_referencia	= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_mesano_referencia_p, -1, 0),'month',0)
	and	a.cd_estabelecimento	= cd_estabelecimento_w
	and (a.cd_local_estoque	= cd_local_estoque_p or coalesce(cd_local_estoque_p,0) = 0)
	group by
		CASE WHEN ie_agrupa_p='G' THEN  e.cd_grupo_material WHEN ie_agrupa_p='S' THEN  e.cd_subgrupo_material WHEN ie_agrupa_p='C' THEN  e.cd_classe_material WHEN ie_agrupa_p='M' THEN  a.cd_material END
	
union all

	/*Busca o saldo atual*/

	SELECT	1 ie_tipo,
		CASE WHEN ie_agrupa_p='G' THEN  e.cd_grupo_material WHEN ie_agrupa_p='S' THEN  e.cd_subgrupo_material WHEN ie_agrupa_p='C' THEN  e.cd_classe_material WHEN ie_agrupa_p='M' THEN  a.cd_material END  cd_codigo,
		0,
		CASE WHEN ie_qt_vl_p='Q' THEN  sum(a.qt_estoque)  ELSE sum(a.vl_estoque) END ,
		sum(a.qt_estoque) /*necessario para depois obter o valor do disponivel*/
	from	estrutura_material_v e,
		saldo_estoque a
	where	a.cd_material = e.cd_material
	and	a.dt_mesano_referencia	= PKG_DATE_UTILS.start_of(dt_mesano_referencia_p,'month',0)
	and	a.cd_estabelecimento	= cd_estabelecimento_w
	and (a.cd_local_estoque	= cd_local_estoque_p or coalesce(cd_local_estoque_p,0) = 0)
	group by
		CASE WHEN ie_agrupa_p='G' THEN  e.cd_grupo_material WHEN ie_agrupa_p='S' THEN  e.cd_subgrupo_material WHEN ie_agrupa_p='C' THEN  e.cd_classe_material WHEN ie_agrupa_p='M' THEN  a.cd_material END 
		/*Busca os movimentos atuais*/

	
union all

	select	9 ie_tipo,
		CASE WHEN ie_agrupa_p='G' THEN  e.cd_grupo_material WHEN ie_agrupa_p='S' THEN  e.cd_subgrupo_material WHEN ie_agrupa_p='C' THEN  e.cd_classe_material WHEN ie_agrupa_p='M' THEN  a.cd_material END  cd_codigo,
		a.cd_operacao_estoque,
		CASE WHEN ie_qt_vl_p='Q' THEN  sum(a.qt_estoque)  ELSE sum(a.vl_estoque) END ,
		0
	from	estrutura_material_v e,
		operacao_estoque o,
		movto_estoque_operacao_v a
	where	a.dt_mesano_referencia	= dt_mesano_referencia_p
	and	a.cd_estabelecimento	= cd_estabelecimento_w
	and (a.cd_local_estoque	= cd_local_estoque_p or coalesce(cd_local_estoque_p,0) = 0)
	and	a.cd_operacao_estoque	= o.cd_operacao_estoque
	and	a.cd_material		= e.cd_material
	group by
		CASE WHEN ie_agrupa_p='G' THEN  e.cd_grupo_material WHEN ie_agrupa_p='S' THEN  e.cd_subgrupo_material WHEN ie_agrupa_p='C' THEN  e.cd_classe_material WHEN ie_agrupa_p='M' THEN  a.cd_material END ,
		a.cd_operacao_estoque
	order by ie_tipo;

c02 CURSOR FOR
	SELECT	b.nr_seq_coluna,
		b.ie_entrada_saida
	from	mapa_est_item b,
		mapa_est_item_oper a
	where	a.nr_seq_item		= b.nr_sequencia
	and	a.cd_operacao_estoque	= cd_operacao_estoque_w
	and	b.nr_seq_mapa		= nr_seq_mapa_p;


BEGIN
delete from w_mapa_estoque;
commit;

mes_anterior_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_mesano_referencia_p, -1, 0);

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	mapa_estoque
where	nr_sequencia = nr_seq_mapa_p;

open c01;
LOOP
FETCH C01 INTO
	ie_tipo_w,
	cd_codigo_w,
	cd_operacao_estoque_w,
	qt_estoque_w,
	qt_saldo_atual_w2;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_saldo_anterior_w	:= 0;
	qt_saldo_atual_w	:= 0;
	qt_saldo_disponivel_w	:= 0;
	qt_emprestimo_ent_w	:= 0;
	qt_emprestimo_sai_w	:= 0;

	if (ie_tipo_w = 9) then
		begin

		select	/*+ INDEX(b empmate_i1) index (c emprest_pk) */			coalesce(sum(b.qt_material),0)
		into STRICT	qt_emprestimo_ent_w
		from	emprestimo c,
			emprestimo_material b
		where	b.nr_emprestimo	= c.nr_emprestimo
		and	b.cd_material	= cd_codigo_w
		and	b.qt_material	> 0
		and	c.ie_tipo	= 'E'
		and	ie_qt_vl_p	= 'Q';

		select	/*+ INDEX(b empmate_i1) index (c emprest_pk) */			coalesce(sum(b.qt_material),0)
		into STRICT	qt_emprestimo_sai_w
		from	emprestimo c,
			emprestimo_material b
		where	b.nr_emprestimo	= c.nr_emprestimo
		and	b.cd_material 	= cd_codigo_w
		and	b.qt_material	> 0
		and	c.ie_tipo 	= 'S'
		and	ie_qt_vl_p	= 'Q';

		/* Verifica a coluna a ser incluido a quantidade
		e insere a quantidade no campo que deve ser somado*/
		qt_entrada1_w	:= 0;
		qt_entrada2_w	:= 0;
		qt_entrada3_w	:= 0;
		qt_entrada4_w	:= 0;
		qt_entrada5_w	:= 0;
		qt_saida1_w	:= 0;
		qt_saida2_w	:= 0;
		qt_saida3_w	:= 0;
		qt_saida4_w	:= 0;
		qt_saida5_w	:= 0;
		open c02;
		LOOP
		FETCH C02 INTO
			nr_seq_coluna_w,
			ie_entrada_saida_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (nr_seq_coluna_w = 1) then
				qt_entrada1_w	:= qt_entrada1_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 2) then
				qt_entrada2_w	:= qt_entrada2_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 3) then
				qt_entrada3_w	:= qt_entrada3_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 4) then
				qt_entrada4_w	:= qt_entrada4_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 5) then
				qt_entrada5_w	:= qt_entrada5_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 6) then
				qt_saida1_w	:= qt_saida1_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 7) then
				qt_saida2_w	:= qt_saida2_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 8) then
				qt_saida3_w	:= qt_saida3_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 9) then
				qt_saida4_w	:= qt_saida4_w + qt_estoque_w;
			elsif (nr_seq_coluna_w = 10) then
				qt_saida5_w	:= qt_saida5_w + qt_estoque_w;
			end if;
			end;
		END LOOP;
		CLOSE C02;
		end;
	end if;	/* Fim do tipo = 9 */
	if (ie_tipo_w = 0) then
		qt_saldo_anterior_w	:= qt_estoque_w;
	end if; /* Fim do tipo = 0 */
	if (ie_tipo_w = 1) then
		qt_saldo_atual_w	:= qt_estoque_w;

		if (ie_disp_estoque_p = 'S') then
			select	coalesce(sum(Obter_Saldo_Disp_Estoque(cd_estabelecimento_w, cd_material, coalesce(cd_local_estoque_p,0), PKG_DATE_UTILS.start_of(dt_mesano_referencia_p,'month',0))),0)
			into STRICT	qt_saldo_disponivel_w
			from	estrutura_material_v
			where	cd_codigo_w = CASE WHEN ie_agrupa_p='G' THEN  cd_grupo_material WHEN ie_agrupa_p='S' THEN  cd_subgrupo_material WHEN ie_agrupa_p='C' THEN  cd_classe_material WHEN ie_agrupa_p='M' THEN  cd_material END;

			/* Se for valor, divide o valor pela quantidade estoque e multiplica pelo disponivel*/

			if (ie_qt_vl_p = 'V') then
				qt_saldo_disponivel_w	:= dividir(qt_saldo_atual_w, qt_saldo_atual_w2) * qt_saldo_disponivel_w;
			end if;
		end if;
	end if; /* Fim do tipo = 1 */
	select	count(*)
	into STRICT	qt_existe_w
	from	w_mapa_estoque
	where	cd_codigo = cd_codigo_w;

	if (qt_existe_w = 0) then
		select	obter_desc_estrut_mat(
					CASE WHEN ie_agrupa_p='G' THEN  cd_codigo_w  ELSE null END ,
					CASE WHEN ie_agrupa_p='S' THEN  cd_codigo_w  ELSE null END ,
					CASE WHEN ie_agrupa_p='C' THEN  cd_codigo_w  ELSE null END ,
					CASE WHEN ie_agrupa_p='M' THEN  cd_codigo_w  ELSE null END )
		into STRICT	ds_descricao_w
		;

		insert into w_mapa_estoque(
			nr_sequencia,
			ds_descricao,
			dt_atualizacao,
			nm_usuario,
			cd_codigo,
			qt_saldo_anterior,
			qt_entrada1,
			qt_entrada2,
			qt_entrada3,
			qt_entrada4,
			qt_entrada5,
			qt_saida1,
			qt_saida2,
			qt_saida3,
			qt_saida4,
			qt_saida5,
			qt_saldo_atual,
			qt_emprestimo_ent,
			qt_emprestimo_sai,
			qt_saldo_disponivel)
		values (nextval('w_mapa_estoque_seq'),
			ds_descricao_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_codigo_w,
			qt_saldo_anterior_w,
			qt_entrada1_w,
			qt_entrada2_w,
			qt_entrada3_w,
			qt_entrada4_w,
			qt_entrada5_w,
			qt_saida1_w,
			qt_saida2_w,
			qt_saida3_w,
			qt_saida4_w,
			qt_saida5_w,
			qt_saldo_atual_w,
			qt_emprestimo_ent_w,
			qt_emprestimo_sai_w,
			qt_saldo_disponivel_w);
	else
		update	w_mapa_estoque
		set	qt_saldo_disponivel = qt_saldo_disponivel + qt_saldo_disponivel_w,
			qt_saldo_anterior = qt_saldo_anterior + qt_saldo_anterior_w,
			qt_saldo_atual  = qt_saldo_atual + qt_saldo_atual_w,
			qt_emprestimo_ent = qt_emprestimo_ent + qt_emprestimo_ent_w,
			qt_emprestimo_sai = qt_emprestimo_sai + qt_emprestimo_sai_w,
			qt_entrada1	= qt_entrada1 + qt_entrada1_w,
			qt_entrada2	= qt_entrada2 + qt_entrada2_w,
			qt_entrada3	= qt_entrada3 + qt_entrada3_w,
			qt_entrada4	= qt_entrada4 + qt_entrada4_w,
			qt_entrada5	= qt_entrada5 + qt_entrada5_w,
			qt_saida1	= qt_saida1 + qt_saida1_w,
			qt_saida2	= qt_saida2 + qt_saida2_w,
			qt_saida3	= qt_saida3 + qt_saida3_w,
			qt_saida4	= qt_saida4 + qt_saida4_w,
			qt_saida5	= qt_saida5 + qt_saida5_w
		where	cd_codigo	= cd_codigo_w;
	end if;
	end;
END LOOP;
CLOSE C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_mapa_estoque (nr_seq_mapa_p bigint, nm_usuario_p text, ie_qt_vl_p text, ie_agrupa_p text, cd_local_estoque_p bigint, ie_disp_estoque_p text, dt_mesano_referencia_p timestamp) FROM PUBLIC;

