-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE pls_regra_via_acesso_pck.pls_define_limpa_via_acesso ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_analise_p pls_conta.nr_seq_analise%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE
	
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por determinar quais procedimentos terao seus dados referentes a via de acesso limpados. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 	

ie_via_acesso_regra_w		pls_parametros.ie_via_acesso_regra%type;
ie_limpa_w			varchar(1);
ie_via_acesso_inf_w		varchar(1);
	
i				integer;
qt_registro_transacao_w		integer;
nr_seq_conta_proc_table_w	dbms_sql.number_table;
	
C01 CURSOR(	nr_seq_lote_pc			pls_lote_protocolo_conta.nr_sequencia%type,
		nr_seq_protocolo_pc		pls_protocolo_conta.nr_sequencia%type,
		nr_seq_lote_processo_pc		pls_cta_lote_processo.nr_sequencia%type,
		nr_seq_conta_pc			pls_conta.nr_sequencia%type,
		nr_seq_conta_proc_pc		pls_conta_proc.nr_sequencia%type,
		nr_seq_analise_pc		pls_conta.nr_seq_analise%type) FOR
	SELECT	distinct b.nr_sequencia nr_seq_conta_proc,
		coalesce(b.ie_via_acesso,'X') ie_via_acesso,
		coalesce(b.ie_via_acesso_imp,'X') ie_via_acesso_imp,
		b.ie_via_acesso_manual ie_via_acesso_manual,
		b.nr_seq_regra_via_acesso,
		b.ie_origem_conta
	from	pls_conta_proc_v 		a,
		pls_conta_proc_v  		b
	where	a.nr_seq_lote_conta 	= nr_seq_lote_pc
	and 	b.cd_guia_referencia 	= a.cd_guia_referencia
	and 	b.nr_seq_segurado 	= a.nr_seq_segurado
	and 	b.hr_inicio_proc 	= a.hr_inicio_proc
	and 	b.dt_procedimento_trunc = a.dt_procedimento_trunc
	and 	b.ie_status_conta 	not in ('F','C','Z')
	
union all

	SELECT	distinct b.nr_sequencia nr_seq_conta_proc,
		coalesce(b.ie_via_acesso,'X') ie_via_acesso,
		coalesce(b.ie_via_acesso_imp,'X') ie_via_acesso_imp,
		b.ie_via_acesso_manual ie_via_acesso_manual,
		b.nr_seq_regra_via_acesso,
		b.ie_origem_conta
	from	pls_conta_proc_v 		a,
		pls_conta_proc_v  		b
	where	a.nr_seq_protocolo 	= nr_seq_protocolo_pc
	and 	b.cd_guia_referencia 	= a.cd_guia_referencia
	and 	b.nr_seq_segurado 	= a.nr_seq_segurado
	and 	b.hr_inicio_proc 	= a.hr_inicio_proc
	and 	b.dt_procedimento_trunc = a.dt_procedimento_trunc
	and 	b.ie_status_conta 	not in ('F','C','Z')
	
union all

	select	distinct b.nr_sequencia nr_seq_conta_proc,
		coalesce(b.ie_via_acesso,'X') ie_via_acesso,
		coalesce(b.ie_via_acesso_imp,'X') ie_via_acesso_imp,
		b.ie_via_acesso_manual ie_via_acesso_manual,
		b.nr_seq_regra_via_acesso,
		b.ie_origem_conta
	from	pls_conta_proc_v 		a,
		pls_conta_proc_v  		b,
		pls_cta_lote_proc_conta 	c		
        where  	c.nr_seq_lote_processo 	= nr_seq_lote_processo_pc
	and	a.nr_seq_conta 		= c.nr_seq_conta
	and 	b.cd_guia_referencia 	= a.cd_guia_referencia
	and 	b.nr_seq_segurado 	= a.nr_seq_segurado
	and 	b.hr_inicio_proc 	= a.hr_inicio_proc
	and 	b.dt_procedimento_trunc = a.dt_procedimento_trunc
	and 	b.ie_status_conta 	not in ('F','C','Z')
	
union all

	select	distinct b.nr_sequencia nr_seq_conta_proc,
		coalesce(b.ie_via_acesso,'X') ie_via_acesso,
		coalesce(b.ie_via_acesso_imp,'X') ie_via_acesso_imp,
		b.ie_via_acesso_manual ie_via_acesso_manual,
		b.nr_seq_regra_via_acesso,
		b.ie_origem_conta
	from	pls_conta_proc_v 		a,
		pls_conta_proc_v  		b
	where	a.nr_seq_conta 		= nr_seq_conta_pc
	and	coalesce(nr_seq_conta_proc_pc::text, '') = ''
	and 	b.cd_guia_referencia 	= a.cd_guia_referencia
	and 	b.nr_seq_segurado 	= a.nr_seq_segurado
	and 	b.hr_inicio_proc 	= a.hr_inicio_proc
	and 	b.dt_procedimento_trunc = a.dt_procedimento_trunc
	and 	b.ie_status_conta 	not in ('F','C','Z')
	
