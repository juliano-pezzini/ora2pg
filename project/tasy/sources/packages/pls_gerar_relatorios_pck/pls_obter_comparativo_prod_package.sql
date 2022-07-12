-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerar_relatorios_pck.pls_obter_comparativo_prod ( cd_prestador_p pls_prestador.cd_prestador%type, dt_mes_competencia_p pls_lote_pagamento.dt_mes_competencia%type, nr_seq_periodo_p pls_lote_pagamento.nr_seq_periodo%type, ie_tipo_relat_p text) RETURNS SETOF T_PLS_COMPARATIVO_PROD_PREST AS $body$
DECLARE

 
t_pls_comparativo_prod_row_w	pls_gerar_relatorios_pck.t_pls_comparativo_prod_row;
t_limpar_variavel_w		pls_gerar_relatorios_pck.t_pls_comparativo_prod_row;
ie_linha_w			bigint	:= 0;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
dt_final_w			pls_lote_pagamento.dt_mes_competencia%type;
dt_inicial_w			pls_lote_pagamento.dt_mes_competencia%type;
dt_anterior_w			pls_lote_pagamento.dt_mes_competencia%type;
ie_result_w			bigint;
			
C01 CURSOR(	nr_seq_prestador_pc	pls_prestador.nr_sequencia%type, 
		dt_inicial_pc		pls_lote_pagamento.dt_mes_competencia%type, 
		dt_final_pc		pls_lote_pagamento.dt_mes_competencia%type, 
		nr_seq_periodo_pc	pls_lote_pagamento.nr_seq_periodo%type) FOR 
	SELECT	c.cd_prestador, 
		c.nr_sequencia nr_seq_prestador, 
		substr(pls_obter_dados_prestador(c.nr_sequencia, 'N'),1,40) nm_prestador 
	from	pls_prestador		c, 
		pls_pagamento_prestador	b, 
		pls_lote_pagamento	a 
	where	a.nr_sequencia 		= b.nr_seq_lote 
	and	c.nr_sequencia 		= b.nr_seq_prestador 
	and (c.nr_sequencia		= nr_seq_prestador_pc or coalesce(nr_seq_prestador_pc::text, '') = '') 
	and (a.nr_seq_periodo	= nr_seq_periodo_pc or coalesce(nr_seq_periodo_pc::text, '') = '') 
	and	a.dt_mes_competencia 	between dt_inicial_pc and dt_final_pc 
	group by 
		c.nr_sequencia, 
		c.cd_prestador;
	
C02 CURSOR(	nr_seq_prestador_pc	pls_prestador.nr_sequencia%type, 
		dt_mes_competencia_pc	pls_lote_pagamento.dt_mes_competencia%type, 
		nr_seq_periodo_pc	pls_lote_pagamento.nr_seq_periodo%type) FOR 
	SELECT	vl_lote, 
  		dt_mes_competencia, 
		qt_itens 
	from (	SELECT	coalesce(sum(d.vl_liberado),0) vl_lote, 
				coalesce(count(d.qt_item), 0) qt_itens, 
         		a.dt_mes_competencia 
      		from	pls_conta_medica_resumo d,		 
         		pls_prestador	     c, 
         		pls_pagamento_prestador	b, 
         		pls_lote_pagamento	a 
      		where	a.nr_sequencia 		 = b.nr_seq_lote 
      		and	b.nr_seq_prestador = c.nr_sequencia 
      		and   d.nr_seq_lote_pgto = a.nr_sequencia 
			and  	c.nr_sequencia		= nr_seq_prestador_pc 
			and (a.nr_seq_periodo	= nr_seq_periodo_pc or coalesce(nr_seq_periodo_pc::text, '') = '') 
		    and	a.dt_mes_competencia	between dt_inicial_w and dt_final_w 
      		group by 
				a.dt_mes_competencia 
      		order by 
				a.dt_mes_competencia desc) alias7;

