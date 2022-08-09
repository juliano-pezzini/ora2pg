-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_relat_2479 ( dt_periodo_p text, nr_contrato_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_contrato_w			pls_contrato.nr_contrato%type;
cd_cgc_estipulante_w		pls_contrato.cd_cgc_estipulante%type;
ds_estipulante_w		varchar(255);
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
dt_contrato_w			pls_contrato.dt_contrato%type;
dt_aniversario_contrato_w	timestamp;
qt_vidas_ativas_w		integer;
dt_mes_w			timestamp;
ie_informacao_w			varchar(2);
valor_w				double precision;
valor_1_w			double precision;
valor_2_w			double precision;
valor_3_w			double precision;
valor_4_w			double precision;
valor_5_w			double precision;
valor_6_w			double precision;
valor_7_w			double precision;
valor_8_w			double precision;
valor_9_w			double precision;
valor_10_w			double precision;
valor_11_w			double precision;
valor_12_w			double precision;
vl_total_w			double precision;
contador_w			bigint;
cd_cod_anterior_w 		pls_contrato.cd_cod_anterior%type;

C01 CURSOR FOR
	SELECT	a.cd_cod_anterior,
		a.nr_contrato,
		a.cd_cgc_estipulante,
		obter_razao_social(a.cd_cgc_estipulante) ds_estipulante,
		a.nr_sequencia,
		a.dt_contrato
	from 	pls_contrato a
	where	(((coalesce(nr_contrato_p,0) <> 0) and (a.nr_contrato = nr_contrato_p)) or (coalesce(nr_contrato_p,0) = 0))
	and	(a.cd_cgc_estipulante IS NOT NULL AND a.cd_cgc_estipulante::text <> '')
	and	a.ie_situacao = 2
	and	((coalesce(a.dt_reajuste::text, '') = '' and a.dt_contrato < add_months(to_date('01/'||dt_periodo_p),12))
		or ((a.dt_reajuste IS NOT NULL AND a.dt_reajuste::text <> '') and a.dt_reajuste < add_months(to_date('01/'||dt_periodo_p),12)))
	and exists (	SELECT 	1
			from	pls_contrato_plano b,
				pls_plano c
			where	b.nr_seq_contrato = a.nr_sequencia
			and	b.nr_seq_plano = c.nr_sequencia
			and	c.ie_tipo_contratacao in ('CA','CE'));

C02 CURSOR FOR
	SELECT	'V'
	
	
union all

	SELECT	'D'
	
	
union all

	select	'R'
	
	
union all

	select	'C'
	
	
union all

	select	'I'
	;

C03 CURSOR FOR
	SELECT	dt_mes
	from	mes_v
	where	dt_mes >= to_date('01/'||dt_periodo_p)  LIMIT 12;


BEGIN

delete	from w_pls_relat
where	nm_usuario = nm_usuario_p;

open C01;
loop
fetch C01 into
	cd_cod_anterior_w,
	nr_contrato_w,
	cd_cgc_estipulante_w,
	ds_estipulante_w,
	nr_seq_contrato_w,
	dt_contrato_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if ((to_char(dt_contrato_w,'mm'))::numeric  >= (substr(dt_periodo_p,1,2))::numeric ) then
		dt_aniversario_contrato_w := to_date('01/'||to_char(dt_contrato_w,'mm') ||'/'|| (substr(dt_periodo_p,4,4))::numeric );
	else
		dt_aniversario_contrato_w := to_date('01/'||to_char(dt_contrato_w,'mm') ||'/'|| ((substr(dt_periodo_p,4,4))::numeric +1));
	end if;

	select	count(1)
	into STRICT	qt_vidas_ativas_w
	from	pls_contrato a,
		pls_segurado b
	where	b.nr_seq_contrato	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_contrato_w
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	trunc(b.dt_contratacao,'month')	<= trunc(dt_aniversario_contrato_w,'month')
	and	((coalesce(b.dt_rescisao::text, '') = '') or (trunc(b.dt_rescisao,'month') > trunc(dt_aniversario_contrato_w,'month')));

	if (qt_vidas_ativas_w <= 29) then
		open C02;
		loop
		fetch C02 into
			ie_informacao_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			contador_w := 0;
			vl_total_w := 0;

			open C03;
			loop
			fetch C03 into
				dt_mes_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				contador_w := contador_w + 1;
				dt_mes_w	:= trunc(dt_mes_w,'month');

				if (ie_informacao_w = 'V') then
					select	count(1)
					into STRICT	valor_w
					from	pls_contrato a,
						pls_segurado b
					where	b.nr_seq_contrato = a.nr_sequencia
					and	a.nr_sequencia = nr_seq_contrato_w
					and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
					and	trunc(b.dt_contratacao,'month')	<= dt_mes_w
					and	((coalesce(b.dt_rescisao::text, '') = '') or (trunc(b.dt_rescisao,'month') > dt_mes_w));
				elsif (ie_informacao_w = 'D') then
					select	sum(c.vl_total)
					into STRICT	valor_w
					from	pls_contrato a,
						pls_segurado b,
						pls_conta c,
						pls_protocolo_conta d
					where	b.nr_seq_contrato = a.nr_sequencia
					and	c.nr_seq_segurado = b.nr_sequencia
					and	c.nr_seq_protocolo = d.nr_sequencia
					and	a.nr_sequencia = nr_seq_contrato_w
					and	trunc(d.dt_mes_competencia,'month')	= dt_mes_w;
				elsif (ie_informacao_w = 'R') then
					select	sum(d.vl_coparticipacao)
					into STRICT	valor_w
					from	pls_contrato a,
						pls_segurado b,
						pls_conta c,
						pls_conta_coparticipacao d,
						pls_mensalidade_segurado e,
						pls_mensalidade f
					where	b.nr_seq_contrato = a.nr_sequencia
					and	c.nr_seq_segurado = b.nr_sequencia
					and	d.nr_seq_conta = c.nr_sequencia
					and	d.nr_seq_mensalidade_seg = e.nr_sequencia
					and	e.nr_seq_mensalidade = f.nr_sequencia
					and	a.nr_sequencia = nr_seq_contrato_w
					and	trunc(f.dt_referencia,'month')	= dt_mes_w;
				elsif (ie_informacao_w = 'C') then
					select	sum(e.vl_item)
					into STRICT	valor_w
					from	pls_contrato a,
						pls_segurado b,
						pls_mensalidade c,
						pls_mensalidade_segurado d,
						pls_mensalidade_seg_item e
					where	b.nr_seq_contrato = a.nr_sequencia
					and	d.nr_seq_segurado = b.nr_sequencia
					and	d.nr_seq_mensalidade = c.nr_sequencia
					and	e.nr_seq_mensalidade_seg = d.nr_sequencia
					and	e.ie_tipo_item <> '3'
					and	a.nr_sequencia = nr_seq_contrato_w
					and	trunc(c.dt_referencia,'month')	= dt_mes_w;
				end if;

				if (contador_w = 1) then
					valor_1_w	:= coalesce(valor_w,0);
				elsif (contador_w = 2) then
					valor_2_w	:= coalesce(valor_w,0);
				elsif (contador_w = 3) then
					valor_3_w	:= coalesce(valor_w,0);
				elsif (contador_w = 4) then
					valor_4_w	:= coalesce(valor_w,0);
				elsif (contador_w = 5) then
					valor_5_w	:= coalesce(valor_w,0);
				elsif (contador_w = 6) then
					valor_6_w	:= coalesce(valor_w,0);
				elsif (contador_w = 7) then
					valor_7_w	:= coalesce(valor_w,0);
				elsif (contador_w = 8) then
					valor_8_w	:= coalesce(valor_w,0);
				elsif (contador_w = 9) then
					valor_9_w	:= coalesce(valor_w,0);
				elsif (contador_w = 10) then
					valor_10_w	:= coalesce(valor_w,0);
				elsif (contador_w = 11) then
					valor_11_w	:= coalesce(valor_w,0);
				elsif (contador_w = 12) then
					valor_12_w	:= coalesce(valor_w,0);
				end if;

				vl_total_w := vl_total_w + coalesce(valor_w,0);
				end;
			end loop;
			close C03;
			if (ie_informacao_w = 'V') then
				vl_total_w := vl_total_w / 12;
			end if;
			insert	into	w_pls_relat(	nr_sequencia, nr_seq_contrato, nr_contrato, cd_cgc_estipulante, nm_estipulante, cd_cod_anterior,
					ie_informacao, vl_mes_1, vl_mes_2, vl_mes_3, vl_mes_4, vl_mes_5, vl_mes_6,
					vl_mes_7, vl_mes_8, vl_mes_9, vl_mes_10, vl_mes_11, vl_mes_12,
					vl_total, nm_usuario, dt_atualizacao)
				values (	nextval('w_pls_relat_seq'), nr_seq_contrato_w, nr_contrato_w, cd_cgc_estipulante_w, ds_estipulante_w, cd_cod_anterior_w,
					ie_informacao_w, valor_1_w, valor_2_w, valor_3_w, valor_4_w, valor_5_w, valor_6_w,
					valor_7_w, valor_8_w, valor_9_w, valor_10_w, valor_11_w, valor_12_w,
					vl_total_w, nm_usuario_p, clock_timestamp());
			end;
		end loop;
		close C02;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_relat_2479 ( dt_periodo_p text, nr_contrato_p bigint, nm_usuario_p text) FROM PUBLIC;
