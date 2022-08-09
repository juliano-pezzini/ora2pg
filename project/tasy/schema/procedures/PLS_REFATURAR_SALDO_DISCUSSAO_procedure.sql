-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_refaturar_saldo_discussao (nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, dt_vencimento_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_conta_w			pls_conta.nr_sequencia%type;
vl_negado_w			pls_discussao_proc.vl_negado%type;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;

nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
nr_seq_intercambio_w		pls_intercambio.nr_sequencia%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
nr_seq_congenere_seg_w		pls_congenere.nr_sequencia%type;
nr_seq_conta_pos_w		pls_conta_pos_estabelecido.nr_sequencia%type;
qt_taxa_w			integer;
nr_seq_disc_proc_w		pls_discussao_proc.nr_sequencia%type;
nr_seq_disc_mat_w		pls_discussao_mat.nr_sequencia%type;
nr_seq_pls_fatura_w		pls_fatura.nr_sequencia%type;
qt_item_w			pls_discussao_proc.qt_negada%type;
ie_novo_pos_estab_w		pls_visible_false.ie_novo_pos_estab%type;
ie_valor_refat_disc_w		pls_parametros.ie_valor_refat_disc%type; -- N - Negado / S - Saldo
vl_saldo_w			pls_discussao_proc.vl_contestado%type;

C01 CURSOR FOR
	SELECT	c.nr_seq_conta,
		coalesce(a.vl_negado,0),
		a.nr_seq_conta_proc,
		null,
		a.nr_sequencia nr_seq_disc_proc,
		null nr_seq_disc_mat,
		l.nr_seq_pls_fatura,
		CASE WHEN coalesce(a.qt_negada,0)=0 THEN 1  ELSE a.qt_negada END  qt_item,
		coalesce(a.vl_contestado,0) - coalesce(a.vl_ndc,0) vl_saldo
	from	pls_discussao_proc		a,
		pls_contestacao_discussao	b,
		pls_contestacao			c,
		pls_lote_contestacao		l
	where	l.nr_sequencia	= c.nr_seq_lote
	and	b.nr_sequencia	= a.nr_seq_discussao
	and	c.nr_sequencia	= b.nr_seq_contestacao
	and	b.nr_seq_lote	= nr_seq_lote_disc_p
	and not exists (	SELECT	1
			from	pls_conta_pos_estabelecido z
			where	z.nr_seq_conta_proc	= a.nr_seq_conta_proc
			and	z.nr_seq_lote_disc	= b.nr_seq_lote
			and	z.ie_situacao		= 'A'
			and	coalesce(z.nr_seq_lote_fat::text, '') = '')
	
union all

	select	c.nr_seq_conta,
		coalesce(a.vl_negado,0),
		null,
		a.nr_seq_conta_mat,
		null nr_seq_disc_proc,
		a.nr_sequencia nr_seq_disc_mat,
		l.nr_seq_pls_fatura,
		CASE WHEN coalesce(a.qt_negada,0)=0 THEN 1  ELSE a.qt_negada END  qt_item,
		coalesce(a.vl_contestado,0) - coalesce(a.vl_ndc,0) vl_saldo
	from	pls_discussao_mat		a,
		pls_contestacao_discussao	b,
		pls_contestacao			c,
		pls_lote_contestacao		l
	where	l.nr_sequencia	= c.nr_seq_lote
	and	b.nr_sequencia	= a.nr_seq_discussao
	and	c.nr_sequencia	= b.nr_seq_contestacao
	and	b.nr_seq_lote	= nr_seq_lote_disc_p
	and not exists (	select	1
			from	pls_conta_pos_estabelecido z
			where	z.nr_seq_conta_mat	= a.nr_seq_conta_mat
			and	z.nr_seq_lote_disc	= b.nr_seq_lote
			and	z.ie_situacao		= 'A'
			and	coalesce(z.nr_seq_lote_fat::text, '') = '');

BEGIN
select	coalesce(max(ie_novo_pos_estab),'N')
into STRICT	ie_novo_pos_estab_w
from	pls_visible_false
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_novo_pos_estab_w = 'S') then
	-- Novo refaturamento
	CALL pls_faturamento_pck.refaturar_saldo_discussao( nr_seq_lote_disc_p, dt_vencimento_p, cd_estabelecimento_p, nm_usuario_p);