C03 CURSOR(	nr_seq_prestador_pc	pls_prestador.nr_sequencia%type, 
		nr_seq_periodo_pc	pls_lote_pagamento.nr_seq_periodo%type, 
		dt_inicial_pc		pls_lote_pagamento.dt_mes_competencia%type, 
		dt_final_pc		pls_lote_pagamento.dt_mes_competencia%type) FOR 
		SELECT c.cd_prestador, 
			c.nr_sequencia nr_seq_prestador, 
			pls_obter_dados_prestador(c.nr_sequencia, 'N') nm_prestador, 
			g.ds_grupo_receita ds_grupo_serv, 
			f.cd_procedimento cd_item, 
			f.ds_procedimento ds_item, 
			sum(d.qt_item) qt_item, 
			substr(pls_obter_dados_produto(h.nr_seq_plano,'P'),1,255) ds_preco, 
			sum(d.vl_liberado) vl_liberado     
		from  pls_conta        h,   
			grupo_receita      g,   
			procedimento      f, 
			pls_conta_proc     e,      
			pls_conta_medica_resumo d, 
			pls_prestador      c, 
			pls_pagamento_prestador b, 
			pls_lote_pagamento   a 
		where  a.nr_sequencia = b.nr_seq_lote 
		and   b.nr_seq_prestador 	= c.nr_sequencia 
		and   d.nr_seq_lote_pgto 	= a.nr_sequencia 
		and   e.nr_sequencia   	= d.nr_seq_conta_proc 
		and   f.cd_procedimento 	= e.cd_procedimento 
		and   f.ie_origem_proced 	= e.ie_origem_proced 
		and   g.nr_sequencia   	= f.nr_seq_grupo_rec 
		and   h.nr_sequencia   	= d.nr_seq_conta 
		and (c.nr_sequencia	  	= nr_seq_prestador_pc or coalesce(nr_seq_prestador_pc::text, '') = '') 
		and (a.nr_seq_periodo	= nr_seq_periodo_pc or coalesce(nr_seq_periodo_pc::text, '') = '') 
		and   a.dt_mes_competencia 	between dt_inicial_pc and dt_final_pc 
		group by 
			c.cd_prestador, 
			c.nr_sequencia, 
			g.ds_grupo_receita, 
			f.cd_procedimento, 
			f.ds_procedimento, 
			substr(pls_obter_dados_produto(h.nr_seq_plano,'P'),1,255) 
		
union all
 
		SELECT c.cd_prestador, 
			c.nr_sequencia nr_seq_prestador, 
			pls_obter_dados_prestador(c.nr_sequencia, 'N') nm_prestador, 
			substr(pls_obter_estrutura_material(g.nr_sequencia, null, null),1,50) ds_grupo_serv, 
			f.nr_sequencia cd_item, 
			f.ds_material ds_item, 
			sum(d.qt_item) qt_item, 
			substr(pls_obter_dados_produto(h.nr_seq_plano,'P'),1,255) ds_preco, 
			sum(d.vl_liberado) vl_liberado     
		from  pls_conta        h,   
			pls_estrutura_material g, 
			pls_material      f, 
			pls_conta_mat      e,      
			pls_conta_medica_resumo d, 
			pls_prestador      c, 
			pls_pagamento_prestador b, 
			pls_lote_pagamento   a 
		where  a.nr_sequencia = b.nr_seq_lote 
		and   b.nr_seq_prestador = c.nr_sequencia 
		and   d.nr_seq_lote_pgto = a.nr_sequencia 
		and   e.nr_sequencia   = d.nr_seq_conta_mat 
		and  	f.nr_sequencia 	  = e.nr_seq_material 
		and   g.nr_sequencia   = f.nr_seq_estrut_mat 
		and   h.nr_sequencia   = d.nr_seq_conta 
		and (c.nr_sequencia	  	= nr_seq_prestador_pc or coalesce(nr_seq_prestador_pc::text, '') = '') 
		and (a.nr_seq_periodo	= nr_seq_periodo_pc or coalesce(nr_seq_periodo_pc::text, '') = '') 
		and   a.dt_mes_competencia 	between dt_inicial_pc and dt_final_pc 
		group by 
			c.cd_prestador, 
			c.nr_sequencia, 
			g.nr_sequencia, 
			f.nr_sequencia, 
			f.ds_material, 
			substr(pls_obter_dados_produto(h.nr_seq_plano,'P'),1,255) 
		order by 
		   nm_prestador, 
		   ds_preco, 
		   ds_item;
			
