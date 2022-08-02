-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE reg_item AS (	nr_seq_item_classif		pls_titulo_rec_liq_mens.nr_sequencia%type,
				nr_seq_item			pls_titulo_rec_liq_mens.nr_seq_item_mens%type,
				vl_lancamento			pls_titulo_rec_liq_mens.vl_lancamento%type,
				vl_titulo			titulo_receber.vl_titulo%type,
				vl_saldo_item			titulo_receber.vl_saldo_titulo%type,
				nr_seq_segurado			pls_mensalidade_segurado.nr_seq_segurado%type,
				ie_permite_antecip		varchar(1),
				dt_referencia_mens		timestamp,
				dt_inicio_cobertura		timestamp,
				dt_fim_cobertura		timestamp,
				dt_ref_contab_inicial		timestamp,
				dt_ref_contab_final		timestamp,
				cd_conta_deb			pls_mensalidade_seg_item.cd_conta_deb%type,
				cd_conta_contabil_antec		pls_mensalidade_seg_item.cd_conta_contabil_rec_antec%type,
				cd_centro_custo			pls_mensalidade_seg_item.cd_centro_custo%type,
				cd_historico_baixa		pls_mensalidade_seg_item.cd_historico_baixa%type,
				cd_historico_rec_antec		pls_mensalidade_seg_item.cd_historico_rec_antec%type,
				dt_contabil			timestamp);
CREATE TYPE reg_tipo_lancamento AS (		ie_tipo_lancamento	varchar(2),
						cd_conta_debito		pls_titulo_rec_liq_mens.cd_conta_debito%type,
						cd_conta_credito	pls_titulo_rec_liq_mens.cd_conta_credito%type,
						cd_historico		pls_titulo_rec_liq_mens.cd_historico%type,
						vl_lancamento		pls_titulo_rec_liq_mens.vl_lancamento%type,
						dt_contabil		timestamp);


