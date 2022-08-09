-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_classif_ops_tit_pg ( nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_titulo_w		titulo_pagar.vl_titulo%type;
vl_baixa_w		titulo_pagar_baixa.vl_baixa%type;
vl_diferenca_w		double precision;
tx_classif_w		double precision;
vl_classif_w		titulo_pagar_baixa_cc_ops.vl_classificacao%type;
vl_classificacao_w	titulo_pagar_baixa_cc_ops.vl_classificacao%type;
vl_classif_item_w	titulo_pagar_baixa_cc_ops.vl_classificacao%type;
qt_itens_classif_ops_w	bigint;
qt_itens_w		bigint;
nr_seq_tit_pg_bx_ops_w	titulo_pagar_baixa_cc_ops.nr_sequencia%type;
nr_seq_tit_pg_bx_ops_ww titulo_pagar_baixa_cc_ops.nr_sequencia%type;
vl_diferenca_item_w	double precision;
vl_total_baixa_w	double precision;
ie_ultima_baixa_w	varchar(1);

C01 CURSOR(nr_titulo_pc		titulo_pagar.nr_titulo%type) FOR
	SELECT	nr_seq_segurado 	nr_seq_segurado,
		vl_classificacao 	vl_classificacao,
		ie_tipo_item		ie_tipo_item,
		nr_seq_tipo_lanc	nr_seq_tipo_lanc,
		nr_sequencia		nr_seq_classif_ops
	from	titulo_pagar_classif_ops
	where	nr_titulo 	= nr_titulo_pc;

BEGIN

pls_fiscal_dados_dmed_pck.gerar_baixa_tit_pag(nr_titulo_p, nr_seq_baixa_p, 'N', wheb_usuario_pck.get_cd_estabelecimento, nm_usuario_p);

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_baixa_p IS NOT NULL AND nr_seq_baixa_p::text <> '') then
	select	a.vl_titulo,
		b.vl_baixa
	into STRICT	vl_titulo_w,
		vl_baixa_w
	from	titulo_pagar 		a,
		titulo_pagar_baixa 	b
	where	a.nr_titulo 		= b.nr_titulo
	and	a.nr_titulo 		= nr_titulo_p
	and	b.nr_sequencia 		= nr_seq_baixa_p;
	
	if (vl_titulo_w > 0) then
		tx_classif_w	:= ((100*vl_baixa_w)/vl_titulo_w);
	else
		tx_classif_w	:= 0;
	end if;

	if (tx_classif_w > 0) then
		select	sum(vl_baixa)
		into STRICT	vl_total_baixa_w
		from	titulo_pagar_baixa
		where	nr_titulo = nr_titulo_p
		and	nr_sequencia <= nr_seq_baixa_p;
		
		ie_ultima_baixa_w := 'N';
		
		if (vl_total_baixa_w >= vl_titulo_w) then
			ie_ultima_baixa_w := 'S';
		end if;
		
		select	count(1)
		into STRICT	qt_itens_classif_ops_w
		from	titulo_pagar_classif_ops
		where	nr_titulo 	= nr_titulo_p;
		
		qt_itens_w	:= 0;

		delete from titulo_pagar_baixa_cc_ops
		where	nr_titulo = nr_titulo_p
		and	nr_seq_baixa = nr_seq_baixa_p;
		
		for r_c01_w in C01(nr_titulo_p) loop
			begin
			
			qt_itens_w	:= qt_itens_w + 1;
			
			vl_classif_w := ((r_c01_w.vl_classificacao/100)*tx_classif_w);
			
			select	nextval('titulo_pagar_baixa_cc_ops_seq')
			into STRICT	nr_seq_tit_pg_bx_ops_w
			;

			insert into 	titulo_pagar_baixa_cc_ops(nr_sequencia, nm_usuario, nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec,
					ie_tipo_item, nr_seq_baixa, nr_seq_classif_ops, nr_seq_segurado, nr_seq_tipo_lanc,
					nr_titulo, vl_classificacao)
			values (nr_seq_tit_pg_bx_ops_w, nm_usuario_p, nm_usuario_p, clock_timestamp(), clock_timestamp(),
					r_c01_w.ie_tipo_item, nr_seq_baixa_p, r_c01_w.nr_seq_classif_ops, r_c01_w.nr_seq_segurado, r_c01_w.nr_seq_tipo_lanc,
					nr_titulo_p, vl_classif_w);
					
			if (qt_itens_classif_ops_w = qt_itens_w) then
				select	sum(vl_classificacao)
				into STRICT	vl_classificacao_w
				from	titulo_pagar_baixa_cc_ops
				where	nr_titulo 	= nr_titulo_p
				and	nr_seq_baixa	= nr_seq_baixa_p;
				
				if (vl_classificacao_w <> vl_baixa_w) then
					vl_diferenca_w := (vl_baixa_w - vl_classificacao_w);

					update	titulo_pagar_baixa_cc_ops
					set	vl_classificacao = vl_classificacao + vl_diferenca_w
					where 	nr_sequencia 	= nr_seq_tit_pg_bx_ops_w;
				end if;
			end if;

			select	sum(a.vl_classificacao),
				max(a.nr_sequencia)
			into STRICT	vl_classif_item_w,
				nr_seq_tit_pg_bx_ops_ww
			from	titulo_pagar_baixa_cc_ops a,
				titulo_pagar_baixa b
			where	a.nr_titulo = b.nr_titulo
			and	b.nr_sequencia = a.nr_seq_baixa
			and	a.nr_seq_classif_ops = r_c01_w.nr_seq_classif_ops
			and	a.nr_titulo = nr_titulo_p
			and	not exists (	SELECT 	1
						from	titulo_pagar_baixa x
						where	x.nr_titulo = b.nr_titulo
						and	x.nr_seq_baixa_origem = b.nr_sequencia)
			and	coalesce(b.nr_seq_baixa_origem::text, '') = '';
			
			if (vl_classif_item_w > r_c01_w.vl_classificacao) then
				vl_diferenca_item_w := r_c01_w.vl_classificacao - vl_classif_item_w;
				
				update 	titulo_pagar_baixa_cc_ops
				set	vl_classificacao = vl_classificacao + vl_diferenca_item_w
				where 	nr_sequencia 	= nr_seq_tit_pg_bx_ops_ww;
			elsif (ie_ultima_baixa_w = 'S') then
				vl_diferenca_item_w := r_c01_w.vl_classificacao - vl_classif_item_w;
				
				update 	titulo_pagar_baixa_cc_ops
				set	vl_classificacao = vl_classificacao + vl_diferenca_item_w
				where 	nr_sequencia 	= nr_seq_tit_pg_bx_ops_ww;
			end if;
			
			end;
		end loop;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_classif_ops_tit_pg ( nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;
