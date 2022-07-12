-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- verifica todas as ocorr_ncias antigas que est_o habilitadas para o cliente



CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.verifica_ocorrencia ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

			
ie_gerar_toda_conta_w	varchar(1);
ie_origem_proced_w	procedimento.ie_origem_proced%type;
cd_procedimento_w	procedimento.cd_procedimento%type;
nr_seq_material_w	pls_conta_mat.nr_seq_material%type;
nr_seq_prestador_w	pls_conta.nr_seq_prestador%type;
nr_seq_regra_nao_usa_w	pls_prestador_consistencia.nr_sequencia%type;
dt_procedimento_w	pls_conta_proc.dt_procedimento%type;
ie_conta_intercambio_w	varchar(1);

c_contas_ocor CURSOR(	nr_seq_lote_pc		pls_lote_protocolo_conta.nr_sequencia%type,
			nr_seq_lote_processo_pc	pls_cta_lote_processo.nr_sequencia%type,
			nr_seq_protocolo_pc	pls_protocolo_conta.nr_sequencia%type,
			nr_seq_conta_pc		pls_conta.nr_sequencia%type) FOR
-- feito com union por motivo de performance, antes era feito em um select s_ com OR e em bases grandes apresentava problemas de performance

-- n_o meche em ocorrencias de contas que est_o canceladas ou fechadas

SELECT	a.nr_sequencia nr_seq_conta,
	a.nr_seq_segurado,
	a.ie_tipo_guia,
	pls_obter_produto_benef(b.nr_sequencia, a.dt_atendimento) as nr_seq_plano,
	CASE WHEN c.cd_cgc='' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pagador,
	a.nr_seq_tipo_atendimento,
	a.ie_origem_conta,
	a.nr_seq_congenere,
	a.ie_tipo_conta
from	pls_conta_v a,
	pls_segurado b,
	pls_contrato_pagador c
where	a.nr_seq_lote_conta = nr_seq_lote_pc
and	b.nr_sequencia = a.nr_seq_segurado
and	a.ie_status <> 'C'
and	a.ie_status <> 'F'
and	c.nr_sequencia = b.nr_seq_pagador

union all

SELECT	a.nr_sequencia nr_seq_conta,
	a.nr_seq_segurado,
	a.ie_tipo_guia,
	pls_obter_produto_benef(b.nr_sequencia, a.dt_atendimento) as nr_seq_plano,
	CASE WHEN c.cd_cgc='' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pagador,
	a.nr_seq_tipo_atendimento,
	a.ie_origem_conta,
	a.nr_seq_congenere,
	a.ie_tipo_conta
from	pls_conta_v a,
	pls_segurado b,
	pls_contrato_pagador c
where	a.nr_seq_protocolo = nr_seq_protocolo_pc
and	b.nr_sequencia = a.nr_seq_segurado
and	a.ie_status <> 'C'
and	a.ie_status <> 'F'
and	c.nr_sequencia = b.nr_seq_pagador

union all

select	a.nr_sequencia nr_seq_conta,
	a.nr_seq_segurado,
	a.ie_tipo_guia,
	pls_obter_produto_benef(b.nr_sequencia, a.dt_atendimento) as nr_seq_plano,
	CASE WHEN c.cd_cgc='' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pagador,
	a.nr_seq_tipo_atendimento,
	a.ie_origem_conta,
	a.nr_seq_congenere,
	a.ie_tipo_conta
from	pls_conta_v a,
	pls_segurado b,
	pls_contrato_pagador c
where	a.nr_sequencia = nr_seq_conta_pc
and	b.nr_sequencia = a.nr_seq_segurado
and	a.ie_status <> 'C'
and	a.ie_status <> 'F'
and	c.nr_sequencia = b.nr_seq_pagador

union all

