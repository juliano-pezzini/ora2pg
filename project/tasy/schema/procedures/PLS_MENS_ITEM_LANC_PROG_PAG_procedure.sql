-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_mens_item_lanc_prog_pag ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, dt_referencia_p pls_mensalidade.dt_referencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_motivo_susp_p pls_motivo_susp_cobr_mens.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


dt_referencia_inicio_w		pls_mensalidade.dt_referencia%type;
dt_referencia_fim_w		pls_mensalidade.dt_referencia%type;
vl_mensalidade_w		pls_mensalidade_seg_item.vl_item%type;
qt_mens_benef_w			integer;
nr_seq_mens_arredondamento_w	pls_mensalidade_segurado.nr_sequencia%type;
ie_mensalidade_com_item_w	varchar(1);
vl_lancamento_w			pls_lancamento_mensalidade.vl_lancamento%type;
vl_rateio_w			pls_lancamento_mensalidade.vl_lancamento%type;
vl_item_w			pls_mensalidade_seg_item.vl_item%type;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;
ie_valor_apropriado_w		varchar(1);
vl_apropriacao_w		pls_lancamento_mens_aprop.vl_apropriacao%type;
qt_apropriacao_w		integer;
nr_seq_aprop_arredondamento_w	pls_lancamento_mens_aprop.nr_sequencia%type;
ie_diferenca_w			varchar(1);
vl_rateio_ww			double precision;
vl_diferenca_rateio_w		double precision;
tb_nr_seq_item_mens_w		pls_util_cta_pck.t_number_table;
tb_vl_item_w			pls_util_cta_pck.t_number_table;
nr_indice_w			bigint;
qt_contador_aprop_w		bigint;
vl_total_aprop_item_w		double precision;

C01 CURSOR(	nr_seq_pagador_pc	pls_contrato_pagador.nr_sequencia%type,
		dt_inicio_pc		pls_mensalidade.dt_referencia%type,
		dt_fim_pc		pls_mensalidade.dt_referencia%type) FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_motivo,
		coalesce(a.vl_lancamento,0) vl_lancamento,
		a.ie_tipo_item,
		a.cd_centro_custo,
		a.ds_observacao,
		a.cd_estabelecimento,
		b.ie_operacao_motivo
	from	pls_lancamento_mensalidade	a,
		pls_tipo_lanc_adic		b
	where	b.nr_sequencia	= a.nr_seq_motivo
	and	a.nr_seq_pagador = nr_seq_pagador_pc
	and	coalesce(a.nr_seq_segurado::text, '') = ''
	and	a.dt_mes_competencia between dt_inicio_pc and dt_fim_pc
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	(a.nm_usuario_liberacao IS NOT NULL AND a.nm_usuario_liberacao::text <> '')
	and	a.vl_saldo > 0
	and	a.ie_situacao = 'A';
	
C02 CURSOR(	nr_seq_mensalidade_pc	pls_mensalidade.nr_sequencia%type,
		nr_seq_pagador_pc	pls_contrato_pagador.nr_sequencia%type,
		ie_mensalidade_com_item_pc text) FOR
	SELECT	a.nr_sequencia nr_seq_mensalidade_seg
	from	pls_mensalidade_segurado a
	where	a.nr_seq_mensalidade	= nr_seq_mensalidade_pc
	and	ie_mensalidade_com_item_pc = 'S'
	and	exists (SELECT	1
			from	pls_mensalidade_seg_item x
			where	x.nr_seq_mensalidade_seg	= a.nr_sequencia)
	
union all

	select	a.nr_sequencia nr_seq_mensalidade_seg
	from	pls_mensalidade_segurado a,
		pls_segurado b
	where	b.nr_sequencia		= a.nr_seq_segurado
	and	a.nr_seq_mensalidade	= nr_seq_mensalidade_pc
	and	b.nr_seq_pagador	= nr_seq_pagador_pc
	and	ie_mensalidade_com_item_pc = 'N'
	order by 1; --Order by NR_SEQUENCIA necessario por causa do select para arredondamento na ultima mensalidade
