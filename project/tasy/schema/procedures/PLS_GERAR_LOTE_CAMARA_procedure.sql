-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_camara (nr_seq_lote_p bigint, ie_opcao_p text, nm_usuario_p text, ie_cp_cr_p text) AS $body$
DECLARE


-- IE_OPCAO_P
-- G - Gerar
-- D - Desfazer
cd_cgc_w		varchar(14);
nr_titulo_pagar_w	bigint;
nr_titulo_receber_w	bigint;
dt_periodo_inicial_cr_w	timestamp;
dt_periodo_final_cr_w	timestamp;
dt_periodo_inicial_cp_w	timestamp;
dt_periodo_final_cp_w	timestamp;
nr_seq_camara_w		bigint;
nr_seq_periodo_w	bigint;
ie_tipo_data_cp_w	varchar(3);
ie_tipo_data_cr_w	varchar(3);
dt_lote_w		timestamp;
cd_estabelecimento_w	bigint;
cd_cgc_outorgante_w	varchar(14);

-- CGC's das unimeds conforme a câmara
c01 CURSOR FOR
	-- CGC's da próprio cooperativa vinculada a câmara
	SELECT	distinct
		a.cd_cgc
	from	pls_congenere_camara b,
		pls_congenere a
	where	a.ie_tipo_congenere	= 'CO'
	and	b.nr_seq_congenere	= a.nr_sequencia
	and	b.nr_sequencia		= 	(SELECT	max(x.nr_sequencia)
						from	pls_congenere_camara x
						where	x.nr_seq_congenere = b.nr_seq_congenere
						and	coalesce(x.dt_fim_vigencia::text, '') = '')
	and	b.nr_seq_camara		= nr_seq_camara_w
	
union

	-- CGC's da cooperativa responsável financeira (pode não estar vinculada a câmara)
	select	distinct
		c.cd_cgc
	from	pls_congenere c,
		pls_congenere_camara b,
		pls_congenere a
	where	a.ie_tipo_congenere	= 'CO'
	and	b.nr_seq_congenere	= a.nr_sequencia
	and	b.nr_sequencia		= 	(select	max(x.nr_sequencia)
						from	pls_congenere_camara x
						where	x.nr_seq_congenere = b.nr_seq_congenere
						and	coalesce(x.dt_fim_vigencia::text, '') = '')
	and	b.nr_seq_camara		= nr_seq_camara_w
	and	c.nr_sequencia		<> a.nr_sequencia
	and	pls_obter_coop_pag_resp_fin(a.nr_sequencia,coalesce(dt_lote_w,clock_timestamp())) = c.cd_cgc;

-- Títulos
c02 CURSOR FOR
	SELECT	a.nr_titulo nr_titulo_pagar,
		null nr_titulo_receber
	from	titulo_pagar a
	where	a.cd_cgc	= cd_cgc_w
	and	coalesce(a.dt_liquidacao::text, '') = ''
	and	a.dt_emissao between coalesce(dt_periodo_inicial_cp_w,a.dt_emissao) and
			coalesce(dt_periodo_final_cp_w,a.dt_emissao)
	and	ie_tipo_data_cp_w = 'E'
	and	ie_cp_cr_p = 'CP'
	and	ie_situacao <> 'C'
	and	a.cd_estabelecimento = cd_estabelecimento_w
	and	a.cd_cgc <> cd_cgc_outorgante_w
	
union all

	SELECT	null nr_titulo_pagar,
		a.nr_titulo nr_titulo_receber
	from	titulo_receber a
	where	a.cd_cgc	= cd_cgc_w
	and	coalesce(a.dt_liquidacao::text, '') = ''
	and	a.dt_emissao between coalesce(dt_periodo_inicial_cr_w,a.dt_emissao)
	and	coalesce(dt_periodo_final_cr_w,a.dt_emissao)
	and	ie_tipo_data_cr_w = 'E'
	and	ie_cp_cr_p = 'CR'
	and	ie_situacao <> '3'
	and	pls_obter_se_tit_rec_camara(a.ie_origem_titulo)	= 'S'
	and	a.cd_estabelecimento = cd_estabelecimento_w
	and	a.cd_cgc <> cd_cgc_outorgante_w
	