select	a.nr_sequencia nr_seq_conta,
	a.nr_seq_segurado,
	a.ie_tipo_guia,
	pls_obter_produto_benef(b.nr_sequencia, a.dt_atendimento) as nr_seq_plano,
	CASE WHEN c.cd_cgc='' THEN 'PF'  ELSE 'PJ' END  ie_tipo_pagador,
	a.nr_seq_tipo_atendimento,
	a.ie_origem_conta,
	a.nr_seq_congenere,
	a.ie_tipo_conta
from	pls_conta_v a,
	pls_segurado b,
	pls_contrato_pagador c
where	exists (select	1
		from	pls_cta_lote_proc_conta p
		where	p.nr_seq_lote_processo = nr_seq_lote_processo_pc
		and	p.nr_seq_conta = a.nr_sequencia)
and	b.nr_sequencia = a.nr_seq_segurado
and	a.ie_status <> 'C'
and	a.ie_status <> 'F'
and	c.nr_sequencia = b.nr_seq_pagador;

BEGIN

--#D_cioAqui -> futuramente a rotina pls_atualizar_agrup_analise deve ser inutilizada e no lugar desta chamar a pls_atualizar_agrup_proc desta pck						

-- trata da organiza__o e hierarquia dos itens na tela (pr_-requisito para algumas valida__es)

pls_analise_cta_pck.pls_atualizar_agrup_proc(	nr_seq_lote_p, nr_seq_protocolo_p, null, nr_seq_conta_p,
						nm_usuario_p, cd_estabelecimento_p, 'C', 'N');
commit;

-- se for para gerar somente para algum item ou para a conta toda

if ((nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') or (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '')) then
	
	ie_origem_proced_w := null;
	cd_procedimento_w := null;
	dt_procedimento_w := null;
	nr_seq_material_w := null;
	ie_gerar_toda_conta_w := 'N';
	
	-- se o procedimento foi informado

	if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
		select	ie_origem_proced,
			cd_procedimento,
			dt_procedimento
		into STRICT	ie_origem_proced_w,
			cd_procedimento_w,
			dt_procedimento_w
		from	pls_conta_proc_v
		where	nr_sequencia = nr_seq_conta_proc_p;
	end if;
	
	-- se o material foi informado

	if (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
		select	nr_seq_material
		into STRICT	nr_seq_material_w
		from	pls_conta_mat
		where	nr_sequencia = nr_seq_conta_mat_p;
	end if;
else
	ie_gerar_toda_conta_w := 'S';
end if;

for c_contas_ocor_v in c_contas_ocor(	nr_seq_lote_p, nr_seq_lote_processo_p, nr_seq_protocolo_p, nr_seq_conta_p) loop
	
	-- se for conta de interc_mbio

	if (c_contas_ocor_v.ie_tipo_conta = 'I') then
		ie_conta_intercambio_w := 'I';
	else
		ie_conta_intercambio_w := 'N';
	end if;
	
	-- para buscar o tipo do prestador

	pls_obter_tipo_prest_consist(	c_contas_ocor_v.nr_seq_conta, nm_usuario_p,
				nr_seq_prestador_w, nr_seq_regra_nao_usa_w);
	-- gerar ocorr_ncia para a conta e seus itens

	CALL pls_gerar_ocorrencia(	c_contas_ocor_v.nr_seq_segurado, null, ie_gerar_toda_conta_w,
				c_contas_ocor_v.nr_seq_conta, nr_seq_conta_proc_p, nr_seq_conta_mat_p, 
				cd_procedimento_w, ie_origem_proced_w, nr_seq_material_w, 
				c_contas_ocor_v.ie_tipo_guia, c_contas_ocor_v.nr_seq_plano, 'C',
				null, c_contas_ocor_v.ie_tipo_pagador, nr_seq_prestador_w,
				c_contas_ocor_v.nr_seq_tipo_atendimento, 'I', dt_procedimento_w,
				c_contas_ocor_v.ie_origem_conta, nm_usuario_p, cd_estabelecimento_p,
				c_contas_ocor_v.nr_seq_congenere, ie_conta_intercambio_w, null,null,null);
	commit;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.verifica_ocorrencia ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;