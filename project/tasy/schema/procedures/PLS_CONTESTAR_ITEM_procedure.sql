-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_contestar_item ( nr_seq_lote_p pls_lote_contestacao.nr_sequencia%type, nr_seq_fatura_p pls_conta.nr_seq_fatura%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_fatura_proc_p pls_fatura_proc.nr_sequencia%type, nr_seq_fatura_mat_p pls_fatura_mat.nr_sequencia%type, qt_glosada_p pls_contestacao_proc.qt_contestada%type, vl_glosado_p pls_contestacao_proc.vl_contestado%type, ie_envio_recebimento_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

				
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
OPS - Selecao de Itens da Contestacao / OPS - Controle de Contestacoes
Finalidade: Selecionar os itens que devem estar no lote de contestacao
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 

ie_bloquear_w		varchar(10);
ie_status_w		pls_contestacao.ie_status%type;
vl_procedimento_w	pls_conta_proc.vl_unitario%type;
qt_procedimento_w	pls_conta_proc.qt_procedimento%type;
vl_material_w		pls_conta_mat.vl_unitario%type;
qt_material_w		pls_conta_mat.qt_material%type;
nr_seq_contest_w	pls_contestacao.nr_sequencia%type;
nr_seq_conta_w		pls_conta.nr_sequencia%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_fatura_conta_w	pls_fatura_conta.nr_sequencia%type;
nr_nota_w		ptu_nota_cobranca.nr_nota%type;
ie_novo_pos_estab_w	pls_visible_false.ie_novo_pos_estab%type;
nr_seq_pos_proc_w	pls_conta_pos_proc.nr_sequencia%type;
nr_seq_pos_mat_w	pls_conta_pos_mat.nr_sequencia%type;
	
C01 CURSOR FOR
	SELECT	b.nr_sequencia,		-- Procedimentos - Pagamento
		null
	from	pls_conta	b,
		pls_conta_proc	a
	where	a.nr_seq_conta		= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_conta_proc_p
	and	b.nr_seq_fatura		= nr_seq_fatura_p
	and	ie_envio_recebimento_p	= 'E'
	and	a.ie_status <> 'D'
	
union

	SELECT	b.nr_sequencia,		-- Materiais - Pagamento
		null
	from	pls_conta	b,
		pls_conta_mat	a
	where	a.nr_seq_conta		= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_conta_mat_p
	and	b.nr_seq_fatura		= nr_seq_fatura_p
	and	ie_envio_recebimento_p	= 'E'
	and	a.ie_status <> 'D'
	
union all

	select	a.nr_seq_conta,		-- Procedimentos - Pagamento
		null
	from	pls_conta_medica_resumo a
	where	a.nr_seq_fatura	= nr_seq_fatura_p
	and	a.ie_proc_mat	= 'P'
	and	a.nr_seq_item	= nr_seq_conta_proc_p
	and	ie_envio_recebimento_p = 'E'
	and	((a.ie_situacao != 'I') or (coalesce(ie_situacao::text, '') = ''))
	
union all

	select	a.nr_seq_conta,		-- Materiais - Pagamento
		null
	from	pls_conta_medica_resumo a
	where	a.nr_seq_fatura	= nr_seq_fatura_p
	and	a.ie_proc_mat = 'M'
	and	a.nr_seq_item	= nr_seq_conta_mat_p
	and	ie_envio_recebimento_p = 'E'
	and	((a.ie_situacao != 'I') or (coalesce(ie_situacao::text, '') = ''))
	
union all

	select	b.nr_seq_conta,		-- Procedimentos - Faturamento
		b.nr_sequencia
	from	pls_fatura			d,
		pls_fatura_evento		c,
		pls_fatura_conta		b,
		pls_fatura_proc			a
	where	a.nr_seq_fatura_conta	= b.nr_sequencia
	and	b.nr_seq_fatura_evento	= c.nr_sequencia
	and	d.nr_sequencia		= c.nr_seq_fatura
	and	a.nr_seq_conta_proc 	= nr_seq_conta_proc_p
	and	d.nr_sequencia		= nr_seq_fatura_p
	and	a.nr_sequencia		= coalesce(nr_seq_fatura_proc_p, a.nr_sequencia)
	and	ie_envio_recebimento_p	= 'R'
	and	a.ie_tipo_cobranca in ('1','2')
	
union

	select	b.nr_seq_conta,		-- Materiais - Faturamento
		b.nr_sequencia
	from	pls_fatura			d,
		pls_fatura_evento		c,
		pls_fatura_conta		b,
		pls_fatura_mat			a
	where	a.nr_seq_fatura_conta	= b.nr_sequencia
	and	b.nr_seq_fatura_evento	= c.nr_sequencia
	and	d.nr_sequencia		= c.nr_seq_fatura
	and	a.nr_seq_conta_mat 	= nr_seq_conta_mat_p
	and	d.nr_sequencia		= nr_seq_fatura_p
	and	a.nr_sequencia		= coalesce(nr_seq_fatura_mat_p, a.nr_sequencia)
	and	ie_envio_recebimento_p	= 'R'
	and	a.ie_tipo_cobranca in ('1','2');
	

BEGIN	
select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	pls_lote_contestacao
where	nr_sequencia = nr_seq_lote_p;

select	coalesce(max(ie_novo_pos_estab),'N')
into STRICT	ie_novo_pos_estab_w
from	pls_visible_false
where	cd_estabelecimento	= cd_estabelecimento_w;

-- Obter regra de bloqueamento do item da fatura
ie_bloquear_w := pls_obter_regra_bloq_fat( cd_estabelecimento_w, ie_bloquear_w);
	
open C01;
loop
fetch C01 into	
	nr_seq_conta_w,
	nr_seq_fatura_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	-- Verificar se ha contestacao para a conta
	select	max(a.nr_sequencia),
		max(a.ie_status)
	into STRICT	nr_seq_contest_w,
		ie_status_w
	from	pls_lote_contestacao	b,
		pls_contestacao		a
	where	b.nr_sequencia	= a.nr_seq_lote
	and	a.nr_seq_lote	= nr_seq_lote_p
	and	a.nr_seq_conta	= nr_seq_conta_w
	and	b.ie_status	= 'A'
	and	a.ie_status	in ('C','D');
	
	-- Fatura de pagamento A500
	if (ie_envio_recebimento_p = 'E') then
		select	max(x.nr_nota)
		into STRICT	nr_nota_w
		from	pls_conta y,
			ptu_nota_cobranca x 
		where 	x.nr_sequencia = y.nr_seq_nota_cobranca
		and	y.nr_sequencia = nr_seq_conta_w;
	
	-- Fatura de recebimento A500
	elsif (ie_envio_recebimento_p = 'R') then
		select	max(x.nr_nota)
		into STRICT	nr_nota_w
		from	ptu_nota_cobranca x
		where	nr_seq_conta	= nr_seq_conta_w;
	end if;
	
	if (coalesce(nr_seq_contest_w::text, '') = '') and (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then	-- Contestacao
		select	nextval('pls_contestacao_seq')
		into STRICT	nr_seq_contest_w
		;
		
		insert into pls_contestacao(dt_atualizacao,
			ie_status,               
			nm_usuario,                     
			nr_seq_conta,            
			nr_seq_lote,             
			nr_sequencia,            
			vl_atual,                
			vl_conta,                
			vl_original,
			nr_seq_fatura_conta,
			nr_nota)
		values (clock_timestamp(),
			'D',
			nm_usuario_p,
			nr_seq_conta_w,
			nr_seq_lote_p,
			nr_seq_contest_w,
			0,
			0,
			0,
			nr_seq_fatura_conta_w,
			nr_nota_w);
	end if;

	if (ie_status_w = 'C') then
		update	pls_contestacao
		set	ie_status	= 'D'
		where	nr_sequencia	= nr_seq_contest_w;
	end if;

	if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then		-- Procedimentos
		if (ie_envio_recebimento_p = 'E') then
			select	CASE WHEN a.vl_unitario='0' THEN a.vl_unitario_imp  ELSE a.vl_unitario END  vl_procedimento,
				CASE WHEN a.qt_procedimento='0' THEN a.qt_procedimento_imp  ELSE a.qt_procedimento END  qt_procedimento
			into STRICT	vl_procedimento_w,
				qt_procedimento_w
			from	pls_conta c,
				pls_conta_proc a
			where	a.nr_seq_conta		= c.nr_sequencia
			and	a.nr_sequencia		= nr_seq_conta_proc_p;
		else
			-- Pos antigo
			if (ie_novo_pos_estab_w = 'N') then
				select	coalesce(max(a.vl_faturado),0) + coalesce(max(a.vl_faturado_ndc),0) +
					sum(coalesce((select	sum(p.vl_faturado) + sum(p.vl_faturado_ndc)
						from	pls_fatura_proc p
						where	p.nr_seq_conta_pos_estab = a.nr_seq_conta_pos_estab
						and	p.nr_seq_fatura_conta  = a.nr_seq_fatura_conta
						and	p.ie_tipo_cobranca in ('3','4')),0)),
					max(b.qt_item) qt_procedimento
				into STRICT	vl_procedimento_w,
					qt_procedimento_w
				from	pls_conta_pos_estabelecido b,
					pls_fatura_proc a
				where	a.nr_seq_conta_pos_estab 	= b.nr_sequencia
				and	a.nr_seq_conta_proc		= nr_seq_conta_proc_p
				and	a.nr_seq_fatura_conta		= nr_seq_fatura_conta_w
				and	a.ie_tipo_cobranca not in ('3','4');
				
			-- Pos novo
			elsif (ie_novo_pos_estab_w = 'S') then
				select	coalesce(sum(a.vl_faturado),0) + coalesce(sum(a.vl_faturado_ndc),0),
					max(a.nr_seq_pos_proc)
				into STRICT	vl_procedimento_w,
					nr_seq_pos_proc_w
				from	pls_fatura_proc	a
				where	a.nr_seq_conta_proc	= nr_seq_conta_proc_p
				and	a.nr_seq_fatura_conta	= nr_seq_fatura_conta_w;
				
				select	max(qt_item)
				into STRICT	qt_procedimento_w
				from	pls_conta_pos_proc
				where	nr_sequencia	= nr_seq_pos_proc_w;
			end if;
		end if;
		
		if (coalesce(qt_procedimento_w,0) = 0) then
			select	max(qt_item) qt_procedimento
			into STRICT	qt_procedimento_w
			from	pls_conta_pos_estabelecido
			where	nr_seq_conta_proc	= nr_seq_conta_proc_p;
		end if;
		
		/*aaschlote 15/05/2014 - OS 734803 - Conforme conversado com o Bernadino, foi colocada a quantidade 1 quando o item esta zerado*/

		if (coalesce(qt_procedimento_w,0) = 0) then
			qt_procedimento_w	:= 1;
		end if;
		
		insert into pls_contestacao_proc(nr_sequencia,
				dt_atualizacao,
				nm_usuario,                     
				nr_seq_conta_proc,       
				nr_seq_contestacao,      
				qt_aceita,         
				qt_contestada,           
				qt_procedimento,       
				vl_aceito,                    
				vl_contestado,               
				vl_procedimento,
				qt_atual,
				vl_atual,
				nr_seq_fatura_proc)  
			values (nextval('pls_contestacao_proc_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_conta_proc_p,
				nr_seq_contest_w,
				0,
				qt_glosada_p,
				coalesce(qt_procedimento_w,1),
				0,
				vl_glosado_p,
				vl_procedimento_w,
				qt_glosada_p,
				vl_glosado_p,
				nr_seq_fatura_proc_p);
				
		-- Bloquear itens da fatura
		if (coalesce(ie_bloquear_w,'N') <> 'N') and (ie_envio_recebimento_p = 'R') then
			CALL pls_gerar_bloq_item_fatura( nr_seq_fatura_p, nr_seq_conta_proc_p, null, 'B', ie_bloquear_w, nm_usuario_p);
		end if;
		
	elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then		-- Materiais
		if (ie_envio_recebimento_p = 'E') then
			select	coalesce(CASE WHEN a.vl_unitario=0 THEN a.vl_unitario_imp  ELSE a.vl_unitario END ,0) vl_material,
				coalesce(CASE WHEN a.qt_material=0 THEN a.qt_material_imp  ELSE a.qt_material END ,0) qt_material
			into STRICT	vl_material_w,
				qt_material_w
			from	pls_conta c,
				pls_conta_mat a
			where	a.nr_seq_conta 		= c.nr_sequencia
			and	a.nr_sequencia		= nr_seq_conta_mat_p;
		else		
			-- Pos
			if (ie_novo_pos_estab_w = 'N') then
				select	coalesce(max(a.vl_faturado),0) + coalesce(max(a.vl_faturado_ndc),0) +
					sum(coalesce((select	sum(p.vl_faturado) + sum(p.vl_faturado_ndc)
						from	pls_fatura_mat p
						where	p.nr_seq_conta_pos_estab = a.nr_seq_conta_pos_estab
						and	p.nr_seq_fatura_conta  = a.nr_seq_fatura_conta
						and	p.ie_tipo_cobranca in ('3','4')),0)),
					max(b.qt_item) qt_procedimento
				into STRICT	vl_material_w,
					qt_material_w
				from	pls_conta_pos_estabelecido b,
					pls_fatura_mat a
				where	a.nr_seq_conta_pos_estab	= b.nr_sequencia
				and	a.nr_seq_conta_mat		= nr_seq_conta_mat_p
				and	a.nr_seq_fatura_conta		= nr_seq_fatura_conta_w
				and	a.ie_tipo_cobranca not in ('3','4');
			
			-- Pos novo
			elsif (ie_novo_pos_estab_w = 'S') then
				select	coalesce(sum(a.vl_faturado),0) + coalesce(sum(a.vl_faturado_ndc),0),
					max(a.nr_seq_pos_mat)
				into STRICT	vl_material_w,
					nr_seq_pos_mat_w
				from	pls_fatura_mat	a
				where	a.nr_seq_conta_mat	= nr_seq_conta_mat_p
				and	a.nr_seq_fatura_conta	= nr_seq_fatura_conta_w;
				
				select	max(qt_item)
				into STRICT	qt_material_w
				from	pls_conta_pos_mat
				where	nr_sequencia	= nr_seq_pos_mat_w;
			end if;
		end if;
		
		if (coalesce(qt_material_w,0) = 0) then
			select	max(qt_item) qt_procedimento
			into STRICT	qt_material_w
			from	pls_conta_pos_estabelecido
			where	nr_seq_conta_mat	= nr_seq_conta_mat_p;
		end if;
		
		/*aaschlote 15/05/2014 - OS 734803 - Conforme conversado com o Bernadino, foi colocada a quantidade 1 quando o item esta zerado*/

		if (coalesce(qt_material_w,0) = 0) then
			qt_material_w	:= 1;
		end if;
		
		insert into pls_contestacao_mat(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_conta_mat,
				nr_seq_contestacao,
				qt_aceita,
				qt_contestada,
				qt_material,
				vl_aceito,
				vl_contestado,
				vl_material,
				qt_atual,
				vl_atual,
				nr_seq_fatura_mat)
			values (nextval('pls_contestacao_mat_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_conta_mat_p,
				nr_seq_contest_w,
				0,
				qt_glosada_p,
				coalesce(qt_material_w,1),
				0,
				vl_glosado_p,
				vl_material_w,
				qt_glosada_p,
				vl_glosado_p,
				nr_seq_fatura_mat_p);	

		-- Bloquear itens da fatura
		if (coalesce(ie_bloquear_w,'N') <> 'N') and (ie_envio_recebimento_p = 'R') then
			CALL pls_gerar_bloq_item_fatura(	nr_seq_fatura_p, null, nr_seq_conta_mat_p, 'B',	ie_bloquear_w, nm_usuario_p);					
		end if;
	end if;
	end;
end loop;
close C01;

delete	
from	w_pls_selecao_item_contest
where	nm_usuario	= nm_usuario_p;

-- Atualizar os valores do lote de contestacao
CALL pls_atualizar_valores_contest(	nr_seq_lote_p, 'N');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_contestar_item ( nr_seq_lote_p pls_lote_contestacao.nr_sequencia%type, nr_seq_fatura_p pls_conta.nr_seq_fatura%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_fatura_proc_p pls_fatura_proc.nr_sequencia%type, nr_seq_fatura_mat_p pls_fatura_mat.nr_sequencia%type, qt_glosada_p pls_contestacao_proc.qt_contestada%type, vl_glosado_p pls_contestacao_proc.vl_contestado%type, ie_envio_recebimento_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