union all

	select	a.nr_titulo nr_titulo_pagar,
		null nr_titulo_receber
	from	titulo_pagar a
	where	a.cd_cgc	= cd_cgc_w
	and	coalesce(a.dt_liquidacao::text, '') = ''
	and	a.dt_vencimento_atual between coalesce(dt_periodo_inicial_cp_w,a.dt_vencimento_atual) and
			coalesce(dt_periodo_final_cp_w,a.dt_vencimento_atual)
	and	ie_tipo_data_cp_w = 'V'
	and	ie_cp_cr_p = 'CP'
	and	ie_situacao <> 'C'
	and	a.cd_estabelecimento = cd_estabelecimento_w
	and	a.cd_cgc <> cd_cgc_outorgante_w
	
union all

	select	null nr_titulo_pagar,
		a.nr_titulo nr_titulo_receber
	from	titulo_receber a
	where	a.cd_cgc	= cd_cgc_w
	and	coalesce(a.dt_liquidacao::text, '') = ''
	and	a.dt_pagamento_previsto between coalesce(dt_periodo_inicial_cr_w,a.dt_pagamento_previsto)
	and	coalesce(dt_periodo_final_cr_w,a.dt_pagamento_previsto)
	and	ie_tipo_data_cr_w = 'V'
	and	ie_cp_cr_p = 'CR'
	and	ie_situacao <> '3'
	and	pls_obter_se_tit_rec_camara(a.ie_origem_titulo)	= 'S'
	and	a.cd_estabelecimento = cd_estabelecimento_w
	and	a.cd_cgc <> cd_cgc_outorgante_w
	order by
		nr_titulo_pagar,
		nr_titulo_receber;


BEGIN
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

select	max(cd_cgc_outorgante)
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante
where	cd_estabelecimento	= cd_estabelecimento_w;

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	select	a.nr_seq_camara,
		a.nr_seq_periodo,
		a.dt_periodo_inicial,
		a.dt_periodo_final,
		a.dt_periodo_inicial_cp,
		a.dt_periodo_final_cp,
		coalesce(a.ie_tipo_data_cr,'E'),
		coalesce(a.ie_tipo_data_cp,'V'),
		a.dt_lote
	into STRICT	nr_seq_camara_w,
		nr_seq_periodo_w,
		dt_periodo_inicial_cr_w,
		dt_periodo_final_cr_w,
		dt_periodo_inicial_cp_w,
		dt_periodo_final_cp_w,
		ie_tipo_data_cr_w,
		ie_tipo_data_cp_w,
		dt_lote_w
	from	pls_lote_camara_comp a
	where	a.nr_sequencia	= nr_seq_lote_p;

	if (ie_opcao_p = 'G') then
		open c01;
		loop
		fetch c01 into
			cd_cgc_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			open c02;
			loop
			fetch c02 into
				nr_titulo_pagar_w,
				nr_titulo_receber_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				insert into pls_titulo_lote_camara(nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_lote_camara,
					nr_titulo_pagar,
					nr_titulo_receber,
					ie_tipo_inclusao)
				values (nextval('pls_titulo_lote_camara_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nr_seq_lote_p,
					nr_titulo_pagar_w,
					nr_titulo_receber_w,
					'A');
				end;
			end loop;
			close c02;
			end;
		end loop;
		close c01;

		if (ie_cp_cr_p = 'CR') then
			update	pls_lote_camara_comp
			set	dt_geracao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_lote_p;
		elsif (ie_cp_cr_p = 'CP') then
			update	pls_lote_camara_comp
			set	dt_geracao_cp	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_lote_p;
		end if;
	elsif (ie_opcao_p = 'D') then
		delete from pls_titulo_lote_camara
		where	nr_seq_lote_camara	= nr_seq_lote_p
		and	(((nr_titulo_receber IS NOT NULL AND nr_titulo_receber::text <> '') and ie_cp_cr_p = 'CR') or ((nr_titulo_pagar IS NOT NULL AND nr_titulo_pagar::text <> '') and ie_cp_cr_p = 'CP'));

		delete from pls_lote_camara_comp_hist
		where	nr_seq_lote_camara	= nr_seq_lote_p
		and	(((nr_titulo_receber IS NOT NULL AND nr_titulo_receber::text <> '') and ie_cp_cr_p = 'CR') or ((nr_titulo_pagar IS NOT NULL AND nr_titulo_pagar::text <> '') and ie_cp_cr_p = 'CP'));

		if (ie_cp_cr_p = 'CR') then
			update	pls_lote_camara_comp
			set	dt_geracao	 = NULL,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_lote_p;
		elsif (ie_cp_cr_p = 'CP') then
			update	pls_lote_camara_comp
			set	dt_geracao_cp	 = NULL,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_lote_p;
		end if;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_camara (nr_seq_lote_p bigint, ie_opcao_p text, nm_usuario_p text, ie_cp_cr_p text) FROM PUBLIC;
