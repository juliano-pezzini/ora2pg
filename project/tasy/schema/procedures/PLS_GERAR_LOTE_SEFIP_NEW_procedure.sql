-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_sefip_new ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, cd_darf_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
dt_inicial_w			timestamp;
dt_final_w			timestamp;
nr_seq_lote_w			bigint;
nr_seq_pag_prestador_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_tomador_w		bigint;
nr_seq_trib_w			bigint;
pr_tributo_w			double precision;
nr_seq_conta_w			bigint;
nr_seq_resumo_w			bigint;
ie_competencia_w		varchar(255);
cd_cbo_saude_w			varchar(255);
dt_lote_w			timestamp;
ie_tipo_contratacao_w		varchar(255);
cd_cgc_estipulante_w		varchar(255);
cd_pf_estipulante_w		varchar(255);
cd_cgc_outorgante_w		varchar(255);
vl_liberado_w			double precision;
vl_descontado_w			double precision;
cd_tributo_w			tributo.cd_tributo%type;
vl_total_desconto_w		double precision;
vl_total_prod_w			double precision;	
ie_valor_base_trib_nf_w		varchar(1);	
vl_remuneracao_w		double precision;
vl_imposto_w			double precision;
vl_descontado_ww		double precision;
cd_tributo_ant_w		tributo.cd_tributo%type;
vl_item_pr_w			double precision;
vl_tributo_real_w		double precision;
vl_item_prod_w			double precision;
vl_item_desc_w			double precision;
nr_seq_grupo_prestador_w	bigint;
nr_seq_prestador_pgto_w		bigint;
ie_gera_w			varchar(1);
vl_trib_retido_w		double precision;
nr_seq_tomador_movto_w		bigint;

nr_seq_conta_ww			bigint;
nr_seq_resumo_ww		bigint;
vl_liberado_ww			double precision;
cd_cgc_estipulante_ww		varchar(255);
vl_item_w			double precision;
vl_total_w			double precision;
nr_seq_movto_cta_w		bigint;
vl_descontar_w			double precision;

c_lotes CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_lote_pagamento 
	where	cd_estabelecimento	= cd_estabelecimento_p 
	and	dt_mes_competencia between dt_inicial_w and dt_final_w 
	and	ie_status		= 'D';

c_prestadores CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_seq_prestador 
	from	pls_prestador		b, 
		pls_pagamento_prestador	a 
	where	a.nr_seq_prestador	= b.nr_sequencia 
	and	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '') 
	and	a.nr_seq_lote		= nr_seq_lote_w 
	and	coalesce(a.ie_cancelamento::text, '') = '' 
	and	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '');
	--and	pls_obter_se_cooperado_ativo(b.cd_pessoa_fisica, dt_final_w, '') = 'S'; 
	/*and	exists	(select	1							-- gerar somente prestadores cooperados 
			from	pls_cooperado x 
			where	x.cd_pessoa_fisica	= b.cd_pessoa_fisica);*/
 
c_tributos CURSOR FOR 
	SELECT	nr_sequencia, 
		pr_tributo, 
		ie_tipo_contratacao, 
		cd_tributo, 
		vl_imposto, 
		vl_base_calculo 
	from	(SELECT	a.nr_sequencia, 
			CASE WHEN a.vl_imposto=0 THEN  0  ELSE a.pr_tributo END  pr_tributo, 
			a.ie_tipo_contratacao, 
			b.cd_tributo, 
			CASE WHEN a.ie_pago_prev='R' THEN  -1  ELSE a.vl_imposto END  vl_imposto, 
			CASE WHEN coalesce(a.ie_tipo_contratacao::text, '') = '' THEN  2  ELSE 1 END  ie_tipo_contr_order, 
			a.vl_base_calculo 
		from	tributo				b, 
			pls_pag_prest_venc_trib		a, 
			pls_pag_prest_vencimento	x 
		where	a.cd_tributo		= b.cd_tributo 
		and	b.ie_tipo_tributo	= 'INSS' 
		and	x.nr_sequencia		= a.nr_seq_vencimento 
		/*and	a.nr_seq_vencimento in	(select	x.nr_sequencia 
						from	pls_pag_prest_vencimento	x 
						where	x.nr_seq_pag_prestador	= nr_seq_pag_prestador_w)*/
 
		and	x.nr_seq_pag_prestador	= nr_seq_pag_prestador_w 
		and	a.ie_pago_prev	= 'V' 
		and	((a.cd_darf	= coalesce(cd_darf_p, a.cd_darf)) or 
			((coalesce(cd_darf_p::text, '') = '') and (coalesce(a.cd_darf::text, '') = '')))) alias9 
	order by 
		ie_tipo_contr_order, -- Gerar primeiramente os tributos que possuem tipo de contratação, depois os que não tem 
		cd_tributo;	
				-- Quando o cursor chegar nos tributos sem tipo de contratação, todos os itens restantes da conta entrarão no sefip 
 