C04 CURSOR(	nr_seq_prestador_pc	pls_prestador.nr_sequencia%type, 
		dt_inicial_pc		timestamp, 
		dt_final_pc		timestamp, 
		cd_item_pc			text) FOR 
	SELECT	vl_item, 
		dt_mes_competencia, 
		qt_itens 
	from	(	SELECT	coalesce(sum(d.vl_liberado),0) vl_item, 
				a.dt_mes_competencia, 
				count(d.qt_item) qt_itens 
			from	pls_conta_medica_resumo d, 
				pls_prestador		c, 
				pls_pagamento_prestador	b, 
				pls_lote_pagamento	a 
			where	a.nr_sequencia 		= b.nr_seq_lote 
			and	b.nr_seq_prestador	= c.nr_sequencia 
			and	d.nr_seq_lote_pgto	= a.nr_sequencia 
			and	c.nr_sequencia		= nr_seq_prestador_pc 
			and	((d.cd_procedimento = cd_item_pc) or (d.nr_seq_material = cd_item_pc))	 
			and	a.dt_mes_competencia	 between dt_inicial_pc and dt_final_pc 
			group by 
				a.dt_mes_competencia 
			order by a.dt_mes_competencia desc) alias7;
BEGIN
 
if (dt_mes_competencia_p IS NOT NULL AND dt_mes_competencia_p::text <> '')	then 
		 
	select	trunc(to_date(dt_mes_competencia_p), 'month'), 
		fim_dia(add_months(trunc(to_date(dt_mes_competencia_p), 'month'), -4)) 
	into STRICT	dt_final_w, 
		dt_inicial_w 
	;
end if;
 
if (cd_prestador_p IS NOT NULL AND cd_prestador_p::text <> '') then 
	select	nr_sequencia 
	into STRICT	nr_seq_prestador_w 
	from	pls_prestador 
	where	cd_prestador = cd_prestador_p;
else 
	nr_seq_prestador_w := null;
end if;
 
if (ie_tipo_relat_p = 'S') then 
	for	r_c01_w in C01(nr_seq_prestador_w, dt_inicial_w, dt_final_w, nr_seq_periodo_p) loop	 
		t_pls_comparativo_prod_row_w 	:= t_limpar_variavel_w;
		--ie_linha_w 			:= 0; 
		t_pls_comparativo_prod_row_w.cd_prestador	:= r_c01_w.cd_prestador;
		t_pls_comparativo_prod_row_w.nr_seq_prestador	:= r_c01_w.nr_seq_prestador;
		t_pls_comparativo_prod_row_w.nm_prestador	:= r_c01_w.nm_prestador;
		t_pls_comparativo_prod_row_w.dt_mes_competencia := dt_mes_competencia_p;
	 
		for	r_c02_w in C02(r_c01_w.nr_seq_prestador, dt_mes_competencia_p, nr_seq_periodo_p) loop	 
			 
			ie_result_w := round(months_between(trunc(dt_mes_competencia_p, 'month'), trunc(r_c02_w.dt_mes_competencia, 'month')));
			 
			if ( ie_result_w = 0) then 
				t_pls_comparativo_prod_row_w.vl_lote_1		:= r_c02_w.vl_lote;
				t_pls_comparativo_prod_row_w.qt_itens_1		:= r_c02_w.qt_itens;
				--t_pls_comparativo_prod_row_w.nr_seq_lote_1	:= r_c02_w.nr_seq_lote; 
			elsif ( ie_result_w = 1) then 
				t_pls_comparativo_prod_row_w.vl_lote_2		:= r_c02_w.vl_lote;
				t_pls_comparativo_prod_row_w.qt_itens_2		:= r_c02_w.qt_itens;
				--t_pls_comparativo_prod_row_w.nr_seq_lote_2	:= r_c02_w.nr_seq_lote; 
			elsif ( ie_result_w = 2) then 
				t_pls_comparativo_prod_row_w.vl_lote_3		:= r_c02_w.vl_lote;
				t_pls_comparativo_prod_row_w.qt_itens_3		:= r_c02_w.qt_itens;
				--t_pls_comparativo_prod_row_w.nr_seq_lote_3	:= r_c02_w.nr_seq_lote; 
			elsif ( ie_result_w = 3) then 
				t_pls_comparativo_prod_row_w.vl_lote_4		:= r_c02_w.vl_lote;
				t_pls_comparativo_prod_row_w.qt_itens_4		:= r_c02_w.qt_itens;
				--t_pls_comparativo_prod_row_w.nr_seq_lote_4	:= r_c02_w.nr_seq_lote; 
			end if;					
		end loop;
	 
		RETURN NEXT t_pls_comparativo_prod_row_w;
	end loop;