CREATE OR REPLACE PROCEDURE pls_gerar_tit_rec_liq_proj ( nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text, nr_titulo_contab_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Referencias:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
vl_recebido_w			titulo_receber_liq.vl_recebido%type;
nr_seq_baixa_w			titulo_receber_liq.nr_sequencia%type;
ie_origem_baixa_w		titulo_receber_liq.ie_origem_baixa%type;
nr_seq_liq_origem_w		titulo_receber_liq.nr_sequencia%type;
nr_lote_contabilizado_w		pls_titulo_rec_liq_mens.nr_lote_contabil%type	:= null;
vl_lancamento_total_w		pls_titulo_rec_liq_mens.vl_lancamento%type	:= 0;
nr_seq_ultimo_item_ba_w		pls_titulo_rec_liq_mens.nr_sequencia%type;
nr_seq_ultimo_item_ea_w		pls_titulo_rec_liq_mens.nr_sequencia%type;
nr_seq_ultimo_item_pr_w		pls_titulo_rec_liq_mens.nr_sequencia%type;
nr_seq_mensalidade_w		pls_mensalidade.nr_sequencia%type;
vl_titulo_w			titulo_receber.vl_titulo%type;
vl_tributo_w			pls_mensalidade_trib.vl_tributo%type;
ie_ultima_baixa_w		varchar(1);
ie_dia_cobertura_rec_antec_w	varchar(1);
nr_vetor_w			bigint	:= 0;
qt_reg_rec_antec_w		bigint 	:= 0;
vl_item_prop_w			double precision;
dt_inicio_cobertura_w		timestamp;
dt_recebimento_w		timestamp;
cd_estabelecimento_w		titulo_receber.cd_estabelecimento%type;
type t_pls_item is table
	of reg_item index by integer;
pls_item_w		t_pls_item;
type t_tipo_lancamento is table
	of reg_tipo_lancamento index by integer;
tipo_lancamento_w		t_tipo_lancamento;

c_itens CURSOR FOR
	SELECT	d.nr_sequencia nr_seq_item,
		coalesce(d.vl_item,0) vl_item,
		dividir_sem_round(coalesce(d.vl_item,0),coalesce(b.vl_mensalidade,0)) * 100 vl_percentual,
		'S' ie_permite_antecip,
		a.vl_titulo,
		a.vl_saldo_titulo,
		c.nr_seq_segurado,
		d.cd_conta_deb,
		d.cd_conta_antec_baixa,
		d.cd_conta_contabil_rec_antec,
		d.cd_historico_baixa,
		d.cd_historico_rec_antec,
		d.cd_centro_custo,
		b.dt_referencia dt_referencia_mens,
		d.ie_tipo_item,
		d.nr_seq_rec_futura,
		null vl_lancamento,
		null vl_saldo_item
	from	pls_mensalidade_seg_item	d,
		pls_mensalidade_segurado	c,
		pls_mensalidade			b,
		titulo_receber			a
	where	c.nr_sequencia	= d.nr_seq_mensalidade_seg
	and	b.nr_sequencia	= c.nr_seq_mensalidade
	and	b.nr_sequencia	= a.nr_seq_mensalidade
	and	d.ie_tipo_item	not in ('3', '6', '7')
	and	a.nr_titulo	= nr_titulo_p
	
union all

	SELECT	d.nr_sequencia nr_seq_item,
		coalesce(d.vl_item,0) vl_item,
		dividir_sem_round(coalesce(e.vl_coparticipacao,0),coalesce(b.vl_mensalidade,0)) * 100 vl_percentual,
		'N' ie_permite_antecip,
		a.vl_titulo,
		a.vl_saldo_titulo,
		c.nr_seq_segurado,
		coalesce(e.cd_conta_deb, d.cd_conta_deb) cd_conta_deb,
		coalesce(e.cd_conta_antec_baixa, d.cd_conta_antec_baixa) cd_conta_antec_baixa,
		d.cd_conta_contabil_rec_antec cd_conta_contabil_rec_antec,
		coalesce(e.cd_historico_baixa, d.cd_historico_baixa) cd_historico_baixa,
		coalesce(e.cd_historico_baixa, d.cd_historico_rec_antec) cd_historico_rec_antec,
		d.cd_centro_custo,
		b.dt_referencia dt_referencia_mens,
		d.ie_tipo_item,
		e.nr_seq_rec_futura,
		null vl_lancamento,
		null vl_saldo_item
	FROM pls_mensalidade_segurado c, pls_mensalidade b, titulo_receber a, pls_mensalidade_seg_item d
LEFT OUTER JOIN pls_conta_coparticipacao e ON (d.nr_seq_conta = e.nr_seq_conta)
WHERE c.nr_sequencia	= d.nr_seq_mensalidade_seg and b.nr_sequencia	= c.nr_seq_mensalidade and ((b.ie_cancelamento in ('C','E'))
	or (c.nr_sequencia	= e.nr_seq_mensalidade_seg)) and e.ie_status_coparticipacao  <> 'N' and b.nr_sequencia	= a.nr_seq_mensalidade and d.ie_tipo_item	= '3' and a.nr_titulo	= nr_titulo_p
	
union all

	select	d.nr_sequencia nr_seq_item,
		coalesce(d.vl_item,0) vl_item,
		dividir_sem_round(coalesce(d.vl_item,0),coalesce(b.vl_mensalidade,0)) * 100 vl_percentual,
		'N' ie_permite_antecip,
		a.vl_titulo,
		a.vl_saldo_titulo,
		c.nr_seq_segurado,
		coalesce(e.cd_conta_deb, d.cd_conta_deb) cd_conta_deb,
		null cd_conta_antec_baixa,
		null cd_conta_contabil_rec_antec,
		e.cd_historico cd_historico_baixa,
		null cd_historico_rec_antec,
		d.cd_centro_custo,
		b.dt_referencia dt_referencia_mens,
		d.ie_tipo_item,
		e.nr_seq_rec_futura,
		null vl_lancamento,
		null vl_saldo_item
	FROM pls_mensalidade_segurado c, pls_mensalidade b, titulo_receber a, pls_mensalidade_seg_item d
LEFT OUTER JOIN pls_conta_pos_estabelecido e ON (d.nr_seq_conta = e.nr_seq_conta)
WHERE c.nr_sequencia	= d.nr_seq_mensalidade_seg and b.nr_sequencia	= c.nr_seq_mensalidade and b.nr_sequencia	= a.nr_seq_mensalidade and d.ie_tipo_item	in ('6', '7') and a.nr_titulo	= nr_titulo_p;

c_itens_w	c_itens%rowtype;

BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_baixa_p IS NOT NULL AND nr_seq_baixa_p::text <> '') then
	nr_lote_contabilizado_w	:= null;
	
	select	max(a.nr_lote_contabil)
	into STRICT	nr_lote_contabilizado_w
	from	pls_titulo_rec_liq_mens	a
	where	a.nr_titulo	= nr_titulo_p
	and	a.nr_seq_baixa	= nr_seq_baixa_p
	and	a.nr_lote_contabil <> 0;
	
	
	if (nr_lote_contabilizado_w IS NOT NULL AND nr_lote_contabilizado_w::text <> '') then
		nr_titulo_contab_p := nr_titulo_p;
	else
		delete	from pls_titulo_rec_liq_mens
		where	nr_titulo	= nr_titulo_p
		and	nr_seq_baixa	= nr_seq_baixa_p;
		
		select	max(a.vl_titulo),
			max(a.cd_estabelecimento),
			max(a.nr_seq_mensalidade)
		into STRICT	vl_titulo_w,
			cd_estabelecimento_w,
			nr_seq_mensalidade_w
		from	titulo_receber a
		where	a.nr_titulo	= nr_titulo_p;
		
		if (nr_seq_mensalidade_w IS NOT NULL AND nr_seq_mensalidade_w::text <> '') then
			select	coalesce(max(ie_dia_cobertura_rec_antec), 'N')
			into STRICT	ie_dia_cobertura_rec_antec_w
			from	pls_parametro_contabil
			where	cd_estabelecimento	= cd_estabelecimento_w;
			
			select	max(a.vl_recebido),
				max(dt_recebimento),
				max(ie_origem_baixa),
				max(nr_seq_liq_origem)
			into STRICT	vl_recebido_w,
				dt_recebimento_w,
				ie_origem_baixa_w,
				nr_seq_liq_origem_w
			from	titulo_receber_liq a
			where	a.nr_titulo	= nr_titulo_p
			and	a.nr_sequencia	= nr_seq_baixa_p;
			
			select	coalesce(sum(vl_tributo),0)
			into STRICT	vl_tributo_w
			from	titulo_receber_trib
			where	nr_titulo		= nr_titulo_p
			and	coalesce(ie_origem_tributo, 'C') in ('D','CD');
			
			open c_itens;
			loop
			fetch c_itens into
				c_itens_w;
			EXIT WHEN NOT FOUND; /* apply on c_itens */
				begin
				
				select	max(a.dt_contratacao)
				into STRICT	dt_inicio_cobertura_w
				from	pls_segurado a
				where	a.nr_sequencia	= c_itens_w.nr_seq_segurado;
				
				-- Obter o valor ja baixado do item de mensalidade
				select	coalesce(sum(a.vl_lancamento),0)
				into STRICT	c_itens_w.vl_lancamento
				from	pls_titulo_rec_liq_mens a
				where	a.nr_seq_item_mens	= c_itens_w.nr_seq_item
				and	a.ie_tipo_lancamento	= 'PR';
				
				c_itens_w.vl_saldo_item	:= c_itens_w.vl_item - c_itens_w.vl_lancamento - dividir(c_itens_w.vl_percentual * vl_tributo_w,100);
				
				nr_vetor_w		:= nr_vetor_w + 1;
				
				if (c_itens_w.ie_permite_antecip = 'S') and (trunc(dt_recebimento_w,'month') < trunc(c_itens_w.dt_referencia_mens,'month')) and
					((c_itens_w.nr_seq_rec_futura IS NOT NULL AND c_itens_w.nr_seq_rec_futura::text <> '') or (c_itens_w.cd_conta_contabil_rec_antec IS NOT NULL AND c_itens_w.cd_conta_contabil_rec_antec::text <> '')) then
					pls_item_w[nr_vetor_w].ie_permite_antecip	:= 'S';
				else
					pls_item_w[nr_vetor_w].ie_permite_antecip	:= 'N';
				end if;
				
				pls_item_w[nr_vetor_w].nr_seq_item			:= c_itens_w.nr_seq_item;
				pls_item_w[nr_vetor_w].vl_lancamento			:= dividir(c_itens_w.vl_percentual * vl_recebido_w,100);
				pls_item_w[nr_vetor_w].vl_titulo			:= vl_titulo_w;
				pls_item_w[nr_vetor_w].vl_saldo_item			:= c_itens_w.vl_saldo_item;
				pls_item_w[nr_vetor_w].nr_seq_segurado			:= c_itens_w.nr_seq_segurado;
				pls_item_w[nr_vetor_w].dt_referencia_mens		:= c_itens_w.dt_referencia_mens;
				pls_item_w[nr_vetor_w].dt_inicio_cobertura		:= dt_inicio_cobertura_w;
				pls_item_w[nr_vetor_w].dt_ref_contab_final		:= last_day(c_itens_w.dt_referencia_mens);
				pls_item_w[nr_vetor_w].cd_conta_deb			:= c_itens_w.cd_conta_deb;
				pls_item_w[nr_vetor_w].cd_conta_contabil_antec		:= c_itens_w.cd_conta_contabil_rec_antec;
				pls_item_w[nr_vetor_w].cd_historico_baixa		:= c_itens_w.cd_historico_baixa;
				pls_item_w[nr_vetor_w].cd_historico_rec_antec		:= c_itens_w.cd_historico_rec_antec;
				pls_item_w[nr_vetor_w].dt_contabil			:= dt_recebimento_w;
				
				if (c_itens_w.ie_tipo_item = '3') then
					pls_item_w[nr_vetor_w].cd_conta_contabil_antec	:= c_itens_w.cd_conta_antec_baixa;
				end if;
				
				if (ie_dia_cobertura_rec_antec_w = 'N') then
					pls_item_w[nr_vetor_w].dt_ref_contab_inicial	:= trunc(c_itens_w.dt_referencia_mens,'month');
				else
					begin
					pls_item_w[nr_vetor_w].dt_ref_contab_inicial	:= to_date(to_char(dt_inicio_cobertura_w,'dd') || '/'|| to_char(c_itens_w.dt_referencia_mens,'mm/yyyy'));
					exception
					when others then
						pls_item_w[nr_vetor_w].dt_ref_contab_inicial	:= last_day(c_itens_w.dt_referencia_mens);
					end;
				end if;
				
				begin
				pls_item_w[nr_vetor_w].dt_fim_cobertura	:= to_date(to_char(dt_inicio_cobertura_w,'dd') - 1 || '/'|| to_char(pls_item_w[nr_vetor_w].dt_ref_contab_final,'mm/yyyy'));
				exception
				when others then
					pls_item_w[nr_vetor_w].dt_fim_cobertura	:= last_day(pls_item_w[nr_vetor_w].dt_ref_contab_final);
				end;
				
				end;
			end loop;
			close c_itens;
			
			-- Ultima baixa positiva
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_baixa_w
			from	titulo_receber_liq a
			where	a.nr_titulo	= nr_titulo_p
			and	a.nr_sequencia	= nr_seq_baixa_p
			and	a.vl_recebido	> 0;
			
			ie_ultima_baixa_w := 'N';
			
			-- Verifica se e a ultima baixa
			if	((coalesce(c_itens_w.vl_saldo_titulo,0) <> 0) and (vl_recebido_w = c_itens_w.vl_saldo_titulo)) or
				((coalesce(c_itens_w.vl_saldo_titulo,0) = 0) and (nr_seq_baixa_w = nr_seq_baixa_p)) then
				
				ie_ultima_baixa_w := 'S';
			end if;
			
			if (pls_item_w.count > 0) then
				for i in pls_item_w.first .. pls_item_w.last loop
					begin
					
					if (ie_ultima_baixa_w = 'N') then
						vl_lancamento_total_w	:= vl_lancamento_total_w + pls_item_w[i].vl_lancamento;
					else
						-- Na ultima baixa, aplicar diretamente o valor de saldo no item
						pls_item_w[i].vl_lancamento	:= pls_item_w[i].vl_saldo_item;
					end if;
					
					if (pls_item_w[i].ie_permite_antecip = 'S') then
						-- Baixa antecipada
						tipo_lancamento_w[1].ie_tipo_lancamento	:= 'BA';
						tipo_lancamento_w[1].cd_conta_debito	:= null;
						tipo_lancamento_w[1].cd_conta_credito	:= pls_item_w[i].cd_conta_contabil_antec;
						tipo_lancamento_w[1].cd_historico	:= pls_item_w[i].cd_historico_rec_antec;
						tipo_lancamento_w[1].dt_contabil	:= dt_recebimento_w;
						
						-- Estorno da baixa antecipada
						tipo_lancamento_w[2].ie_tipo_lancamento	:= 'EA';
						tipo_lancamento_w[2].cd_conta_debito	:= pls_item_w[i].cd_conta_contabil_antec;
						tipo_lancamento_w[2].cd_conta_credito	:= null;
						tipo_lancamento_w[2].cd_historico	:= pls_item_w[i].cd_historico_rec_antec;
						tipo_lancamento_w[2].dt_contabil	:= pls_item_w[i].dt_referencia_mens;
						
						-- Pro-rata
						tipo_lancamento_w[3].ie_tipo_lancamento	:= 'PR';
						tipo_lancamento_w[3].cd_conta_debito	:= null;
						tipo_lancamento_w[3].cd_conta_credito	:= pls_item_w[i].cd_conta_deb;
						tipo_lancamento_w[3].cd_historico		:= pls_item_w[i].cd_historico_baixa;
						tipo_lancamento_w[3].dt_contabil		:= pls_item_w[i].dt_referencia_mens;
						
						nr_seq_ultimo_item_ba_w			:= pls_item_w[1].nr_seq_item_classif;
						nr_seq_ultimo_item_ea_w			:= pls_item_w[2].nr_seq_item_classif;
						nr_seq_ultimo_item_pr_w			:= pls_item_w[3].nr_seq_item_classif;

					else
						-- Pro-rata
						tipo_lancamento_w[1].ie_tipo_lancamento	:= 'PR';
						tipo_lancamento_w[1].cd_conta_debito	:= null;
						tipo_lancamento_w[1].cd_conta_credito	:= pls_item_w[i].cd_conta_deb;
						tipo_lancamento_w[1].cd_historico		:= pls_item_w[i].cd_historico_baixa;
						tipo_lancamento_w[1].dt_contabil		:= dt_recebimento_w;
						
						nr_seq_ultimo_item_ba_w			:= null;
						nr_seq_ultimo_item_ea_w			:= null;
						nr_seq_ultimo_item_pr_w			:= pls_item_w[1].nr_seq_item_classif;
					end if;
					
					if (tipo_lancamento_w.count > 0) then
						for j in tipo_lancamento_w.first .. tipo_lancamento_w.last loop
							begin
							
							select	nextval('pls_titulo_rec_liq_mens_seq')
							into STRICT	pls_item_w[i].nr_seq_item_classif
							;
							
							insert into pls_titulo_rec_liq_mens(nr_sequencia,
									nr_titulo,
									nr_seq_baixa,
									nm_usuario_nrec,
									dt_atualizacao_nrec,
									nm_usuario,
									dt_atualizacao,
									nr_seq_item_mens,
									nr_seq_segurado,
									cd_conta_debito,
									cd_conta_credito,
									ie_tipo_lancamento,
									nr_lote_contabil,
									cd_historico,
									cd_centro_custo,
									vl_lancamento,
									dt_adesao,
									dt_ref_mens,
									dt_inicio_cobertura,
									dt_fim_cobertura,
									dt_ref_contab_inicial,
									dt_ref_contab_final,
									dt_contabil)
								values (pls_item_w[i].nr_seq_item_classif,
									nr_titulo_p,
									nr_seq_baixa_p,
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									pls_item_w[i].nr_seq_item,
									pls_item_w[i].nr_seq_segurado,
									tipo_lancamento_w[j].cd_conta_debito,
									tipo_lancamento_w[j].cd_conta_credito,
									tipo_lancamento_w[j].ie_tipo_lancamento,
									0,
									tipo_lancamento_w[j].cd_historico,
									pls_item_w[i].cd_centro_custo,
									pls_item_w[i].vl_lancamento,
									pls_item_w[i].dt_inicio_cobertura,
									pls_item_w[i].dt_referencia_mens,
									pls_item_w[i].dt_inicio_cobertura,
									pls_item_w[i].dt_fim_cobertura,
									pls_item_w[i].dt_ref_contab_inicial,
									pls_item_w[i].dt_ref_contab_final,
									tipo_lancamento_w[j].dt_contabil);
							
							end;
						end loop;
						tipo_lancamento_w.delete;
					end if;
					
					end;
				end loop;
				pls_item_w.delete;
			end if;
			
			if (ie_ultima_baixa_w = 'N') then
				if (vl_lancamento_total_w <> vl_recebido_w) then
					-- Aplicar diferenca no ultimo item
					
				update	pls_titulo_rec_liq_mens
					set	vl_lancamento	= vl_lancamento + (vl_recebido_w - vl_lancamento_total_w)
					where	nr_sequencia	in (nr_seq_ultimo_item_ba_w,nr_seq_ultimo_item_ea_w,nr_seq_ultimo_item_pr_w);
				end if;
			end if;
		end if;
	end if;
	
	pls_fiscal_dados_dmed_pck.gerar_baixa_tit_rec(nr_titulo_p, nr_seq_baixa_p, 'N', cd_estabelecimento_w, nm_usuario_p);
	
	CALL pls_gerar_classif_neg_tit_rec(nr_titulo_p, nr_seq_baixa_p, nm_usuario_p);
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tit_rec_liq_proj ( nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text, nr_titulo_contab_p INOUT bigint) FROM PUBLIC;