c_producao CURSOR FOR 
	SELECT	a.vl_liberado, 
		a.nr_seq_conta, 
		a.nr_sequencia, 
		coalesce(c.cd_cgc_estipulante, cd_cgc_outorgante_w), 
		c.cd_pf_estipulante 
	from	pls_pagamento_item	e, 
		pls_pagamento_prestador	d, 
		pls_contrato		c, 
		pls_segurado		b, 
		pls_conta_medica_resumo	a 
	where	a.nr_seq_lote_pgto	= nr_seq_lote_w 
	and	a.nr_seq_prestador_pgto	= nr_seq_prestador_w 
	and	a.nr_seq_segurado	= b.nr_sequencia 
	and	b.nr_seq_contrato	= c.nr_sequencia 
	and	d.nr_sequencia		= e.nr_seq_pagamento 
	and	e.nr_sequencia		= a.nr_seq_pag_item 
	and	exists(	SELECT	1 
			from	pls_evento_tributo	f 
			where	e.nr_seq_evento		= f.nr_seq_evento 
			and	((pls_obter_se_prestador_grupo(f.nr_seq_grupo_prestador,d.nr_seq_prestador) = 'S') or (coalesce(f.nr_seq_grupo_prestador::text, '') = '')) 
			and	((d.nr_seq_prestador = f.nr_seq_prestador) or (coalesce(f.nr_seq_prestador::text, '') = '')) 
			and	((f.nr_seq_tipo_prestador =	(select	max(x.nr_seq_tipo_prestador) 
								from	pls_prestador	x 
								where	x.nr_sequencia	= d.nr_seq_prestador)) or (coalesce(f.nr_seq_tipo_prestador::text, '') = '') 
			and	((f.nr_seq_classificacao = 	(select	max(x.nr_seq_classificacao) 
								from	pls_prestador	x 
								where	x.nr_sequencia	= d.nr_seq_prestador)) or (coalesce(f.nr_seq_classificacao::text, '') = ''))) 
) 
	and	((coalesce(a.ie_situacao::text, '') = '') or (a.ie_situacao <> 'I')) 
	and	not exists (select	1						-- Não ler as contas que já geraram movimento neste lote 
				from	sefip_tomador_movto_conta x 
				where	x.nr_seq_conta	= a.nr_seq_conta 
				and	x.nr_seq_resumo	= a.nr_sequencia 
				and	x.nr_seq_lote	= nr_seq_lote_p) 
	and	((coalesce(a.ie_tipo_contratacao, 'S')		= ie_tipo_contratacao_w) 
	or (coalesce(ie_tipo_contratacao_w,'X') = 'X')) 
	