else
	select	coalesce(max(ie_valor_refat_disc),'N')
	into STRICT	ie_valor_refat_disc_w
	from	pls_parametros
	where	cd_estabelecimento	= cd_estabelecimento_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_conta_w,
		vl_negado_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_mat_w,
		nr_seq_disc_proc_w,
		nr_seq_disc_mat_w,
		nr_seq_pls_fatura_w,
		qt_item_w,
		vl_saldo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_valor_refat_disc_w = 'N') then -- Valor negado
			vl_saldo_w := coalesce(vl_negado_w,0);
		end if;		

		if (coalesce(vl_saldo_w,0) > 0) then
			insert into pls_conta_pos_estabelecido(nr_sequencia,
				nr_seq_conta,
				vl_beneficiario,
				vl_medico,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_lote_disc,
				nr_seq_conta_proc,
				nr_seq_conta_mat,
				ie_status_faturamento,
				ie_situacao,
				nr_seq_disc_proc,
				nr_seq_disc_mat,
				qt_item,
				ie_cobrar_mensalidade)
			values (nextval('pls_conta_pos_estabelecido_seq'),
				nr_seq_conta_w,
				vl_saldo_w,
				vl_saldo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_lote_disc_p,
				nr_seq_conta_proc_w,
				nr_seq_conta_mat_w,
				'L',
				'A',
				nr_seq_disc_proc_w,
				nr_seq_disc_mat_w,
				qt_item_w,
				'N') returning nr_sequencia into nr_seq_conta_pos_w;

				CALL pls_gerar_contab_val_adic(nr_seq_conta_w,nr_seq_conta_proc_w,nr_seq_conta_mat_w,null,null,nr_seq_disc_proc_w,nr_seq_disc_mat_w,'P','D',nm_usuario_p);

			if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') then
				-- NAO PODE GERAR SE JA FOI GERADA A TAXA
				select	count(1)
				into STRICT	qt_taxa_w
				from	pls_conta_pos_estab_taxa 	a,
					pls_conta_pos_estabelecido	b
				where	b.nr_sequencia		= a.nr_seq_conta_pos_estab
				and	b.nr_seq_conta		= nr_seq_conta_w
				and	b.nr_seq_lote_disc	= nr_seq_lote_disc_p
				and	b.nr_seq_conta_proc	= nr_seq_conta_proc_w;

				if (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') and (qt_taxa_w = 0) then
					-- NAO PODE GERAR SE JA FOI GERADA NA FATURA ANTERIOR
					select	count(1)
					into STRICT	qt_taxa_w
					from	pls_fatura_proc		p,
						pls_fatura_conta	c,
						pls_fatura_evento	e
					where	e.nr_sequencia		= c.nr_seq_fatura_evento
					and	c.nr_sequencia		= p.nr_seq_fatura_conta
					and	e.nr_seq_fatura		= nr_seq_pls_fatura_w
					and	p.nr_seq_conta_proc	= nr_seq_conta_proc_w
					and	p.ie_tipo_cobranca	in ('3','4');
				end if;

			elsif (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') then
				-- NAO PODE GERAR SE JA FOI GERADA A TAXA
				select	count(1)
				into STRICT	qt_taxa_w
				from	pls_conta_pos_estab_taxa 	a,
					pls_conta_pos_estabelecido	b
				where	b.nr_sequencia		= a.nr_seq_conta_pos_estab
				and	b.nr_seq_conta		= nr_seq_conta_w
				and	b.nr_seq_lote_disc	= nr_seq_lote_disc_p
				and	b.nr_seq_conta_mat	= nr_seq_conta_mat_w;
			
				if (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') and (qt_taxa_w = 0) then
					-- NAO PODE GERAR SE JA FOI GERADA NA FATURA ANTERIOR
					select	count(1)
					into STRICT	qt_taxa_w
					from	pls_fatura_mat		m,
						pls_fatura_conta	c,
						pls_fatura_evento	e
					where	e.nr_sequencia		= c.nr_seq_fatura_evento
					and	c.nr_sequencia		= m.nr_seq_fatura_conta
					and	e.nr_seq_fatura		= nr_seq_pls_fatura_w
					and	m.nr_seq_conta_mat	= nr_seq_conta_mat_w
					and	m.ie_tipo_cobranca	in ('3','4');
				end if;
			end if;

			if (qt_taxa_w = 0) then
				select	b.nr_seq_contrato,
					b.nr_seq_intercambio,
					--nvl(a.nr_seq_plano,b.nr_seq_plano),
					coalesce(a.nr_seq_plano, pls_obter_produto_benef(b.nr_sequencia, a.dt_atendimento_referencia)),
					coalesce(b.nr_seq_ops_congenere,b.nr_seq_congenere)
				into STRICT	nr_seq_contrato_w,
					nr_seq_intercambio_w,
					nr_seq_plano_w,
					nr_seq_congenere_seg_w
				from	pls_conta	a,
					pls_segurado	b
				where	a.nr_seq_segurado	= b.nr_sequencia
				and	a.nr_sequencia		= nr_seq_conta_w;

				CALL pls_gerar_taxa_adm_pos_estab( nr_seq_conta_w, nr_seq_contrato_w, nr_seq_intercambio_w, nr_seq_plano_w, clock_timestamp(), nr_seq_congenere_seg_w, nm_usuario_p);
			end if;
			
			-- Gerar participante
			CALL pls_gerar_conta_pos_estab_part(  nr_seq_conta_pos_w, 'N', nm_usuario_p);  	-- jtrindade OS2165184
		end if;
		end;
	end loop;
	close C01;

	-- Gerar lote de faturamento
	CALL pls_gerar_lote_refaturamento(nr_seq_lote_disc_p,coalesce(dt_vencimento_p,clock_timestamp()),'N',cd_estabelecimento_p,nm_usuario_p);

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_refaturar_saldo_discussao (nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, dt_vencimento_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
