-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_tit_camara ( nr_titulo_pagar_p titulo_pagar.nr_titulo%type, nr_titulo_receber_p titulo_receber.nr_titulo%type, nr_seq_camara_p pls_camara_compensacao.nr_sequencia%type, dt_referencia_p timestamp, -- dt_emissao_fatura_p
 qt_dias_a500_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_permite_inclusao_w		varchar(1)	:= 'S';
vl_desc_benefic_custo_w		double precision;
nr_seq_periodo_w		bigint;
nr_seq_lote_camara_w		bigint;
tx_administrativa_w		double precision;
dt_limite_a500_w		timestamp;
dt_saldo_credor_ini_w		timestamp;
dt_saldo_credor_fim_w		timestamp;
nr_seq_pls_lote_disc_w		titulo_receber.nr_seq_pls_lote_disc%type;
qt_fatura_pag_w			integer := 0;
ie_vinc_tit_prox_periodo_w	pls_parametros_camara.ie_vinc_tit_prox_periodo%type;
qt_registro_w			integer := 0;
ie_data_tit_pag_a560_w		pls_camara_compensacao.ie_data_tit_pag_a560%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_camara_calendario		b,
		pls_camara_calend_periodo	a
	where	a.nr_seq_calendario	= b.nr_sequencia
	and	b.nr_seq_camara		= nr_seq_camara_p
	and	a.dt_saldo_credor between dt_saldo_credor_ini_w and dt_saldo_credor_fim_w
	order by
		a.dt_saldo_credor desc;

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from  	pls_camara_calendario   b,
		pls_camara_calend_periodo a
	where 	a.nr_seq_calendario = b.nr_sequencia
	and 	b.nr_seq_camara   = nr_seq_camara_p
	and 	trunc(coalesce(dt_referencia_p,clock_timestamp()),'dd')  between a.dt_previa and a.dt_limite_a500
	order by
		a.dt_previa desc;

BEGIN
select	coalesce(max(a.ie_data_tit_pag_a560), 'V')
into STRICT  	ie_data_tit_pag_a560_w
from  	pls_camara_compensacao  a
where 	a.nr_sequencia    = nr_seq_camara_p;

if (nr_titulo_receber_p IS NOT NULL AND nr_titulo_receber_p::text <> '') then
	select	pls_obter_se_tit_rec_camara(a.ie_origem_titulo)
	into STRICT	ie_permite_inclusao_w
	from	titulo_receber	a
	where	a.nr_titulo	= nr_titulo_receber_p;
end if;

if (nr_seq_camara_p IS NOT NULL AND nr_seq_camara_p::text <> '') and
	((nr_titulo_receber_p IS NOT NULL AND nr_titulo_receber_p::text <> '' AND ie_permite_inclusao_w = 'S') or (nr_titulo_pagar_p IS NOT NULL AND nr_titulo_pagar_p::text <> '')) and (qt_dias_a500_p IS NOT NULL AND qt_dias_a500_p::text <> '') then
	dt_saldo_credor_ini_w	:= trunc(coalesce(dt_referencia_p,clock_timestamp()) - qt_dias_a500_p);
	dt_saldo_credor_fim_w	:= trunc(coalesce(dt_referencia_p,clock_timestamp()) + qt_dias_a500_p);

	select	max(nr_sequencia)
	into STRICT	nr_seq_periodo_w
	from (SELECT	a.nr_sequencia
		from	pls_camara_calendario b,
			pls_camara_calend_periodo a
		where	a.nr_seq_calendario	= b.nr_sequencia
		and	b.nr_seq_camara		= nr_seq_camara_p
		and	trunc(coalesce(dt_referencia_p,clock_timestamp()) + qt_dias_a500_p,'dd') <= trunc(a.dt_limite_a500,'dd')
		order by a.dt_limite_a500) alias5 LIMIT 1;

	select	count(1)
	into STRICT	qt_fatura_pag_w
	from	ptu_fatura
	where	nr_titulo	= nr_titulo_pagar_p;

	if (qt_fatura_pag_w = 0) then
		select	count(1)
		into STRICT	qt_fatura_pag_w
		from	ptu_fatura
		where	nr_titulo_ndc	= nr_titulo_pagar_p;
	end if;

	if (nr_titulo_pagar_p IS NOT NULL AND nr_titulo_pagar_p::text <> '') and (qt_fatura_pag_w = 0) then -- Se o titulo for de origem A500 importado, deve ser utilizada a data DT_LIMITE_A500

		-- se na camara de compensacao estiver considerando a data da postagem  e nao tiver dias configurados OS (2266083)
		if  ie_data_tit_pag_a560_w = 'P' and qt_dias_a500_p = 0 then
			open C02;
			loop
			fetch C02 into
				nr_seq_periodo_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			end loop;
			close C02;
		else
			open C01;
			loop
			fetch C01 into
				nr_seq_periodo_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
			end loop;
			close C01;
		end if;

	end if;

	-- Se achou periodo, verificar se ja tem lote para esse periodo para aquela camara
	if (nr_seq_periodo_w IS NOT NULL AND nr_seq_periodo_w::text <> '') then

		select	max(a.nr_sequencia)
		into STRICT	nr_seq_lote_camara_w
		from	pls_lote_camara_comp a
		where	a.nr_seq_camara		= nr_seq_camara_p
		and	a.nr_seq_periodo	= nr_seq_periodo_w
		and	coalesce(dt_baixa::text, '') = ''
		and (not exists (SELECT	1
					 from	ptu_camara_compensacao x
					 where  x.nr_seq_lote_camara	= a.nr_sequencia)
			or	(nr_titulo_pagar_p IS NOT NULL AND nr_titulo_pagar_p::text <> ''));


		if (coalesce(nr_seq_lote_camara_w::text, '') = '') then
		
			select	max(coalesce(ie_vinc_tit_prox_periodo,'N'))
			into STRICT	ie_vinc_tit_prox_periodo_w
			from	pls_parametros_camara
			where	cd_estabelecimento = cd_estabelecimento_p;
			
			if (ie_vinc_tit_prox_periodo_w = 'S') then
				select	count(1)
				into STRICT	qt_registro_w
				from	pls_lote_camara_comp a
				where	a.nr_seq_camara		= nr_seq_camara_p
				and	a.nr_seq_periodo	= nr_seq_periodo_w
				and	(dt_baixa IS NOT NULL AND dt_baixa::text <> '');
				
				if (qt_registro_w > 0) then
					select	coalesce(min(p.nr_sequencia),nr_seq_periodo_w)
					into STRICT	nr_seq_periodo_w
					from	pls_camara_calendario		c,
						pls_camara_calend_periodo	p
					where	p.nr_seq_calendario	= c.nr_sequencia
					and	c.nr_seq_camara		= nr_seq_camara_p
					and	p.nr_sequencia		> nr_seq_periodo_w;
				end if;
			end if;
		
			-- Criar um novo lote para essa camara e periodo
			select	nextval('pls_lote_camara_comp_seq')
			into STRICT	nr_seq_lote_camara_w
			;

			select	coalesce(max(a.tx_administrativa),0),
				max(a.vl_desc_benefic_custo)
			into STRICT	tx_administrativa_w,
				vl_desc_benefic_custo_w
			from	pls_camara_compensacao	a
			where	a.nr_sequencia	= nr_seq_camara_p;
			
			insert into pls_lote_camara_comp(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_camara,
				nr_seq_periodo,
				dt_lote,
				cd_estabelecimento,
				dt_geracao,
				dt_geracao_cp,
				tx_administrativa,
				vl_desc_benefic_custo,
				ie_tipo_data_cp,
				ie_tipo_data_cr)
			values (nr_seq_lote_camara_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_camara_p,
				nr_seq_periodo_w,
				clock_timestamp(),
				cd_estabelecimento_p,
				clock_timestamp(),
				clock_timestamp(),
				tx_administrativa_w,
				vl_desc_benefic_custo_w,
				'V',
				'E');
		end if;

		if (nr_seq_lote_camara_w IS NOT NULL AND nr_seq_lote_camara_w::text <> '') then
			insert into pls_titulo_lote_camara(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_titulo_pagar,
				nr_titulo_receber,
				nr_seq_lote_camara,
				ie_tipo_inclusao,
				vl_baixado)
			values (nextval('pls_titulo_lote_camara_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_titulo_pagar_p,
				nr_titulo_receber_p,
				nr_seq_lote_camara_w,
				'A',
				0);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_tit_camara ( nr_titulo_pagar_p titulo_pagar.nr_titulo%type, nr_titulo_receber_p titulo_receber.nr_titulo%type, nr_seq_camara_p pls_camara_compensacao.nr_sequencia%type, dt_referencia_p timestamp, qt_dias_a500_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
