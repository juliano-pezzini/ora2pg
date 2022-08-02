-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desf_final_grupo_analise ( nr_seq_analise_p pls_conta.nr_seq_analise%type, nr_seq_grupo_p pls_auditoria_conta_grupo.nr_seq_grupo%type, nr_seq_aud_conta_grupo_p pls_auditoria_conta_grupo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_permite_em_auditoria_p text) AS $body$
DECLARE


nm_auditor_atual_w		varchar(255);
ie_status_w			varchar(1);
nr_seq_conta_w			bigint;
nr_seq_analise_w		bigint;
nr_seq_aud_conta_grupo_w	bigint;
nr_seq_ordem_w			bigint;
nr_seq_grupo_w			bigint;
nr_seq_protocolo_w		bigint;
nr_seq_fatura_w			bigint;
cont_w				integer;
qt_coparticipacao_mens_w	integer;
qt_conta_medica_resumo_w	integer;
nr_lote_contabil_w		bigint;
nr_lote_contabil_prov_w		bigint;
nr_lote_contab_pag_w		bigint;
nr_lote_prov_copartic_w		bigint;
qt_lote_fat_w			integer;
nr_seq_lote_recalculo_w		bigint;
nr_seq_conta_rec_w		pls_rec_glosa_conta.nr_sequencia%type;
qt_conta_enviada_ans_w		integer;

/* IE_PERMITE_AUDITORIA_P
Criado esse parametro para permitir reabrir um grupo no fluxo de forma automatizada
Ou seja, nao ira impedir se tem grupos com fluxo maior ja finalizado ou se houver grupos
ja auditando
*/
C01 CURSOR(	nr_seq_analise_pc	pls_conta.nr_seq_analise%type) FOR
	SELECT	nr_sequencia,
		ie_status
	from	pls_conta
	where	nr_seq_analise = nr_seq_analise_pc
	order by 1;
	
C02 CURSOR(	nr_seq_analise_pc	pls_conta.nr_seq_analise%type) FOR
	SELECT	nr_sequencia
	from	pls_conta
	where	nr_seq_analise = nr_seq_analise_pc
	and	ie_status = 'F';

BEGIN
/*Cursor para verificar se existe algo que impossibilite reabrir a auditoria para evitar que contas com resumo gerados sejam alterados apos a geracao destes. OS 480597 Diogo*/

if (nr_seq_aud_conta_grupo_p IS NOT NULL AND nr_seq_aud_conta_grupo_p::text <> '') then

	select	nr_seq_analise,
		nr_seq_grupo,
		nr_seq_ordem
	into STRICT	nr_seq_analise_w,
		nr_seq_grupo_w,
		nr_seq_ordem_w
	from	pls_auditoria_conta_grupo
	where	nr_sequencia = nr_seq_aud_conta_grupo_p;
end if;

for r_c02_w in C02(coalesce(nr_seq_analise_p,nr_seq_analise_w)) loop
	begin
	CALL pls_desfazer_fechamento_conta(r_c02_w.nr_sequencia,cd_estabelecimento_p,nm_usuario_p,
					'A');
	end;
end loop;