union all
 
	select	a.vl_liberado, 
		a.nr_seq_conta, 
		a.nr_sequencia, 
		coalesce(c.cd_cgc, cd_cgc_outorgante_w), 
		c.cd_pessoa_fisica 
	from	pls_pagamento_item	e, 
		pls_pagamento_prestador	d, 
		pls_intercambio		c, 
		pls_segurado		b, 
		pls_conta_medica_resumo	a 
	where	a.nr_seq_lote_pgto		= nr_seq_lote_w 
	and	a.nr_seq_prestador_pgto		= nr_seq_prestador_w 
	and	a.nr_seq_segurado		= b.nr_sequencia 
	and	b.nr_seq_intercambio		= c.nr_sequencia 
	and	d.nr_sequencia		= e.nr_seq_pagamento 
	and	e.nr_sequencia		= a.nr_seq_pag_item 
	and	exists(	select	1 
			from	pls_evento_tributo	f 
			where	e.nr_seq_evento		= f.nr_seq_evento 
			and	((pls_obter_se_prestador_grupo(f.nr_seq_grupo_prestador,d.nr_seq_prestador) = 'S') or (coalesce(f.nr_seq_grupo_prestador::text, '') = '')) 
			and	((d.nr_seq_prestador = f.nr_seq_prestador) or (coalesce(f.nr_seq_prestador::text, '') = '')) 
			and	((f.nr_seq_tipo_prestador =	(select	max(x.nr_seq_tipo_prestador) 
								from	pls_prestador	x 
								where	x.nr_sequencia	= d.nr_seq_prestador)) or (coalesce(f.nr_seq_tipo_prestador::text, '') = '')) 
			and	((f.nr_seq_classificacao = 	(select	max(x.nr_seq_classificacao) 
								from	pls_prestador	x 
								where	x.nr_sequencia	= d.nr_seq_prestador)) or (coalesce(f.nr_seq_classificacao::text, '') = ''))) 
	and	coalesce(a.ie_tipo_contratacao, 'S')		= ie_tipo_contratacao_w 
	and	not exists (select	1						-- Não ler as contas que já geraram movimento neste lote 
				from	sefip_tomador_movto_conta x 
				where	x.nr_seq_conta	= a.nr_seq_conta 
				and	x.nr_seq_resumo	= a.nr_sequencia 
				and	x.nr_seq_lote	= nr_seq_lote_p) 
	and	((coalesce(a.ie_situacao::text, '') = '') or (a.ie_situacao <> 'I')) 
	
union all
 
	select	a.vl_liberado, 
		a.nr_seq_conta, 
		a.nr_sequencia, 
		cd_cgc_outorgante_w, 
		null cd_pessoa_fisica 
	from	pls_pagamento_item	e, 
		pls_pagamento_prestador	d, 
		pls_segurado		b, 
		pls_conta_medica_resumo	a 
	where	a.nr_seq_lote_pgto		= nr_seq_lote_w 
	and	a.nr_seq_prestador_pgto		= nr_seq_prestador_w 
	and	a.nr_seq_segurado		= b.nr_sequencia 
	and	coalesce(b.nr_seq_intercambio::text, '') = '' 
	and	coalesce(b.nr_seq_contrato::text, '') = '' 
	and	d.nr_sequencia		= e.nr_seq_pagamento 
	and	e.nr_sequencia		= a.nr_seq_pag_item 
	and	exists(	select	1 
			from	pls_evento_tributo	f 
			where	e.nr_seq_evento		= f.nr_seq_evento 
			and	((pls_obter_se_prestador_grupo(f.nr_seq_grupo_prestador,d.nr_seq_prestador) = 'S') or (coalesce(f.nr_seq_grupo_prestador::text, '') = '')) 
			and	((d.nr_seq_prestador = f.nr_seq_prestador) or (coalesce(f.nr_seq_prestador::text, '') = '')) 
			and	((f.nr_seq_tipo_prestador =	(select	max(x.nr_seq_tipo_prestador) 
								from	pls_prestador	x 
								where	x.nr_sequencia	= d.nr_seq_prestador)) or (coalesce(f.nr_seq_tipo_prestador::text, '') = '')) 
			and	((f.nr_seq_classificacao = 	(select	max(x.nr_seq_classificacao) 
								from	pls_prestador	x 
								where	x.nr_sequencia	= d.nr_seq_prestador)) or (coalesce(f.nr_seq_classificacao::text, '') = ''))) 
	and	((coalesce(a.ie_tipo_contratacao, 'S')		= ie_tipo_contratacao_w) 
	or (coalesce(ie_tipo_contratacao_w,'X') = 'X')) 
	and	not exists (select	1						-- Não ler as contas que já geraram movimento neste lote 
				from	sefip_tomador_movto_conta x 
				where	x.nr_seq_conta	= a.nr_seq_conta 
				and	x.nr_seq_resumo	= a.nr_sequencia 
				and	x.nr_seq_lote	= nr_seq_lote_p) 
	and	((coalesce(a.ie_situacao::text, '') = '') or (a.ie_situacao <> 'I')) 
	
