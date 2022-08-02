-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_desdobrar_fatura_lote ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* 1º Quebra - regra de valor maximo para cada fatura*/
 
/*2° Quebra - Por PCMSO*/
 
/*3° taxa de intercâmbio*/
 
/*4° Taxa de intercâmbio, que não permite enviar a conta*/
 
 
nr_seq_cobranca_w		bigint;
nr_seq_protocolo_conta_w	bigint;
nr_seq_conta_w			bigint;
nr_seq_protocolo_w		bigint;
nr_seq_unimed_destino_w		bigint;
nr_seq_fatura_w			bigint;
cd_unimed_origem_w		varchar(10);
cd_cooperativa_w		varchar(10);
dt_inicio_w			timestamp;
dt_fim_w			timestamp;
dt_mes_competencia_w		timestamp;
vl_fatura_w			double precision;
nr_seq_camara_w			bigint;
vl_maximo_arquivo_w		double precision;
vl_total_fatura_w		double precision;
vl_conta_w			double precision;
nr_seq_congenere_w		bigint;
ie_pcmso_w			varchar(10)	:= 'N';
ie_sem_camara_comp_w		varchar(3)	:= 'N';
ie_quebrar_fatura_ptu_tx_w	varchar(1)	:= 'N';
dt_prev_envio_w			timestamp;
ie_criar_fatura_w		varchar(10)	:= 'N';
ie_envia_w			varchar(1)	:= 'S';
pr_taxa_atual_w			double precision	:= 0;
dt_vencimento_fatura_w		timestamp;
nr_seq_cong_resp_financ_w	bigint;
qt_conta_exc_w			integer;

C02 CURSOR FOR 
	SELECT	b.nr_sequencia, 
		a.cd_unimed_destino, 
		b.nr_seq_conta, 
		coalesce(b.ie_pcmso,'N'), 
		a.dt_emissao_fatura, 
		b.pr_taxa, 
		b.ie_envia_conta, 
		a.dt_vencimento_fatura, 
		a.nr_seq_cong_resp_financ 
	from	ptu_fatura		a, 
		ptu_nota_cobranca	b 
	where	a.nr_sequencia	= b.nr_seq_fatura 
	and	a.nr_seq_lote	= nr_seq_lote_p;
/*Busca valor,da regra para quebra das faturas*/
c04 CURSOR FOR 
	SELECT	a.vl_maximo_arquivo 
	from	pls_regra_valor_a500 a 
	where	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	((coalesce(a.nr_seq_congenere::text, '') = '') or (a.nr_seq_congenere = nr_seq_congenere_w)) 
	and	((coalesce(a.nr_seq_camara::text, '') = '') or (a.nr_seq_camara = nr_seq_camara_w)) 
	and	trunc(clock_timestamp(),'dd') between trunc(a.dt_inicio_vigencia,'dd') and fim_dia(a.dt_fim_vigencia) 
	order by 
		 coalesce(a.dt_inicio_vigencia,clock_timestamp()) desc, 
		 coalesce(a.nr_seq_camara,0), 
		 coalesce(a.nr_seq_congenere,0);
/*Verificar se as contas podem entrar na qual fatura ou se tem que criar uma fatura nova regra de valor maximo por fatura*/
c05 CURSOR FOR 
	SELECT	c.nr_sequencia, 
		c.vl_total_fatura 
	from	ptu_fatura		c 
	where	c.nr_seq_lote		= nr_seq_lote_p 
	and	c.cd_unimed_destino	= cd_cooperativa_w 
	and	coalesce(c.ie_pcmso,ie_pcmso_w)		= ie_pcmso_w 
	and	coalesce(c.pr_taxa,pr_taxa_atual_w)		= pr_taxa_atual_w 
	and	coalesce(c.ie_envia_conta,ie_envia_w)	= ie_envia_w;


BEGIN 
 
/* Obter dados do lote da fatura, para buscar no cusor 1 as contas */
 