open C01(coalesce(nr_seq_analise_p,nr_seq_analise_w));
loop
fetch C01 into	
	nr_seq_conta_w,
	ie_status_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_protocolo_w		:= null;
	nr_seq_fatura_w			:= null;
	nr_lote_contabil_w		:= null;
	nr_lote_contabil_prov_w		:= null;
	nr_lote_contab_pag_w		:= null;
	nr_lote_prov_copartic_w		:= null;
	
	/*Se houver uma conta fechada o auditor ja nao pode reabrir o processo*/

	if (ie_status_w = 'F') then
		--Esta analise possui contas fechadas. Processo abortado.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(183534);
	end if;
	
	select	count(1)
	into STRICT	qt_conta_enviada_ans_w
	from	sip_nv_dados a
	where	a.ie_conta_enviada_ans = 'S'
	and	a.nr_seq_conta = nr_seq_conta_w
	and	exists (	SELECT	1
			from	pls_lote_sip b
			where	b.nr_sequencia = a.nr_seq_lote_sip
			and	(b.dt_envio IS NOT NULL AND b.dt_envio::text <> ''));
	
	if (qt_conta_enviada_ans_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(337915);
	end if;
	
	select	max(nr_seq_protocolo),
		max(nr_seq_fatura)
	into STRICT	nr_seq_protocolo_w,
		nr_seq_fatura_w
	from	pls_conta
	where	nr_sequencia	= nr_seq_conta_w;

	select	count(1)
	into STRICT	cont_w
	from	pls_prot_conta_titulo	a,
		pls_protocolo_conta	b,
		pls_conta		c
	where	a.nr_seq_protocolo	= b.nr_sequencia
	and	b.nr_sequencia		= c.nr_seq_protocolo
	and	c.nr_sequencia		= nr_seq_conta_w;
	
	select	count(1)
	into STRICT	qt_coparticipacao_mens_w
	from	pls_conta_coparticipacao
	where	nr_seq_conta = nr_seq_conta_w
	and	(nr_seq_mensalidade_seg IS NOT NULL AND nr_seq_mensalidade_seg::text <> '');
	
	/*Caso tiver pagamento de producao para a conta nao pode desfazer o fechamento*/

	select	sum(qt)
	into STRICT	qt_conta_medica_resumo_w
	from	(
		SELECT	count(1) qt
		from	pls_conta_medica_resumo
		where	nr_seq_conta = nr_seq_conta_w
		and	(nr_seq_lote_pgto IS NOT NULL AND nr_seq_lote_pgto::text <> '')
		and	((ie_situacao != 'I') or (coalesce(ie_situacao::text, '') = ''))
		
union all

		SELECT	count(1) qt
		from	pls_conta_medica_resumo
		where	nr_seq_conta = nr_seq_conta_w
		and	(nr_seq_pp_lote IS NOT NULL AND nr_seq_pp_lote::text <> '')
		and	ie_situacao = 'A'
	) alias9;

	select	max(nr_lote_contabil),
		max(nr_lote_contabil_prov),
		max(nr_lote_contab_pag),
		max(nr_lote_prov_copartic)
	into STRICT	nr_lote_contabil_w,
		nr_lote_contabil_prov_w,
		nr_lote_contab_pag_w,
		nr_lote_prov_copartic_w
	from	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_w;
		
	select	count(1)	
	into STRICT	qt_lote_fat_w
	from	pls_conta_pos_estabelecido a,
		pls_lote_faturamento b
	where	a.nr_seq_lote_fat = b.nr_sequencia
	and	a.nr_seq_conta	= nr_seq_conta_w
	and	(a.nr_seq_lote_fat IS NOT NULL AND a.nr_seq_lote_fat::text <> '')
	and	((a.ie_situacao	= 'A') or (coalesce(a.ie_situacao::text, '') = ''))
	and	b.ie_tipo_lote <> 'A';
		
	if (qt_lote_fat_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190837);
	end if;
	
	if (qt_conta_medica_resumo_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190838);
	end if;

	if (qt_coparticipacao_mens_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190839);
	end if;

	if (cont_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190841);
	end if;

	/* Lepinski - OSs 389180 e 381715 - Conforme conversa com Adriano, nao permitir desfazer o fechamento da conta, caso a mesma ja esteja em lote de contabilizacao */

	if (coalesce(nr_lote_contabil_w,0) <> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190842,'NR_LOTE_CONTABIL_W='||nr_lote_contabil_w);
	end if;
	if (coalesce(nr_lote_contab_pag_w,0) <> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190845,'NR_LOTE_CONTABIL_W='||nr_lote_contab_pag_w);
	end if;
	/* Edgar 28/11/2013, OS 664025, cfme conversado com Adriano, nao ha necessidade de consistir o lote de provisao de producao medica
	if	(nvl(nr_lote_contabil_prov_w,0) <> 0) then
		wheb_mensagem_pck.exibir_mensagem_abort(190847,'NR_LOTE_CONTABIL_W='||nr_lote_contabil_prov_w);
	end if;
	*/
	if (coalesce(nr_lote_prov_copartic_w,0) <> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190849,'NR_LOTE_CONTABIL_W='||nr_lote_prov_copartic_w);
	end if;

	/* Felipe - 28/07/2011 - OS 338196 - Nao permitir alterar protocolos que estejam em lote de recalculo nao liberado*/

	select	coalesce(max(b.nr_sequencia),0)
	into STRICT	nr_seq_lote_recalculo_w
	from	pls_lote_recalculo	b,
		pls_conta_recalculo	a
	where	a.nr_seq_lote		= b.nr_sequencia
	and	a.nr_seq_protocolo	= nr_seq_protocolo_w
	and	(b.dt_geracao_lote IS NOT NULL AND b.dt_geracao_lote::text <> '')
	and	coalesce(b.dt_aplicacao::text, '') = '';

	if (nr_seq_lote_recalculo_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190850,'NR_SEQ_LOTE_RECALCULO_W='||nr_seq_lote_recalculo_w);
	end if;
	end;
end loop;
close C01;

if (coalesce(nr_seq_analise_w::text, '') = '') or (coalesce(nr_seq_grupo_w::text, '') = '') then
	select	nr_seq_analise,
		nr_seq_grupo
	into STRICT	nr_seq_analise_w,
		nr_seq_grupo_w
	from	pls_auditoria_conta_grupo
	where (nr_seq_grupo 		= nr_seq_grupo_p and nr_seq_analise = nr_seq_analise_p)
	or (nr_sequencia		= nr_seq_aud_conta_grupo_p);
end if;

if (coalesce(nr_seq_ordem_w::text, '') = '') then
	select	max(nr_seq_ordem)
	into STRICT	nr_seq_ordem_w
	from	pls_auditoria_conta_grupo
	where	nr_sequencia = nr_seq_aud_conta_grupo_p;
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_aud_conta_grupo_w
from	pls_auditoria_conta_grupo
where	nr_seq_ordem   > nr_seq_ordem_w
and	nr_seq_analise = nr_seq_analise_w
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

if (coalesce(nr_seq_aud_conta_grupo_w,0) > 0) and (coalesce(ie_permite_em_auditoria_p,'N') = 'N') then
	--Nao e possivel desfazer a finalizacao da analise deste grupo enquanto houver grupos superiores liberados.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(183535);	
end if;

select	max(nm_auditor_atual)
into STRICT	nm_auditor_atual_w
from	pls_auditoria_conta_grupo
where	nr_seq_ordem   > nr_seq_ordem_w
and	nr_seq_analise = nr_seq_analise_w
and	coalesce(dt_liberacao::text, '') = ''
and	coalesce(nm_auditor_atual,'X') <> 'X';

if (coalesce(nm_auditor_atual_w,'X') <> 'X') and (coalesce(ie_permite_em_auditoria_p,'N') = 'N') then	
	--Nao e possivel desfazer a finalizacao da analise deste grupo pois o grupo atual esta em processo de auditoria.	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(183597);
end if;

update	pls_auditoria_conta_grupo
set	dt_liberacao		 = NULL,
	nm_auditor_atual	 = NULL,
	dt_inicio_auditor	 = NULL,
	dt_atualizacao		= clock_timestamp(),
	dt_final_analise	 = NULL, /* OS 372956  - 26/01/2012*/
	nm_usuario		= nm_usuario_p
where (nr_seq_grupo 		= nr_seq_grupo_p and nr_seq_analise = nr_seq_analise_p)
or (nr_sequencia		= nr_seq_aud_conta_grupo_p);

CALL pls_inserir_hist_analise(null, coalesce(nr_seq_analise_p, nr_seq_analise_w), 24,
			null, 'A', null,
			null, 'Desfeita a finalizacao da analise do grupo ' || pls_obter_nome_grupo_auditor(nr_seq_grupo_w) || ' (Ordem: ' || nr_seq_ordem_w || ') pelo usuario ' ||
			pls_Obter_Nome_Usuario(nm_usuario_p) || '.', null,
			nm_usuario_p, cd_estabelecimento_p);

if (nr_seq_fatura_w IS NOT NULL AND nr_seq_fatura_w::text <> '') then

	begin
		select	  g.ie_status
		into STRICT	  ie_status_w
		from      ptu_fatura g
		where     g.nr_sequencia = nr_seq_fatura_w;
	exception
	when others then
		ie_status_w := '';
	end;

	if (ie_status_w = 'CA') then	
		--A fatura da analise #@NR_SEQ_ANALISE#@ esta cancelada. Nao e possivel desfazer a finalizacao dos grupos.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(183602,  'NR_SEQ_ANALISE='||nr_seq_analise_p);	
	elsif (ie_status_w = 'E') then	
		--A fatura da analise #@NR_SEQ_ANALISE#@ esta encerrada. Nao e possivel desfazer a finalizacao dos grupos.	
		CALL wheb_mensagem_pck.exibir_mensagem_abort(183603, 'NR_SEQ_ANALISE='||nr_seq_analise_p);
	end if;

	CALL ptu_atualizar_status_fatura(nr_seq_fatura_w, 'A', null, nm_usuario_p);
end if;
		
/*Realizado o update para que caso a analise estive-se concluida*/

update	pls_analise_conta
set	dt_liberacao_analise	 = NULL,
	dt_final_analise	 = NULL,	
	ie_status		= 'A',
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia 		= coalesce(nr_seq_analise_p, nr_seq_analise_w);

CALL pls_atualizar_grupo_penden(coalesce(nr_seq_analise_p,nr_seq_analise_w), cd_estabelecimento_p, nm_usuario_p);

-- Atualizar status da analise de recurso de glosa
if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') or (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_conta_rec_w
	from	pls_rec_glosa_conta
	where	nr_seq_analise	= nr_seq_analise_p;
	
	if (coalesce(nr_seq_conta_rec_w::text, '') = '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_conta_rec_w
		from	pls_rec_glosa_conta
		where	nr_seq_analise	= nr_seq_analise_w;
	end if;
	
	if (nr_seq_conta_rec_w IS NOT NULL AND nr_seq_conta_rec_w::text <> '') then
		CALL pls_reabrir_rec_glosa_conta( nr_seq_conta_rec_w, null, nm_usuario_p);
	end if;
end if;

/*commit;*/

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desf_final_grupo_analise ( nr_seq_analise_p pls_conta.nr_seq_analise%type, nr_seq_grupo_p pls_auditoria_conta_grupo.nr_seq_grupo%type, nr_seq_aud_conta_grupo_p pls_auditoria_conta_grupo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_permite_em_auditoria_p text) FROM PUBLIC;