union all
 
	select	coalesce(sum(a.vl_item),0), 
		null nr_seq_conta, 
		null nr_sequencia, 
		cd_cgc_outorgante_w, 
		null cd_pessoa_fisica 
	from	tributo			t, 
		pls_evento		d, 
		pls_evento_tributo	c, 
		pls_pagamento_item	a, 
		pls_pagamento_prestador	b 
	where	a.nr_seq_evento		= c.nr_seq_evento 
	and	a.nr_seq_pagamento	= b.nr_sequencia 
	and	a.nr_seq_evento		= d.nr_sequencia 
	and	t.cd_tributo		= c.cd_tributo 
	and	t.ie_tipo_tributo	= 'INSS' 
	and	d.ie_tipo_evento	= 'F' 
	and	b.nr_seq_lote		= nr_seq_lote_w 
	and	b.nr_seq_prestador	= nr_seq_prestador_w 
	and	coalesce(a.ie_apropriar_total, 'N')	= 'N' 
	and	((pls_obter_se_prestador_grupo(c.nr_seq_grupo_prestador,b.nr_seq_prestador) = 'S') or (coalesce(c.nr_seq_grupo_prestador::text, '') = '')) 
	and	((b.nr_seq_prestador = c.nr_seq_prestador) or (coalesce(c.nr_seq_prestador::text, '') = '')) 
	and	((c.nr_seq_tipo_prestador =	(select	max(x.nr_seq_tipo_prestador) 
						from	pls_prestador	x 
						where	x.nr_sequencia	= b.nr_seq_prestador)) or (coalesce(c.nr_seq_tipo_prestador::text, '') = '')) 
	and	((c.nr_seq_classificacao = 	(select	max(x.nr_seq_classificacao) 
						from	pls_prestador	x 
						where	x.nr_sequencia	= b.nr_seq_prestador)) or (coalesce(c.nr_seq_classificacao::text, '') = '')) 
	and	coalesce(ie_tipo_contratacao_w::text, '') = '';

c_tomador CURSOR FOR 							-- Obter as contas que geraram movimentação para gerar o tomador 
	SELECT	cd_cgc_estipulante, 
		sum(vl_liberado) 
	from	sefip_tomador_movto_conta 
	where	nr_seq_lote	= nr_seq_lote_p 
	group	by cd_cgc_estipulante;
	
c_movimentos CURSOR FOR 
	SELECT	cd_cgc_estipulante, 
		nr_seq_prestador, 
		sum(vl_liberado) 
	from	sefip_tomador_movto_conta 
	where	nr_seq_lote		= nr_seq_lote_p 
	and	coalesce(nr_seq_movto::text, '') = '' 
	and	vl_liberado	> 0 
	group	by cd_cgc_estipulante, nr_seq_prestador;

c_arredondamento CURSOR FOR 
	SELECT	nr_seq_prestador, 
		cd_cgc_estipulante, 
		sum(vl_liberado), 
		sum(vl_descontado) 
	from	sefip_tomador_movto_conta 
	where	nr_seq_lote		= nr_seq_lote_p 
	group	by nr_seq_prestador, cd_cgc_estipulante;


BEGIN 
select	ie_competencia, 
	dt_lote 
into STRICT	ie_competencia_w, 
	dt_lote_w 
from	sefip_lote 
where	nr_sequencia	= nr_seq_lote_p;
 
if (ie_competencia_w = '13') then 
	dt_inicial_w	:= trunc(to_date('01/12/' || to_char(dt_lote_w,'yyyy'),'dd/mm/yyyy'),'dd');
	dt_final_w	:= fim_dia(last_day(to_date('01/12/' || to_char(dt_lote_w,'yyyy'),'dd/mm/yyyy')));
elsif (ie_competencia_w <> '13') then	 
	dt_inicial_w	:= trunc(to_date('01/' || lpad(ie_competencia_w,2,'0') || '/' || to_char(dt_lote_w,'yyyy'),'dd/mm/yyyy'), 'dd');
	dt_final_w	:= fim_dia(last_day(to_date('01/' || lpad(ie_competencia_w,2,'0') || '/' || to_char(dt_lote_w,'yyyy'),'dd/mm/yyyy')));
end if;
 
select	max(a.cd_cgc_outorgante) 
into STRICT	cd_cgc_outorgante_w 
from	pls_outorgante	a 
where	a.cd_estabelecimento	= cd_estabelecimento_p;
 
open c_lotes;
loop 
fetch c_lotes into 
	nr_seq_lote_w;