C03 CURSOR(	nr_seq_lanc_mens_pc	pls_lancamento_mensalidade.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_seq_centro_apropriacao,
		vl_apropriacao,
		count(1) qt_lancamento
	from	pls_lancamento_mens_aprop
	where	nr_seq_lancamento = nr_seq_lanc_mens_pc
	group by
		nr_sequencia,
		nr_seq_centro_apropriacao,
		vl_apropriacao
	order by
		vl_apropriacao asc;

C04 CURSOR(	nr_seq_pagador_pc	pls_contrato_pagador.nr_sequencia%type,
		dt_inicio_pc		pls_mensalidade.dt_referencia%type,
		dt_fim_pc		pls_mensalidade.dt_referencia%type) FOR
	SELECT	vl_item,
		ie_tipo_item,
		nr_sequencia nr_seq_segurado_mens,
		nr_seq_motivo
	from	pls_segurado_mensalidade
	where	nr_seq_pagador = nr_seq_pagador_pc
	and	coalesce(nr_seq_segurado::text, '') = ''
	and	coalesce(nr_seq_item_mensalidade::text, '') = ''
	and	dt_referencia between dt_inicio_pc and dt_fim_pc
	and	ie_situacao = 'A';
	
procedure realizar_arredondamento(	ie_tipo_operacacao_p	text) is
;
BEGIN

if (ie_diferenca_w = 'S') then
	if (ie_tipo_operacacao_p = 'S') then
		vl_diferenca_rateio_w	:= vl_diferenca_rateio_w - 0.01;
	elsif (ie_tipo_operacacao_p = 'D') then
		vl_diferenca_rateio_w	:= vl_diferenca_rateio_w + 0.01;
	end if;
	
	vl_item_w	:= vl_rateio_ww;
elsif (ie_diferenca_w = 'N') then
	if (ie_tipo_operacacao_p = 'S') then
		vl_diferenca_rateio_w	:= vl_diferenca_rateio_w + 0.01;
	elsif (ie_tipo_operacacao_p = 'D') then
		vl_diferenca_rateio_w	:= vl_diferenca_rateio_w - 0.01;
	end if;

	vl_item_w	:= vl_rateio_ww;
end if;

end;
	
procedure obter_tipo_diferenca_rateio(	ie_tipo_operacacao_p	varchar2,
					vl_diferencao_p		number) is
begin

if (ie_tipo_operacacao_p = 'S') then
	if (vl_diferencao_p < 0) then
		ie_diferenca_w	:= 'N';
		vl_rateio_ww	:= vl_rateio_w - 0.01;
	elsif (vl_diferencao_p > 0) then
		ie_diferenca_w	:= 'S';
		vl_rateio_ww	:= vl_rateio_w + 0.01;
	else
		ie_diferenca_w := 'X';
	end if;
elsif (ie_tipo_operacacao_p = 'D') then
	if (vl_diferencao_p < 0) then
		ie_diferenca_w	:= 'S';
		vl_rateio_ww	:= vl_rateio_w - 0.01;
	elsif (vl_diferencao_p > 0) then
		ie_diferenca_w	:= 'N';
		vl_rateio_ww	:= vl_rateio_w + 0.01;
	else
		ie_diferenca_w := 'X';
	end if;
end if;

end;
	
begin
dt_referencia_inicio_w	:= trunc(dt_referencia_p,'month');
dt_referencia_fim_w	:= fim_dia(last_day(dt_referencia_p));

for r_c01_w in C01(nr_seq_pagador_p, dt_referencia_inicio_w, dt_referencia_fim_w) loop
	begin
	
	if (pls_mens_itens_pck.obter_se_item_grupo(r_c01_w.ie_tipo_item, r_c01_w.nr_seq_motivo) = 'S') and (pls_mens_itens_pck.obter_se_gera_item_suspensao(r_c01_w.ie_tipo_item, nr_seq_motivo_susp_p) = 'S') then
		tb_nr_seq_item_mens_w.delete;
		tb_vl_item_w.delete;
		nr_indice_w	:= 0;
		
		if (r_c01_w.ie_operacao_motivo = 'D') and (r_c01_w.vl_lancamento > 0) then
			vl_lancamento_w	:= r_c01_w.vl_lancamento*-1;
		else
			vl_lancamento_w	:= r_c01_w.vl_lancamento;
		end if;
		
		select	coalesce(sum(a.vl_item),0)
		into STRICT	vl_mensalidade_w
		from	pls_mensalidade_seg_item	a,
			pls_mensalidade_segurado	b,
			pls_mensalidade			c
		where	a.nr_seq_mensalidade_seg	= b.nr_sequencia
		and	b.nr_seq_mensalidade		= c.nr_sequencia
		and	c.nr_sequencia			= nr_seq_mensalidade_p;
		
		if (vl_lancamento_w = 0) then
			CALL pls_gerar_mens_log_erro(nr_seq_lote_p, nr_seq_pagador_p, null, nr_seq_mensalidade_p,
						wheb_mensagem_pck.get_texto(1119351,'NR_SEQ_LANCAMENTO='||r_c01_w.nr_sequencia),
						wheb_usuario_pck.get_cd_estabelecimento, nm_usuario_p);
		elsif	(r_c01_w.ie_operacao_motivo = 'D' and vl_mensalidade_w < (vl_lancamento_w*-1)) then
			CALL pls_gerar_mens_log_erro(nr_seq_lote_p, nr_seq_pagador_p, null, nr_seq_mensalidade_p,
						wheb_mensagem_pck.get_texto(1119352,'NR_SEQ_LANCAMENTO='||r_c01_w.nr_sequencia||';VL_LANCAMENTO='||campo_mascara_virgula(vl_lancamento_w)),
						wheb_usuario_pck.get_cd_estabelecimento, nm_usuario_p);
		else
			--Primeiro verificar se existem beneficiarios com itens gerados
			ie_mensalidade_com_item_w	:= 'S';
			select	count(1),
				max(a.nr_sequencia)
			into STRICT	qt_mens_benef_w,
				nr_seq_mens_arredondamento_w
			from	pls_mensalidade_segurado a
			where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
			and	exists (SELECT	1
					from	pls_mensalidade_seg_item x
					where	x.nr_seq_mensalidade_seg	= a.nr_sequencia);
			
			--Se nao existir, o rateio sera entre todos os beneficiarios
			if (qt_mens_benef_w = 0) then
				ie_mensalidade_com_item_w	:= 'N';
				select	count(1),
					max(a.nr_sequencia)
				into STRICT	qt_mens_benef_w,
					nr_seq_mens_arredondamento_w
				from	pls_mensalidade_segurado a,
					pls_segurado b
				where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
				and	b.nr_seq_pagador	= nr_seq_pagador_p
				and	b.nr_sequencia		= a.nr_seq_segurado;
			end if;
		
			vl_rateio_w	:= dividir(vl_lancamento_w,qt_mens_benef_w);

			vl_diferenca_rateio_w	:= vl_lancamento_w - (vl_rateio_w * qt_mens_benef_w);

			obter_tipo_diferenca_rateio(r_c01_w.ie_operacao_motivo, vl_diferenca_rateio_w);

			for r_c02_w in C02(	nr_seq_mensalidade_p,
						nr_seq_pagador_p,
						ie_mensalidade_com_item_w) loop
				begin				
				if (vl_diferenca_rateio_w <> 0) then
					realizar_arredondamento(r_c01_w.ie_operacao_motivo);
				else
					vl_item_w	:= vl_rateio_w;
				end if;
				
				--Tratamento para gerar a apropriacao do item
				select	count(1),
					max(nr_sequencia)
				into STRICT	qt_apropriacao_w,
					nr_seq_aprop_arredondamento_w
				from	pls_lancamento_mens_aprop
				where	nr_seq_lancamento = r_c01_w.nr_sequencia;

				if (qt_apropriacao_w > 0) then
					ie_valor_apropriado_w	:= 'S';
				else
					ie_valor_apropriado_w	:= 'N';
				end if;
				
				insert	into	pls_mensalidade_seg_item(	nr_sequencia, nr_seq_mensalidade_seg, nr_seq_mensalidade,
						dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
						ie_tipo_item, nr_seq_tipo_lanc, vl_item,
						ie_tipo_mensalidade, nr_seq_lancamento_mens, cd_centro_custo,
						ie_valor_apropriado)
				values (	nextval('pls_mensalidade_seg_item_seq'), r_c02_w.nr_seq_mensalidade_seg, nr_seq_mensalidade_p,
						clock_timestamp(), clock_timestamp(), nm_usuario_p, nm_usuario_p,
						r_c01_w.ie_tipo_item, r_c01_w.nr_seq_motivo, vl_item_w,
						'P', r_c01_w.nr_sequencia, r_c01_w.cd_centro_custo,
						ie_valor_apropriado_w)
					returning nr_sequencia into nr_seq_item_mensalidade_w;

				if (ie_valor_apropriado_w = 'S') then
					tb_nr_seq_item_mens_w(nr_indice_w)	:= nr_seq_item_mensalidade_w;
					tb_vl_item_w(nr_indice_w)		:= vl_item_w;
					nr_indice_w				:= nr_indice_w + 1;
				end if;
				end;
			end loop;--C02
			
			if (tb_nr_seq_item_mens_w.count > 0) then
				qt_contador_aprop_w	:= 1;
			
				for r_c03_w in c03(r_c01_w.nr_sequencia) loop
					begin
					if (r_c01_w.ie_operacao_motivo = 'D') and (r_c03_w.vl_apropriacao > 0) then
						vl_apropriacao_w	:= r_c03_w.vl_apropriacao * -1;
					else
						vl_apropriacao_w	:= r_c03_w.vl_apropriacao;
					end if;
					
					vl_rateio_w			:= dividir(vl_apropriacao_w,qt_mens_benef_w);
					vl_diferenca_rateio_w		:= vl_apropriacao_w - (vl_rateio_w * qt_mens_benef_w);
		
					obter_tipo_diferenca_rateio(r_c01_w.ie_operacao_motivo, vl_diferenca_rateio_w);
					
					for i in tb_nr_seq_item_mens_w.first..tb_nr_seq_item_mens_w.last loop
						begin
						if (qt_contador_aprop_w = qt_apropriacao_w) then
							select	coalesce(sum(vl_apropriacao), 0)
							into STRICT	vl_total_aprop_item_w
							from	pls_mens_seg_item_aprop
							where	nr_seq_item = tb_nr_seq_item_mens_w(i);
						
							if	((vl_total_aprop_item_w + vl_rateio_w) <> tb_vl_item_w(i)) then
								vl_rateio_w	:= vl_rateio_w + (tb_vl_item_w(i) - (vl_total_aprop_item_w + vl_rateio_w));
							end if;
							
							vl_item_w	:= vl_rateio_w;
						else
							if (vl_diferenca_rateio_w <> 0) then
								realizar_arredondamento(r_c01_w.ie_operacao_motivo);
							else
								vl_item_w	:= vl_rateio_w;
							end if;						
						end if;
		
						insert	into	pls_mens_seg_item_aprop(	nr_sequencia, nr_seq_item, nr_seq_centro_apropriacao, vl_apropriacao,
								dt_atualizacao, nm_usuario, dt_atualizacao_nrec)
							values (	nextval('pls_mens_seg_item_aprop_seq'), tb_nr_seq_item_mens_w(i), r_c03_w.nr_seq_centro_apropriacao, vl_item_w,
								clock_timestamp(), nm_usuario_p, clock_timestamp());			
						end;
					end loop;
					
					qt_contador_aprop_w	:= qt_contador_aprop_w + 1;
					end;
				end loop;
			end if;	
		end if;
	end if;
	end;
end loop;--C01
for r_c04_w in c04(nr_seq_pagador_p, dt_referencia_inicio_w, dt_referencia_fim_w)loop
	begin
	
	if (pls_mens_itens_pck.obter_se_item_grupo(r_c04_w.ie_tipo_item,r_c04_w.nr_seq_motivo) = 'S') and (pls_mens_itens_pck.obter_se_gera_item_suspensao(r_c04_w.ie_tipo_item, nr_seq_motivo_susp_p) = 'S') then
		--Primeiro verificar se existem beneficiarios com itens gerados
		ie_mensalidade_com_item_w	:= 'S';
		select	count(1),
			max(a.nr_sequencia)
		into STRICT	qt_mens_benef_w,
			nr_seq_mens_arredondamento_w
		from	pls_mensalidade_segurado a
		where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
		and	exists (SELECT	1
				from	pls_mensalidade_seg_item x
				where	x.nr_seq_mensalidade_seg	= a.nr_sequencia);
		
		--Se nao existir, o rateio sera entre todos os beneficiarios
		if (qt_mens_benef_w = 0) then
			ie_mensalidade_com_item_w	:= 'N';
			select	count(1),
				max(a.nr_sequencia)
			into STRICT	qt_mens_benef_w,
				nr_seq_mens_arredondamento_w
			from	pls_mensalidade_segurado a,
				pls_segurado b
			where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
			and	b.nr_seq_pagador	= nr_seq_pagador_p
			and	b.nr_sequencia		= a.nr_seq_segurado;
		end if;
		
		vl_rateio_w	:= dividir(r_c04_w.vl_item, qt_mens_benef_w);

		for r_c02_w in c02(	nr_seq_mensalidade_p,
					nr_seq_pagador_p,
					ie_mensalidade_com_item_w) loop
			begin
			
			if (r_c02_w.nr_seq_mensalidade_seg = nr_seq_mens_arredondamento_w) then
				vl_item_w	:= vl_rateio_w + (r_c04_w.vl_item - (vl_rateio_w * qt_mens_benef_w));
			else
				vl_item_w	:= vl_rateio_w;
			end if;
			
			if (vl_item_w <> 0) then
				insert	into	pls_mensalidade_seg_item(	nr_sequencia, nr_seq_mensalidade_seg, nr_seq_mensalidade,
						dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
						ie_tipo_item, nr_seq_tipo_lanc, vl_item,
						ie_tipo_mensalidade, nr_seq_segurado_mens)
				values (	nextval('pls_mensalidade_seg_item_seq'), r_c02_w.nr_seq_mensalidade_seg, nr_seq_mensalidade_p,
						clock_timestamp(), clock_timestamp(), nm_usuario_p, nm_usuario_p,
						r_c04_w.ie_tipo_item, r_c04_w.nr_seq_motivo, vl_item_w,
						'P', r_c04_w.nr_seq_segurado_mens)
					returning nr_sequencia into nr_seq_item_mensalidade_w;

				update	pls_segurado_mensalidade
				set	ie_situacao		= 'I',
					nr_seq_item_mensalidade	= nr_seq_item_mensalidade_w
				where	nr_sequencia		= r_c04_w.nr_seq_segurado_mens;
			end if;
			end;
		end loop;
	end if;
	
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_item_lanc_prog_pag ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, dt_referencia_p pls_mensalidade.dt_referencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_motivo_susp_p pls_motivo_susp_cobr_mens.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