else 
	for	r_c03_w in C03(nr_seq_prestador_w, nr_seq_periodo_p, dt_inicial_w, dt_final_w) loop	 
		 
		t_pls_comparativo_prod_row_w 	:= t_limpar_variavel_w;
			 
		t_pls_comparativo_prod_row_w.cd_prestador	:= r_c03_w.cd_prestador;
		t_pls_comparativo_prod_row_w.nr_seq_prestador	:= r_c03_w.nr_seq_prestador;
		t_pls_comparativo_prod_row_w.nm_prestador	:= r_c03_w.nm_prestador;
		t_pls_comparativo_prod_row_w.ds_grupo_serv	:= r_c03_w.ds_grupo_serv;
		t_pls_comparativo_prod_row_w.cd_item		:= r_c03_w.cd_item;
		t_pls_comparativo_prod_row_w.ds_item		:= r_c03_w.ds_item;
		t_pls_comparativo_prod_row_w.ds_preco		:= r_c03_w.ds_preco;
		t_pls_comparativo_prod_row_w.dt_mes_competencia	:= dt_mes_competencia_p;
		--t_pls_comparativo_prod_row_w.vl_lote_1		:= r_c03_w.vl_liberado;	 
		 
		for	r_c04_w in C04(r_c03_w.nr_seq_prestador, dt_inicial_w, dt_final_w, r_c03_w.cd_item) loop	 
			ie_result_w := round(months_between(trunc(dt_mes_competencia_p, 'month'), trunc( r_c04_w.dt_mes_competencia, 'month')));
		 
			if ( ie_result_w = 0) then 
				t_pls_comparativo_prod_row_w.vl_lote_1		:= r_c04_w.vl_item;
				t_pls_comparativo_prod_row_w.qt_itens_1		:= r_c04_w.qt_itens;
			elsif ( ie_result_w = 1) then 
				t_pls_comparativo_prod_row_w.vl_lote_2		:= r_c04_w.vl_item;
				t_pls_comparativo_prod_row_w.qt_itens_2		:= r_c04_w.qt_itens;
			elsif (ie_result_w = 2) then 
				t_pls_comparativo_prod_row_w.vl_lote_3		:= r_c04_w.vl_item;
				t_pls_comparativo_prod_row_w.qt_itens_3		:= r_c04_w.qt_itens;
			elsif (ie_result_w = 3) then 
				t_pls_comparativo_prod_row_w.vl_lote_4		:= r_c04_w.vl_item;
				t_pls_comparativo_prod_row_w.qt_itens_4		:= r_c04_w.qt_itens;
			end if;					
		end loop;
	 
		RETURN NEXT t_pls_comparativo_prod_row_w;
	end loop;	
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_gerar_relatorios_pck.pls_obter_comparativo_prod ( cd_prestador_p pls_prestador.cd_prestador%type, dt_mes_competencia_p pls_lote_pagamento.dt_mes_competencia%type, nr_seq_periodo_p pls_lote_pagamento.nr_seq_periodo%type, ie_tipo_relat_p text) FROM PUBLIC;
