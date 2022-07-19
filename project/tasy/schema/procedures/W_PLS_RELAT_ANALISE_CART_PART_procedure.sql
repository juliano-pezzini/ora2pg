-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_pls_relat_analise_cart_part ( cd_usuario_plano_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
nr_seq_plano_w			bigint;
cd_usuario_plano_w		varchar(30);

vl_mensalidade_benef_w		double precision;
vl_despesa_benef_w		double precision;

vl_receita_por_vida_w		double precision;
vl_despesa_por_vida_w		double precision;
vl_lucro_prejuizo_w		double precision;
tx_rentabilidade_w		double precision;
tx_sinistralidade_w		double precision;

vl_mensalidade_w		double precision;
qt_meses_w			bigint;
tx_administrativa_w		double precision;
qt_benef_grupo_w		bigint;

dt_inicial_w			timestamp;
dt_final_w			timestamp;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.nr_seq_plano,
		a.cd_usuario_plano
	from	pls_segurado		b,
		pls_segurado_carteira	a
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	a.cd_usuario_plano	like '%'||cd_usuario_plano_p||'%';


BEGIN

delete	FROM W_PLS_RELAT_RELACIONAMENTO
where	ie_tipo_relatorio = 'AP';

qt_meses_w	:= months_between(dt_final_p,dt_inicial_p);

dt_inicial_w	:= trunc(dt_inicial_p,'Month');
dt_final_w	:= last_day(dt_final_p);

select	max(tx_administrativa)
into STRICT	tx_administrativa_w
from	pls_competencia
where	cd_estabelecimento = cd_estabelecimento_p
and	dt_mes_competencia = trunc(clock_timestamp(),'Month');

if (coalesce(tx_administrativa_w::text, '') = '') or (tx_administrativa_w = 0) then
	tx_administrativa_w	:= 1;
end if;

open C01;
loop
fetch C01 into
	nr_seq_segurado_w,
	nr_seq_plano_w,
	cd_usuario_plano_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	sum(coalesce(B.VL_TOTAL,0))
	into STRICT	vl_despesa_benef_w
	from	pls_conta		b,
		pls_segurado		a
	where	b.nr_seq_segurado		= a.nr_sequencia
	and	a.nr_sequencia			= nr_seq_segurado_w
	and	b.ie_status			= 'F'
	and	b.dt_atendimento_referencia between dt_inicial_w and dt_final_w
	and	b.ie_tipo_guia	in ('3','5','4');

	vl_despesa_benef_w	:= coalesce(vl_despesa_benef_w,0);

	select	sum(coalesce(a.vl_mensalidade,0))
	into STRICT	vl_mensalidade_benef_w
	from	pls_segurado			c,
		pls_mensalidade			b,
		pls_mensalidade_segurado	a
	where	a.nr_seq_mensalidade		= b.nr_sequencia
	and	a.nr_seq_segurado		= c.nr_sequencia
	and	c.nr_sequencia			= nr_seq_segurado_w
	and	a.dt_mesano_referencia  between dt_inicial_w and dt_final_w
	and	coalesce(b.dt_cancelamento::text, '') = '';

	vl_mensalidade_benef_w	:= coalesce(vl_mensalidade_benef_w,0);

	vl_lucro_prejuizo_w	:= (vl_despesa_benef_w - vl_mensalidade_benef_w) * -1;

	if (coalesce(vl_mensalidade_benef_w,0) = 0) then
		if (coalesce(vl_despesa_benef_w,0) = 0) then
			tx_rentabilidade_w	:= 0;
			tx_sinistralidade_w	:= 0;
		else
			tx_rentabilidade_w	:= 0;
			tx_sinistralidade_w	:= 100;
		end if;
	else
		tx_rentabilidade_w	:= round((dividir_sem_round(vl_despesa_benef_w,vl_mensalidade_benef_w) - 1 * 100)::numeric,4);
		tx_sinistralidade_w	:= round((dividir_sem_round(vl_despesa_benef_w,vl_mensalidade_benef_w) * 100)::numeric,4);
	end if;

	if (tx_rentabilidade_w > 1000) then
		tx_rentabilidade_w	:= 999;
	end if;

	if (tx_sinistralidade_w > 1000) then
		tx_sinistralidade_w	:= 999;
	end if;


	insert into w_pls_relat_relacionamento(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			vl_custo_total,vl_receita_total,vl_lucro_prejuizo,
			tx_rentabilidade,tx_sinistro,nr_seq_plano,qt_beneficiarios,ie_tipo_relatorio,DS_ESTIPULANTE_CONTRATO)
	values (	nextval('w_pls_relat_relacionamento_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
			vl_despesa_benef_w,vl_mensalidade_benef_w,vl_lucro_prejuizo_w,
			tx_rentabilidade_w,tx_sinistralidade_w,nr_seq_plano_w,1,'AP',cd_usuario_plano_w);

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_pls_relat_analise_cart_part ( cd_usuario_plano_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