union all

	select	distinct b.nr_sequencia nr_seq_conta_proc,
		coalesce(b.ie_via_acesso,'X') ie_via_acesso,
		coalesce(b.ie_via_acesso_imp,'X') ie_via_acesso_imp,
		b.ie_via_acesso_manual ie_via_acesso_manual,
		b.nr_seq_regra_via_acesso,
		b.ie_origem_conta
	from	pls_conta_proc_v 		a,
		pls_conta_proc_v  		b
        where  	a.nr_sequencia 		= nr_seq_conta_proc_pc
	and 	b.cd_guia_referencia 	= a.cd_guia_referencia
	and 	b.nr_seq_segurado 	= a.nr_seq_segurado
	and 	b.hr_inicio_proc 	= a.hr_inicio_proc
	and 	b.dt_procedimento_trunc = a.dt_procedimento_trunc
	and 	b.ie_status_conta 	not in ('F','C','Z')
	
union all

	select	distinct b.nr_sequencia nr_seq_conta_proc,
		coalesce(b.ie_via_acesso,'X') ie_via_acesso,
		coalesce(b.ie_via_acesso_imp,'X') ie_via_acesso_imp,
		b.ie_via_acesso_manual ie_via_acesso_manual,
		b.nr_seq_regra_via_acesso,
		b.ie_origem_conta
	from	pls_conta_proc_v 		a,
		pls_conta_proc_v  		b
        where  	a.nr_seq_analise	= nr_seq_analise_pc
	and 	b.cd_guia_referencia 	= a.cd_guia_referencia
	and 	b.nr_seq_segurado 	= a.nr_seq_segurado
	and 	b.hr_inicio_proc 	= a.hr_inicio_proc
	and 	b.dt_procedimento_trunc = a.dt_procedimento_trunc
	and 	b.ie_status_conta 	not in ('F','C','Z');
	
BEGIN

i := 0;

-- Obtem o controle padrao da quantidade de registros que sera enviada a cada vez para o banco de dados
qt_registro_transacao_w := pls_util_cta_pck.qt_registro_transacao_w;

-- Verifica se o sistema devera deixar em branco o campo da via de acesso do procedimento caso nao encontre uma regra de via de acesso compativel
select	ie_via_acesso_regra
into STRICT	ie_via_acesso_regra_w
from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));

-- Cursor de procedimentos
for r_C01_w in C01(nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_analise_p) loop				
	ie_limpa_w := 'N';
	
	-- sempre que tiver o campo NR_SEQ_REGRA_VIA_ACESSO informado significa que ja houve um vinculo de regra e sempre deve ser zerado
	if (r_C01_w.nr_seq_regra_via_acesso IS NOT NULL AND r_C01_w.nr_seq_regra_via_acesso::text <> '') then
		ie_limpa_w := 'S';
	elsif (ie_via_acesso_regra_w = 'S') then
		-- se cair aqui significa que nunca houve vinculo de regra de via de acesso ao item			
		if	(r_C01_w.ie_origem_conta = 'E') then -- 'E' = Importacao XML / TISS	
			if (r_C01_w.ie_via_acesso = r_C01_w.ie_via_acesso_imp) and (not r_C01_w.ie_via_acesso_manual = 'S') then
				ie_limpa_w := 'S';
			end if;
		end if;
	end if;		
	
	if (r_C01_w.ie_via_acesso	= 'X') then
		ie_limpa_w := 'S';
	end if;
	
	if (ie_limpa_w = 'S') then	
		nr_seq_conta_proc_table_w(i) := r_C01_w.nr_seq_conta_proc;	
		
		if (i >= qt_registro_transacao_w) then			
			-- Limpa os dados referentes a via de acesso dos procedimentos
			CALL pls_regra_via_acesso_pck.pls_limpa_via_acesso_proc(nr_seq_conta_proc_table_w);
			
			-- Limpa a variavel table
			nr_seq_conta_proc_table_w.delete;
			
			i := 0;
		else
			i := i + 1;
		end if;			
	end if;
end loop;	

-- Caso sobre algum procedimento dentro das tables, estes tambem devem seus dados limpados
CALL pls_regra_via_acesso_pck.pls_limpa_via_acesso_proc(nr_seq_conta_proc_table_w);	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_via_acesso_pck.pls_define_limpa_via_acesso ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_analise_p pls_conta.nr_seq_analise%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;