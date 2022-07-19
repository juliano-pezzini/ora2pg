-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_definir_comissao_mensal ( nr_seq_lote_p bigint, nr_seq_canal_venda_p bigint, nr_seq_comissao_p bigint, dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

				 
/* Campos do cursor C01 */
 
nr_seq_canal_grupo_w		bigint;

qt_regra_calculo_grupo_w	bigint;
contador_w 			bigint;
contem_dados_w 			bigint;
nr_seq_superior_w		bigint;
nr_seq_inferior_w		bigint;
qt_vidas_w			bigint;
nr_seq_regra_mens_w		bigint;
qt_vidas_canal_w		bigint;
qt_vidas_total_w		bigint;
nr_seq_equipe_w			bigint;
dt_referencia_w			timestamp;

C01 CURSOR FOR 
	SELECT	nr_seq_canal_venda 
	from	pls_canal_regra_mensal 
	where	nr_seq_regra_mensal = nr_seq_regra_mens_w;
	
C02 CURSOR FOR 
	SELECT	a.vl_mensalidade 
	from	pls_comissao_beneficiario	b, 
		pls_mensalidade_segurado	a		 
	where	a.nr_sequencia = b.nr_seq_segurado_mens 
	and	b.nr_seq_comissao = nr_seq_comissao_p;


BEGIN 
 
qt_vidas_total_w 	:= 0;
dt_referencia_w		:= trunc(dt_referencia_p,'month');
 
select	count(*) 
into STRICT	qt_regra_calculo_grupo_w 
from	pls_canal_regra_mensal	b, 
	pls_regra_adic_mensal	a	 
where	a.nr_sequencia = b.nr_seq_regra_mensal 
and	a.nr_seq_vendedor = nr_seq_canal_venda_p 
and	a.ie_calculo_grupo = 'S';
 
select	max(a.nr_sequencia) 
into STRICT	nr_seq_regra_mens_w 
from	pls_canal_regra_mensal	b, 
	pls_regra_adic_mensal	a	 
where	a.nr_sequencia = b.nr_seq_regra_mensal 
and	a.nr_seq_vendedor = nr_seq_canal_venda_p 
and	a.ie_calculo_grupo = 'S';
 
select	max(a.nr_sequencia) 
into STRICT	nr_seq_equipe_w 
from	pls_equipe_vend_vinculo	b, 
	pls_equipe_vendedor	a 
where	a.nr_sequencia = b.nr_seq_equipe 
and	b.nr_seq_vendedor = nr_seq_canal_venda_p 
and	dt_referencia_w between coalesce(dt_inicio_vigencia, dt_referencia_w) and coalesce(dt_fim_vigencia, dt_referencia_w);
 
if (qt_regra_calculo_grupo_w > 0) then 
 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_canal_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		select	sum(qt_vidas) /* Quantidade de vidas */
 
		into STRICT	qt_vidas_canal_w 
		from  (SELECT	count(distinct c.nr_sequencia) qt_vidas 
			from	pls_mensalidade			a, 
				pls_mensalidade_segurado 	b, 
				pls_segurado			c, 
				pls_plano			d, 
				pls_contrato			e 
			where	a.nr_sequencia		= b.nr_seq_mensalidade 
			and	b.nr_seq_segurado	= c.nr_sequencia 
			and	c.nr_seq_contrato	= e.nr_sequencia 
			and	d.nr_sequencia		= c.nr_seq_plano 
			and	coalesce(a.ie_cancelamento::text, '') = '' 
			and	c.nr_seq_vendedor_canal = nr_seq_canal_grupo_w 
			and	((trunc(c.dt_contratacao,'month') = dt_referencia_w) or (trunc(c.dt_liberacao,'month') = dt_referencia_w))			 
			
union all
 
			SELECT	count(distinct c.nr_sequencia) qt_vidas 
			from	pls_mensalidade			a, 
				pls_mensalidade_segurado 	b, 
				pls_segurado			c, 
				pls_plano			d, 
				pls_contrato			e, 
				pls_segurado_canal_compl	f 
			where	a.nr_sequencia		= b.nr_seq_mensalidade 
			and	b.nr_seq_segurado	= c.nr_sequencia 
			and	c.nr_seq_contrato	= e.nr_sequencia 
			and	d.nr_sequencia		= c.nr_seq_plano 
			and	f.nr_seq_segurado	= c.nr_sequencia 
			and	coalesce(a.ie_cancelamento::text, '') = '' 
			and	f.nr_seq_vendedor_canal = nr_seq_canal_grupo_w 
			and	((trunc(c.dt_contratacao,'month') = dt_referencia_w) or (trunc(c.dt_liberacao,'month') = dt_referencia_w))) alias15;	
				 
		qt_vidas_total_w := coalesce(qt_vidas_total_w,0) + coalesce(qt_vidas_canal_w,0) + coalesce(qt_vidas_w,0);
		CALL pls_gerar_lote_comissao_mensal(nr_seq_lote_p, nr_seq_canal_grupo_w, nr_seq_comissao_p, 'S', nr_seq_regra_mens_w, nm_usuario_p, cd_estabelecimento_p);
		qt_vidas_w := pls_gerar_comissao_grupo_mens(nr_seq_lote_p, nr_seq_canal_grupo_w, nr_seq_comissao_p, qt_vidas_w, dt_referencia_p, nr_seq_regra_mens_w, nr_seq_equipe_w, nm_usuario_p, cd_estabelecimento_p);
		qt_vidas_total_w := coalesce(qt_vidas_total_w,0) + coalesce(qt_vidas_canal_w,0) + coalesce(qt_vidas_w,0);
		 
		end;
	end loop;
	close C01;
 
end if;
 
CALL pls_gerar_lote_comissao_mensal(nr_seq_lote_p, nr_seq_canal_venda_p, nr_seq_comissao_p, 'N', null, nm_usuario_p, cd_estabelecimento_p);	
 
--commit; 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_definir_comissao_mensal ( nr_seq_lote_p bigint, nr_seq_canal_venda_p bigint, nr_seq_comissao_p bigint, dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

