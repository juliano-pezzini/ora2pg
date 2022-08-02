-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_pls_relat_analise_carteira ( nr_seq_grupo_inicial_p bigint, nr_seq_grupo_final_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, qt_usuarios_inicial_p bigint, qt_usuarios_final_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_grupo_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_conta_w			bigint;
ds_grupo_w			varchar(255);
nr_seq_plano_w			bigint;

qt_exames_benef_w		bigint;
qt_internacao_benef_w		bigint;
qt_consultas_benef_w		bigint;
vl_mensalidade_benef_w		double precision;
vl_despesa_benef_w		double precision;

qt_exames_contr_w		bigint;
qt_internacao_contr_w		bigint;
qt_consultas_contr_w		bigint;
vl_mensalidade_contr_w		double precision;
vl_despesa_contr_w		double precision;
vl_receita_por_vida_w		double precision;
vl_despesa_por_vida_w		double precision;
vl_lucro_prejuizo_w		double precision;
tx_rentabilidade_w		double precision;
tx_sinistralidade_w		double precision;

ie_tipo_conta_w			varchar(10);
ie_tipo_guia_w			varchar(10);
cd_tiss_w			varchar(10);
vl_despesa_w			double precision;

qt_total_contas_w		bigint;
tx_consultas_w			double precision;
tx_exames_w			double precision;
tx_internacao_w			double precision;

vl_mensalidade_w		double precision;
qt_meses_w			bigint;
tx_administrativa_w		double precision;
qt_benef_grupo_w		bigint;

dt_inicial_w			timestamp;
dt_final_w			timestamp;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ds_grupo
	from	pls_grupo_contrato	a
	where	((a.nr_sequencia	>= nr_seq_grupo_inicial_p and (nr_seq_grupo_inicial_p IS NOT NULL AND nr_seq_grupo_inicial_p::text <> '')) or (coalesce(nr_seq_grupo_inicial_p::text, '') = ''))
	and	((a.nr_sequencia	<= nr_seq_grupo_final_p and (nr_seq_grupo_final_p IS NOT NULL AND nr_seq_grupo_final_p::text <> '')) or (coalesce(nr_seq_grupo_final_p::text, '') = ''))
	and	a.ie_situacao		= 'A';

C02 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_segurado		b,
		pls_contrato		a,
		pls_contrato_grupo	c
	where	b.nr_seq_contrato	= a.nr_sequencia
	and	c.nr_seq_contrato	= a.nr_sequencia
	and	c.nr_seq_grupo		= nr_seq_grupo_w
	and	coalesce(b.dt_rescisao::text, '') = ''
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

C04 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.ie_tipo_guia,
		( SELECT max(c.cd_tiss)
		  from pls_tipo_atendimento c
		  where	b.nr_seq_tipo_atendimento	= c.nr_sequencia),
		B.VL_TOTAL
	from	pls_conta		b
	where	b.nr_seq_segurado	= nr_seq_segurado_w
	and	b.ie_status		= 'F'
	and	b.dt_atendimento_referencia between dt_inicial_w and dt_final_w
	and	b.ie_tipo_guia	in ('3','5','4');


BEGIN

delete	FROM W_PLS_RELAT_RELACIONAMENTO
where	ie_tipo_relatorio = 'AC';

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
	nr_seq_grupo_w,
	ds_grupo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	count(*)
	into STRICT	qt_benef_grupo_w
	from	pls_contrato 		a,
		pls_segurado 		b,
		pls_contrato_grupo 	c
	where	a.nr_sequencia	= b.nr_seq_contrato
	and	coalesce(b.dt_rescisao::text, '') = ''
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	a.nr_sequencia = c.nr_seq_contrato
	and	c.nr_seq_grupo = nr_seq_grupo_w;

	if	(((qt_benef_grupo_w between qt_usuarios_inicial_p and qt_usuarios_final_p) and (qt_usuarios_final_p IS NOT NULL AND qt_usuarios_final_p::text <> '') and (qt_usuarios_inicial_p IS NOT NULL AND qt_usuarios_inicial_p::text <> '')) or (coalesce(qt_usuarios_inicial_p::text, '') = '') and (coalesce(qt_usuarios_final_p::text, '') = '')) then

		select	max(b.nr_seq_contrato)
		into STRICT	nr_seq_contrato_w
		from	pls_contrato_grupo	b,
			pls_contrato		a
		where	b.nr_seq_contrato	= a.nr_sequencia
		and	b.nr_seq_grupo		= nr_seq_grupo_w
		and	coalesce(a.dt_rescisao_contrato::text, '') = '';

		select	max(nr_seq_plano)
		into STRICT	nr_seq_plano_w
		from	pls_contrato_plano
		where	nr_seq_contrato	= nr_seq_contrato_w
		and	ie_situacao	= 'A';

		qt_consultas_benef_w		:= 0;
		qt_internacao_benef_w		:= 0;
		qt_exames_benef_w		:= 0;
		vl_despesa_benef_w		:= 0;
		vl_mensalidade_benef_w		:= 0;

		open c02;
		loop
		fetch c02 into
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			open C04;
			loop
			fetch C04 into
				nr_seq_conta_w,
				ie_tipo_guia_w,
				cd_tiss_w,
				vl_despesa_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin

				if (ie_tipo_guia_w	= '3') then
					ie_tipo_conta_w	:= 'C';
				elsif (ie_tipo_guia_w	= '5') then
					ie_tipo_conta_w	:= 'I';
				else
					if (cd_tiss_w	= '04') then
						ie_tipo_conta_w	:= 'C';
					elsif (cd_tiss_w	= '07') then
						ie_tipo_conta_w	:= 'I';
					else
						ie_tipo_conta_w	:= 'E';
					end if;
				end if;

				if (ie_tipo_conta_w	= 'C') then
					qt_consultas_benef_w	:= qt_consultas_benef_w + 1;
				elsif (ie_tipo_conta_w	= 'I') then
					qt_internacao_benef_w	:= qt_internacao_benef_w + 1;
				elsif (ie_tipo_conta_w	= 'E') then
					qt_exames_benef_w	:= qt_exames_benef_w + 1;
				end if;

				vl_despesa_benef_w	:= vl_despesa_benef_w + coalesce(vl_despesa_w,0);
				end;
			end loop;
			close C04;

			select	sum(a.vl_mensalidade)
			into STRICT	vl_mensalidade_w
			from	pls_mensalidade			b,
				pls_mensalidade_segurado	a
			where	a.nr_seq_mensalidade		= b.nr_sequencia
			and	a.nr_seq_segurado		= nr_seq_segurado_w
			and	a.dt_mesano_referencia  between dt_inicial_w and dt_final_w
			and	coalesce(b.dt_cancelamento::text, '') = '';

			vl_mensalidade_benef_w		:= vl_mensalidade_benef_w + coalesce(vl_mensalidade_w,0);
			end;
		end loop;
		close c02;

		qt_exames_contr_w	:= qt_exames_benef_w;
		qt_internacao_contr_w	:= qt_internacao_benef_w;
		qt_consultas_contr_w	:= qt_consultas_benef_w;

		vl_mensalidade_contr_w	:= vl_mensalidade_benef_w;
		vl_despesa_contr_w	:= vl_despesa_benef_w + (vl_despesa_benef_w *(tx_administrativa_w/100));

		qt_total_contas_w	:= qt_exames_contr_w + qt_internacao_contr_w + qt_consultas_contr_w;

		vl_receita_por_vida_w	:= dividir(vl_mensalidade_contr_w,qt_benef_grupo_w * qt_meses_w);
		vl_despesa_por_vida_w	:= dividir(vl_despesa_contr_w,qt_benef_grupo_w * qt_meses_w);

		vl_lucro_prejuizo_w	:= (vl_despesa_por_vida_w - vl_receita_por_vida_w) * -1;



		if (coalesce(vl_mensalidade_contr_w,0) = 0) then
			if (coalesce(vl_despesa_contr_w,0) = 0) then
				tx_sinistralidade_w	:= 0;
			else
				tx_sinistralidade_w	:= 100;
			end if;
		else
			tx_sinistralidade_w	:= dividir_sem_round(vl_despesa_contr_w,vl_mensalidade_contr_w) * 100;
		end if;

		tx_rentabilidade_w	:= round((dividir_sem_round((vl_despesa_contr_w - vl_mensalidade_contr_w)::numeric, 100) * -1)::numeric,2);
		tx_consultas_w		:= dividir((qt_consultas_contr_w*100),qt_total_contas_w);
		tx_exames_w		:= dividir((qt_exames_contr_w*100),qt_total_contas_w);
		tx_internacao_w		:= dividir((qt_internacao_contr_w*100),qt_total_contas_w);

		if (tx_rentabilidade_w > 999) then
			tx_rentabilidade_w	:= 999;
		elsif (tx_rentabilidade_w < -999) then
			tx_rentabilidade_w	:= -999;
		end if;

		insert into w_pls_relat_relacionamento(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_grupo,ds_grupo_contrato,tx_consultas,tx_exames,tx_internacao,
				vl_custo_total,vl_receita_total,vl_despesa_benef,vl_receita_benef,vl_lucro_prejuizo,
				tx_rentabilidade,tx_sinistro,nr_seq_contrato,nr_seq_plano,qt_beneficiarios,ie_tipo_relatorio)
		values (	nextval('w_pls_relat_relacionamento_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				nr_seq_grupo_w,ds_grupo_w,tx_consultas_w,tx_exames_w,tx_internacao_w,
				vl_despesa_contr_w,vl_mensalidade_contr_w,vl_despesa_por_vida_w,vl_receita_por_vida_w,vl_lucro_prejuizo_w,
				tx_rentabilidade_w,tx_sinistralidade_w,nr_seq_contrato_w,nr_seq_plano_w,qt_benef_grupo_w,'AC');
	END IF;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_pls_relat_analise_carteira ( nr_seq_grupo_inicial_p bigint, nr_seq_grupo_final_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, qt_usuarios_inicial_p bigint, qt_usuarios_final_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