EXIT WHEN NOT FOUND; /* apply on c_lotes */
	begin 
	open c_prestadores;
	loop 
	fetch c_prestadores into 
		nr_seq_pag_prestador_w, 
		nr_seq_prestador_w;
	EXIT WHEN NOT FOUND; /* apply on c_prestadores */
		begin 
		cd_tributo_ant_w	:= null;
		vl_trib_retido_w	:= 0;
		vl_total_w		:= 0;
		 
		open c_tributos;
		loop 
		fetch c_tributos into 
			nr_seq_trib_w, 
			pr_tributo_w, 
			ie_tipo_contratacao_w, 
			cd_tributo_w, 
			vl_imposto_w, 
			vl_trib_retido_w;
		EXIT WHEN NOT FOUND; /* apply on c_tributos */
			begin 
			vl_descontado_ww	:= 0;
						 
			open c_producao;
			loop 
			fetch c_producao into 
				vl_remuneracao_w, 
				nr_seq_conta_w, 
				nr_seq_resumo_w, 
				cd_cgc_estipulante_w, 
				cd_pf_estipulante_w;
			EXIT WHEN NOT FOUND; /* apply on c_producao */
				begin		 
												 
				/* Cerifica quanto o item representa do total de produção gerado para o prestador */
 
				/*vl_item_pr_w	:= dividir_sem_round(vl_remuneracao_w, vl_trib_retido_w); 
				 
				if	(vl_item_pr_w > 1) then 
					vl_item_pr_w	:= 1; 
				end if; 
				 
				vl_liberado_w	:= vl_trib_retido_w * vl_item_pr_w; 
				*/
 
				 
				begin 
				cd_cbo_saude_w	:= pls_obter_dados_conta(nr_seq_conta_w, 'CBO');
				exception 
				when others then 
					cd_cbo_saude_w	:= null;
				end;
 
				--vl_descontado_w	:= dividir_sem_round(vl_liberado_w * pr_tributo_w,100); 
				 
				vl_descontado_w := dividir_sem_round((vl_remuneracao_w * pr_tributo_w)::numeric,100);
				 
				if	((vl_descontado_ww + vl_descontado_w) >= vl_imposto_w) then 
					vl_descontado_w	:= vl_imposto_w - vl_descontado_ww;
					 
					if (vl_descontado_w < 0) and (vl_imposto_w > 0) then 
						vl_descontado_w	:= 0;
					end if;
				end if;
				 
				if (vl_descontado_w <> 0) then 
					CALL pls_gerar_sefip_tomador_movto(	nr_seq_lote_p, 
									nr_seq_prestador_w, 
									nm_usuario_p, 
									vl_remuneracao_w, 
									0, 
									vl_descontado_w, 
									0, 
									0, 
									cd_cbo_saude_w, 
									nr_seq_conta_w, 
									nr_seq_resumo_w, 
									cd_cgc_estipulante_w, 
									cd_pf_estipulante_w, 
									nr_seq_lote_w);
				end if;
	 
				vl_descontado_ww	:= vl_descontado_ww + vl_descontado_w;
				end;
			end loop;
			close c_producao;
			 
			if (ie_tipo_contratacao_w IS NOT NULL AND ie_tipo_contratacao_w::text <> '') and (vl_descontado_ww <> vl_imposto_w) then 
				select	max(a.nr_sequencia) 
				into STRICT	nr_seq_movto_cta_w 
				from	sefip_tomador_movto_conta	a 
				where	a.nr_seq_lote		= nr_seq_lote_p 
				and	a.nr_seq_prestador	= nr_seq_prestador_w 
				and	a.cd_cgc_estipulante	= cd_cgc_estipulante_w;
				 
				if (nr_seq_movto_cta_w IS NOT NULL AND nr_seq_movto_cta_w::text <> '') then 
					update	sefip_tomador_movto_conta 
					set	vl_descontado	= vl_descontado + (vl_imposto_w - vl_descontado_ww) 
					where	nr_sequencia	= nr_seq_movto_cta_w;
				else 
					select	max(a.nr_sequencia) 
					into STRICT	nr_seq_movto_cta_w 
					from	sefip_tomador_movto_conta	a 
					where	a.nr_seq_lote		= nr_seq_lote_p 
					and	a.nr_seq_prestador	= nr_seq_prestador_w;
					 
					update	sefip_tomador_movto_conta 
					set	vl_descontado	= vl_descontado + (vl_imposto_w - vl_descontado_ww) 
					where	nr_sequencia	= nr_seq_movto_cta_w;
				end if;
			end if;
			 
			cd_tributo_ant_w	:= cd_tributo_w;
			end;
		end loop;
		close c_tributos;
		 
		-- Inserir as contas que não entraram no lote SEFIP, apenas para fins de conferência 
		insert into sefip_tomador_movto_conta(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_movto, 
			nr_seq_conta, 
			nr_seq_resumo, 
			vl_descontado, 
			vl_liberado, 
			nr_seq_lote, 
			nr_seq_lote_pgto, 
			nr_seq_prestador, 
			cd_cgc_estipulante, 
			cd_pf_estipulante) 
		SELECT	nextval('sefip_tomador_movto_conta_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			null, 
			a.nr_seq_conta, 
			a.nr_sequencia, 
			0, 
			a.vl_liberado, 
			nr_seq_lote_p, 
			nr_seq_lote_w, 
			a.nr_seq_prestador_pgto, 
			coalesce(c.cd_cgc_estipulante, cd_cgc_outorgante_w), 
			c.cd_pf_estipulante 
		from	pls_contrato c, 
			pls_segurado b, 
			pls_conta_medica_resumo a 
		where	a.nr_seq_lote_pgto	= nr_seq_lote_w 
		and	a.nr_seq_segurado	= b.nr_sequencia 
		and	b.nr_seq_contrato	= c.nr_sequencia 
		and	a.nr_seq_prestador_pgto	= nr_seq_prestador_w 
		and	vl_liberado		> 0 
		and	((coalesce(a.ie_situacao::text, '') = '') or (a.ie_situacao <> 'I')) 
		and	not exists (SELECT	1 
					from	sefip_tomador_movto_conta x 
					where	x.nr_seq_conta	= a.nr_seq_conta 
					and	x.nr_seq_resumo	= a.nr_sequencia 
					and	x.nr_seq_lote	= nr_seq_lote_p);
					 
		insert into sefip_tomador_movto_conta(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_movto, 
			nr_seq_conta, 
			nr_seq_resumo, 
			vl_descontado, 
			vl_liberado, 
			nr_seq_lote, 
			nr_seq_lote_pgto, 
			nr_seq_prestador, 
			cd_cgc_estipulante, 
			cd_pf_estipulante) 
		SELECT	nextval('sefip_tomador_movto_conta_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			null, 
			a.nr_seq_conta, 
			a.nr_sequencia, 
			0, 
			a.vl_liberado, 
			nr_seq_lote_p, 
			nr_seq_lote_w, 
			a.nr_seq_prestador_pgto, 
			coalesce(c.cd_cgc, cd_cgc_outorgante_w), 
			null 
		from	pls_intercambio c, 
			pls_segurado b, 
			pls_conta_medica_resumo a 
		where	a.nr_seq_lote_pgto	= nr_seq_lote_w 
		and	a.nr_seq_segurado	= b.nr_sequencia 
		and	b.nr_seq_intercambio	= c.nr_sequencia 
		and	a.nr_seq_prestador_pgto	= nr_seq_prestador_w 
		and	vl_liberado		> 0 
		and	((coalesce(a.ie_situacao::text, '') = '') or (a.ie_situacao <> 'I')) 
		and	not exists (SELECT	1 
					from	sefip_tomador_movto_conta x 
					where	x.nr_seq_conta	= a.nr_seq_conta 
					and	x.nr_seq_resumo	= a.nr_sequencia 
					and	x.nr_seq_lote	= nr_seq_lote_p);
					 
		end;
	end loop;
	close c_prestadores;
	commit;
	end;
end loop;
close c_lotes;
 
open c_movimentos;
loop 
fetch c_movimentos into	 
	cd_cgc_estipulante_ww, 
	nr_seq_prestador_w, 
	vl_liberado_ww;
EXIT WHEN NOT FOUND; /* apply on c_movimentos */
	begin 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_tomador_movto_w 
	from	sefip_tomador_movimento 
	where	nr_seq_lote		= nr_seq_lote_p 
	and	nr_seq_prestador	= nr_seq_prestador_w 
	and	cd_cgc_estipulante	= cd_cgc_estipulante_ww;
	 
	if (nr_seq_tomador_movto_w IS NOT NULL AND nr_seq_tomador_movto_w::text <> '') then 
		update	sefip_tomador_movimento 
		set	vl_remuneracao		= coalesce(vl_remuneracao, 0) + vl_liberado_ww 
		where	nr_sequencia		= nr_seq_tomador_movto_w;
	else	 
		insert into sefip_tomador_movimento(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			nr_seq_prestador, 
			vl_remuneracao, 
			vl_remuneracao_13, 
			vl_descontado, 
			vl_base_13, 
			vl_base_13_movimento, 
			nr_seq_tomador, 
			cd_cbo_saude, 
			cd_cgc_estipulante, 
			cd_pf_estipulante, 
			nr_seq_lote) 
		values (nextval('sefip_tomador_movimento_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_usuario_p, 
			clock_timestamp(), 
			nr_seq_prestador_w, 
			vl_liberado_ww, 
			0, 
			0, 
			0, 
			0, 
			null, 
			null, 
			cd_cgc_estipulante_ww, 
			null, 
			nr_seq_lote_p);
	end if;
	end;
end loop;
close c_movimentos;
 
open c_arredondamento;
loop 
fetch c_arredondamento into	 
	nr_seq_prestador_w, 
	cd_cgc_estipulante_ww, 
	vl_liberado_ww, 
	vl_descontar_w;
EXIT WHEN NOT FOUND; /* apply on c_arredondamento */
	begin 
	select	sum(a.vl_remuneracao), 
		sum(a.vl_descontado) 
	into STRICT	vl_total_w, 
		vl_total_desconto_w 
	from	sefip_tomador_movimento	a 
	where	a.nr_seq_prestador	= nr_seq_prestador_w 
	and	a.nr_seq_lote		= nr_seq_lote_p 
	and	cd_cgc_estipulante	= cd_cgc_estipulante_ww;
	 
	if (vl_total_w <> vl_liberado_ww) then 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_tomador_movto_w 
		from	sefip_tomador_movimento 
		where	nr_seq_lote		= nr_seq_lote_p 
		and	nr_seq_prestador	= nr_seq_prestador_w 
		and	cd_cgc_estipulante	= cd_cgc_estipulante_ww;
		 
		update	sefip_tomador_movimento 
		set	vl_remuneracao		= vl_liberado_ww 
		where	nr_sequencia		= nr_seq_tomador_movto_w;
	end if;
	 
	if (vl_total_desconto_w <> vl_descontar_w) then 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_tomador_movto_w 
		from	sefip_tomador_movimento 
		where	nr_seq_lote		= nr_seq_lote_p 
		and	nr_seq_prestador	= nr_seq_prestador_w 
		and	cd_cgc_estipulante	= cd_cgc_estipulante_ww;
		 
		update	sefip_tomador_movimento 
		set	vl_descontado		= vl_descontar_w 
		where	nr_sequencia		= nr_seq_tomador_movto_w;
	end if;
	end;
end loop;
close c_arredondamento;
 
open c_tomador;
loop 
fetch c_tomador into 
	cd_cgc_estipulante_w, 
	vl_liberado_w;			-- retirar o lote de pagamento 
EXIT WHEN NOT FOUND; /* apply on c_tomador */
	begin 
	select	nextval('sefip_tomador_seq') 
	into STRICT	nr_seq_tomador_w 
	;
 
	insert into sefip_tomador(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_lote, 
		cd_cgc, 
		vl_retencao, 
		vl_faturado) 
	values (nr_seq_tomador_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_lote_p, 
		cd_cgc_estipulante_w, 
		0, 
		vl_liberado_w);
 
	commit;
 
	update	sefip_tomador_movimento 
	set	nr_seq_tomador		= nr_seq_tomador_w 
	where	cd_cgc_estipulante	= cd_cgc_estipulante_w 
	and	nr_seq_lote		= nr_seq_lote_p;
 
	commit;
	 
	end;
end loop;
close c_tomador;
 
update	sefip_lote 
set	dt_geracao	= clock_timestamp(), 
	nm_usuario	= nm_usuario_p 
where	nr_sequencia	= nr_seq_lote_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_sefip_new ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, cd_darf_p text, nm_usuario_p text) FROM PUBLIC;