select	dt_inicio, 
	fim_dia(dt_fim), 
	nr_seq_camara, 
	coalesce(ie_sem_camara_comp,'N'), 
	coalesce(dt_previsao_envio,clock_timestamp()) 
into STRICT	dt_inicio_w, 
	dt_fim_w, 
	nr_seq_camara_w, 
	ie_sem_camara_comp_w, 
	dt_prev_envio_w 
from	ptu_lote_fatura_envio 
where	nr_sequencia	= nr_seq_lote_p;
 
 
begin 
select	ie_quebrar_fatura_ptu_tx 
into STRICT	ie_quebrar_fatura_ptu_tx_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
exception 
when others then 
	ie_quebrar_fatura_ptu_tx_w	:= 'N';
end;
 
/* Obter a Unimed do estabelecimento, a propria */
 
cd_unimed_origem_w	:= pls_obter_unimed_estab(cd_estabelecimento_p);
 
open C02;
loop 
fetch C02 into 
	nr_seq_cobranca_w, 
	cd_cooperativa_w, 
	nr_seq_conta_w, 
	ie_pcmso_w, 
	dt_mes_competencia_w, 
	pr_taxa_atual_w, 
	ie_envia_w, 
	dt_vencimento_fatura_w, 
	nr_seq_cong_resp_financ_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	/*Obter sequencia da operadora para regra de valor para quebra das faturas*/
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_congenere_w 
	from	pls_congenere 
	where	cd_cooperativa = cd_cooperativa_w;
	 
	/*Obter câmara da operadora para regra de valor para quebra das faturas*/
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_camara_w 
	from	pls_congenere_camara 
	where	nr_seq_congenere	= nr_seq_congenere_w;
	/* Obter valor máximo, para quebra das faturas */
 
	open c04;
	loop 
	fetch c04 into	 
		vl_maximo_arquivo_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin 
		null;
		end;
	end loop;
	close c04;
	begin 
	select	sum(coalesce(a.vl_procedimento,0) + coalesce(a.vl_adic_procedimento,0) + coalesce(a.vl_adic_co,0) + coalesce(a.vl_adic_filme,0) + 
		coalesce(vl_custo_operacional,0) + coalesce(vl_filme,0)) 
	into STRICT	vl_conta_w 
	from	ptu_fatura		c, 
		ptu_nota_cobranca	b, 
		ptu_nota_servico	a 
	where	b.nr_sequencia		= a.nr_seq_nota_cobr 
	and	c.nr_sequencia		= b.nr_seq_fatura 
	and	b.nr_sequencia		= nr_seq_cobranca_w 
	and	c.nr_seq_lote		= nr_seq_lote_p 
	and	c.cd_unimed_destino	= cd_cooperativa_w;
	exception 
	when others then 
		vl_conta_w	:= 0;
	end;
	 
	ie_criar_fatura_w	:= 'S';
	 
	open C05;
	loop 
	fetch C05 into	 
		nr_seq_fatura_w, 
		vl_total_fatura_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin 
		ie_criar_fatura_w	:= 'N';
		if (vl_total_fatura_w + vl_conta_w > coalesce(vl_maximo_arquivo_w,999999999999999)) and (vl_total_fatura_w <> 0) then 
			ie_criar_fatura_w	:= 'S';
		else 
			ie_criar_fatura_w	:= 'N';
		end if;
		end;
	end loop;
	close C05;
	/* Quebrar as faturas caso pegue auguma regra*/
 
	if (coalesce(ie_criar_fatura_w,'N') = 'S') then 
		/* Se não existir então cria a fatura da cooperativa */
 
		select	nextval('ptu_fatura_seq') 
		into STRICT	nr_seq_fatura_w 
		;
 
		insert into ptu_fatura(nr_sequencia, cd_estabelecimento, cd_unimed_destino, 
			cd_unimed_origem, dt_geracao, nr_competencia, 
			nr_fatura, dt_vencimento_fatura, dt_atualizacao, 
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
			dt_emissao_fatura, vl_total_fatura, nr_versao_transacao, 
			ie_tipo_fatura, ie_operacao, nr_seq_lote, 
			ie_pcmso, pr_taxa, ie_envia_conta, 
			nr_seq_cong_resp_financ,ie_doc_fisica_conferida) 
		values (nr_seq_fatura_w, cd_estabelecimento_p, cd_cooperativa_w, 
			cd_unimed_origem_w, trunc(clock_timestamp(),'dd'), (to_char(clock_timestamp(),'yymm'))::numeric , 
			null, dt_vencimento_fatura_w, clock_timestamp(), 
			nm_usuario_p, clock_timestamp(), nm_usuario_p, 
			trunc(dt_mes_competencia_w,'dd'), 0, 16, 
			1, 'E', nr_seq_lote_p, 
			ie_pcmso_w, pr_taxa_atual_w, ie_envia_w, 
			nr_seq_cong_resp_financ_w,'N');
			 
		CALL ptu_atualizar_status_fat_envio(nr_seq_fatura_w, 1, nm_usuario_p);
		/*Chamada para re-criar os item pos tem que duplicar por que são mesmos procedimentos*/
 
		CALL ptu_gerar_fatura_cedente(nr_seq_fatura_w,nm_usuario_p);
		CALL ptu_gerar_fatura_boleto(nr_seq_fatura_w,nm_usuario_p);
		 
	end if;
	/* atualizar a conta para a fatura nova*/
 
	update	pls_conta_medica_resumo 
	set	nr_seq_fatura	= nr_seq_fatura_w 
	where	nr_seq_conta	= nr_seq_conta_w 
	and	ie_situacao = 'A';
	/*Alterar a cobrança a para a fatura nava*/
 
	update	ptu_nota_cobranca 
	set	nr_seq_fatura	= nr_seq_fatura_w 
	where	nr_sequencia	= nr_seq_cobranca_w;
	/*Atulizar o valor da fatura*/
 
	update	ptu_fatura 
	set	vl_total_fatura	= vl_total_fatura + vl_conta_w, 
		pr_taxa		= pr_taxa_atual_w, 
		ie_envia_conta	= ie_envia_w, 
		ie_pcmso	= ie_pcmso_w 
	where	nr_sequencia	= nr_seq_fatura_w;
	/*Atualizar exclusão*/
 
	update	ptu_fatura_conta_exc 
	set	nr_seq_fatura	= nr_seq_fatura_w 
	where	nr_seq_conta	= nr_seq_conta_w;
	 
	select	count(*) 
	into STRICT	qt_conta_exc_w 
	from	ptu_fatura_conta_exc 
	where	nr_seq_fatura 	= nr_seq_fatura_w 
	and	nr_seq_conta 	= nr_seq_conta_w;
 
	if (qt_conta_exc_w > 0) then 
		update	pls_conta_medica_resumo 
		set	nr_seq_fatura 	 = NULL, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_seq_fatura	= nr_seq_fatura_w 
		and	ie_situacao = 'A';
	end if;
	 
	/*OS - 291031 ultimo item do anexo (21)*/
 
	CALL ptu_gerar_fatura_corpo(nr_seq_fatura_w, nm_usuario_p);
 
	CALL ptu_a500_gravar_historico(1,'Lote gerado pelo usuario: '||nm_usuario_p,nr_seq_lote_p,nr_seq_fatura_w,cd_estabelecimento_p,nm_usuario_p);
 
	end;
end loop;
close C02;
 
update	ptu_lote_fatura_envio 
set	dt_geracao_lote	= clock_timestamp(), 
	nm_usuario	= nm_usuario_p, 
	dt_atualizacao	= clock_timestamp() 
where	nr_sequencia	= nr_seq_lote_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_desdobrar_fatura_lote ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

