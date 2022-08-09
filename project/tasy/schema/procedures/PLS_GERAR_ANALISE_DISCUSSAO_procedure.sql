-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_analise_discussao ( nr_seq_contest_disc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

				 
cd_guia_w			varchar(20);
ie_pre_analise_w			varchar(10);
ie_gerar_analise_audit_w		varchar(1)	:= 'S';
ie_existe_analise_w			bigint;
nr_seq_analise_w			bigint;
nr_lote_w				bigint;
nr_seq_prestador_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_congenere_w		bigint;
nr_seq_protocolo_w		bigint;
nr_seq_item_criado_w		bigint;
nr_seq_ptu_fatura_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_lote_contest_w		bigint;
ie_origem_conta_w			varchar(2);
nr_seq_plano_w			bigint;
ie_preco_w			varchar(2);
nm_prestador_w			varchar(255);
nm_cooperativa_w			varchar(255);
nm_segurado_w			varchar(255);
cd_cooperativa_w			varchar(10);			
cd_guia_referencia_w		pls_conta.cd_guia_referencia%type;
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
nr_seq_analise_ref_w		pls_analise_conta.nr_seq_analise_ref%type;
dt_atendimento_referencia_w	timestamp;

 

BEGIN 
/*Obter dados da conta*/
 
select	d.cd_guia_referencia, 
	d.cd_guia, 
	d.nr_seq_segurado, 
	e.nr_seq_protocolo, 
	e.nr_seq_ptu_fatura, 
	a.nr_seq_lote_conta, 
	d.nr_sequencia,	 
	substr(pls_obter_dados_segurado(d.nr_seq_segurado,'N'),1,255), 
	d.ie_tipo_guia, 
	d.dt_atendimento_referencia 
into STRICT	cd_guia_referencia_w, 
	cd_guia_w, 
	nr_seq_segurado_w, 
	nr_seq_protocolo_w, 
	nr_seq_ptu_fatura_w, 
	nr_lote_w, 
	nr_seq_conta_w, 
	nm_segurado_w, 
	ie_tipo_guia_w, 
	dt_atendimento_referencia_w 
from	pls_contestacao_discussao	b, 
	pls_lote_discussao		a, 
	pls_contestacao			c, 
	pls_lote_contestacao		e, 
	pls_conta			d 
where	a.nr_sequencia		= b.nr_seq_lote 
and	b.nr_seq_contestacao	= c.nr_sequencia 
and	c.nr_seq_lote		= e.nr_sequencia 
and	c.nr_seq_conta		= d.nr_sequencia 
and	b.nr_sequencia		= nr_seq_contest_disc_p;
 
if (coalesce(cd_guia_w::text, '') = '') or (somente_numero(cd_guia_referencia_w) > 0) then 
	cd_guia_w	:= cd_guia_referencia_w;
end if;
 
if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') then 
	select	a.nr_seq_protocolo 
	into STRICT	nr_seq_protocolo_w 
	from	ptu_fatura a 
	where	a.nr_sequencia	= nr_seq_ptu_fatura_w;
end if;
 
if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then	 
	select	coalesce(b.nr_seq_prestador,a.nr_seq_prestador_exec), 
		b.nr_seq_congenere, 
		a.ie_origem_conta, 
		substr(pls_obter_dados_prestador(b.nr_seq_prestador,'N'),1,255), 
		substr(pls_obter_nome_congenere(b.nr_seq_congenere),1,255), 
		substr(pls_obter_seq_codigo_coop(b.nr_seq_congenere,''),1,10) 
	into STRICT	nr_seq_prestador_w, 
		nr_seq_congenere_w, 
		ie_origem_conta_w, 
		nm_prestador_w, 
		nm_cooperativa_w, 
		cd_cooperativa_w 
	from	pls_conta		a, 
		pls_protocolo_conta	b 
	where	a.nr_seq_protocolo	= b.nr_sequencia 
	and	a.nr_sequencia		= nr_seq_conta_w;
end if;
 
/*Obter produto do beneficiario*/
 
begin 
select	pls_obter_produto_benef(a.nr_sequencia, dt_atendimento_referencia_w) 
into STRICT	nr_seq_plano_w 
from	pls_segurado a 
where	a.nr_sequencia = nr_seq_segurado_w;
exception 
when others then 
	nr_seq_plano_w	:= null;
end;
 
/*Obter formação de preço do produto*/
 
begin 
select	ie_preco 
into STRICT	ie_preco_w 
from	pls_plano 
where	nr_sequencia = nr_seq_plano_w;
exception 
when others then 
	ie_preco_w	:= '';
end;
 
 
if (coalesce(nr_lote_w,0) > 0) then 
	/*Verifica se existe analise para esta discussao */
	 
	select	count(*) 
	into STRICT	ie_existe_analise_w 
	from	pls_analise_conta a 
	where	cd_guia = cd_guia_w 
	and	coalesce(nr_seq_lote_protocolo,0) = coalesce(nr_lote_w,0) 
	and	a.nr_seq_segurado = nr_seq_segurado_w 
	and	(((coalesce(ie_auditoria,'N') = 'S') and (ie_status = 'G'))	--Gerada na mesma análise se a analise estiver em aguardando auditoria ou seja sem o processo ter sido iniciado 
	or (coalesce(ie_auditoria,'N') = 'N'));				--Ou se a conta não for de auditoria, dai pode-se iniciar em todas as etapas	 
		
	if (ie_existe_analise_w > 0) then		 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_analise_w 
		from	pls_analise_conta 
		where	cd_guia = cd_guia_w 
		and	nr_seq_segurado = nr_seq_segurado_w 
		and	coalesce(nr_seq_lote_protocolo,0) = coalesce(nr_lote_w,0) 
		and	(((coalesce(ie_auditoria,'N') = 'S') and (ie_status = 'G')) 
		or (coalesce(ie_auditoria,'N') = 'N'));
		 
		update	pls_analise_conta 
		set	ie_status = 'S' 
		where	nr_sequencia = nr_seq_analise_w;		
	else 
		if	((nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') or (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '')) then 
			select	nextval('pls_analise_conta_seq') 
			into STRICT	nr_seq_analise_w 
			;
			 
			-- levanta-se a analise principal, com base na conta principal, para se fazer o vinculo. 
			begin 
				select	a.nr_seq_analise 
				into STRICT	nr_seq_analise_ref_w 
				from	pls_conta	a, 
					pls_conta	b 
				where	a.nr_sequencia	= b.nr_seq_conta_princ 
				and	b.nr_sequencia	= nr_seq_conta_w;
			exception 
				when no_data_found then nr_seq_analise_ref_w := null;
			end;
 
			/*Se não existe cria-se um novo registro de analise*/
 
			insert into pls_analise_conta(nr_sequencia, nr_seq_lote_protocolo, nr_seq_prestador, 
				 nr_seq_segurado, nm_usuario, 
				 nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec, 
				 cd_guia, ie_status, dt_analise, 
				 dt_inicio_analise, ie_auditoria, nr_seq_congenere, 
				 ie_pre_analise, ie_origem_analise, ie_origem_conta, 
				 ie_preco, cd_estabelecimento, nm_prestador, 
				 nm_cooperativa, cd_cooperativa, nm_segurado, 
				 ie_tipo_guia, nr_seq_analise_ref) 
			values (nr_seq_analise_w, nr_lote_w, nr_seq_prestador_w, 
				 nr_seq_segurado_w, nm_usuario_p, 
				 nm_usuario_p, clock_timestamp(), clock_timestamp(), 
				 cd_guia_w, 'G', clock_timestamp(), 
				 clock_timestamp(), ie_gerar_analise_audit_w, nr_seq_congenere_w, 
				 'N', 5, ie_origem_conta_w, 
				 ie_preco_w, cd_estabelecimento_p, nm_prestador_w, 
				 nm_cooperativa_w, cd_cooperativa_w, nm_segurado_w, 
				 ie_tipo_guia_w, nr_seq_analise_ref_w);
		end if;
	end if;	
	 
	if (coalesce(nr_seq_analise_w,0) > 0) then 
		/*Gerar os dados do resumo para ser usado na função OPS - Análise de Produção Médica */
 
		nr_seq_item_criado_w := pls_gerar_w_discussao_item(nr_seq_contest_disc_p, nr_seq_analise_w, nm_usuario_p, nr_seq_item_criado_w);
		 
		update	pls_contestacao_discussao 
		set	nr_seq_analise	= nr_seq_analise_w 
		where	nr_sequencia	= nr_seq_contest_disc_p;
	 
		/*Copiar as glosas e ocorrencias para a tabela ser usado na análise*/
 
		CALL pls_gerar_analise_disc_item(nr_seq_contest_disc_p, nr_seq_analise_w, cd_estabelecimento_p, nm_usuario_p);
	 
		CALL pls_gerar_grupo_aud_disc(nr_seq_conta_w, nr_seq_analise_w, nm_usuario_p, cd_estabelecimento_p); /*Gerar grupo da analise*/
	
	end if;
		 
	CALL pls_gerar_lib_analise(nr_seq_analise_w, cd_estabelecimento_p, nm_usuario_p);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_analise_discussao ( nr_seq_contest_disc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
