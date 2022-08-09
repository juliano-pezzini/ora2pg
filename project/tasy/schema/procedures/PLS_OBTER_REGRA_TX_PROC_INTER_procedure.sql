-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_regra_tx_proc_inter ( dados_conta_proc_p pls_cta_valorizacao_pck.dados_conta_proc, dados_segurado_p pls_cta_valorizacao_pck.dados_beneficiario, nr_seq_regra_p INOUT pls_regra_tx_proc_int.nr_sequencia%type, tx_item_p INOUT pls_regra_tx_proc_int.tx_procedimento%type) AS $body$
DECLARE


C01 CURSOR(	dados_conta_proc_pc		pls_cta_valorizacao_pck.dados_conta_proc,
		dados_segurado_pc		pls_cta_valorizacao_pck.dados_beneficiario,
		cd_especialidade_pc		especialidade_proc.cd_especialidade%type,
		nr_seq_grupo_rec_pc		grupo_receita.nr_sequencia%type) FOR
	SELECT	nr_seq_grupo_contrato,
		nr_seq_grupo_servico,
		nr_sequencia,
		tx_procedimento
	from	pls_regra_tx_proc_int
	where	((cd_procedimento 	= dados_conta_proc_pc.cd_procedimento and ie_origem_proced = dados_conta_proc_pc.ie_origem_proced) or (coalesce(cd_procedimento::text, '') = ''))
	and (coalesce(cd_especialidade::text, '') = '' or cd_especialidade 	= cd_especialidade_pc)
	and (coalesce(ie_tipo_intercambio::text, '') = '' or ie_tipo_intercambio	= 'A' or ie_tipo_intercambio = dados_segurado_pc.ie_tipo_intercambio)
	and (coalesce(ie_tipo_segurado::text, '') = '' or ie_tipo_segurado 	= dados_segurado_pc.ie_tipo_beneficiario)
	and (coalesce(ie_via_acesso::text, '') = '' or ie_via_acesso 	= dados_conta_proc_pc.ie_via_acesso)
	and (coalesce(nr_seq_intercambio::text, '') = '' or nr_seq_intercambio 	= dados_segurado_pc.nr_seq_intercambio)
	and (coalesce(nr_seq_grupo_rec::text, '') = '' or nr_seq_grupo_rec	= nr_seq_grupo_rec_pc)
	order by 
		coalesce(cd_procedimento,0) desc,
		coalesce(ie_origem_proced,0) desc,
		coalesce(cd_especialidade,0) desc,
		coalesce(nr_seq_intercambio,0) desc,
		coalesce(ie_tipo_intercambio,'X'),
		coalesce(ie_tipo_segurado,'X'),
		coalesce(ie_via_acesso,'X'),
		coalesce(nr_seq_grupo_rec,0) desc,
		coalesce(nr_seq_grupo_contrato,0) desc,
		coalesce(nr_seq_grupo_servico,0) desc;

nr_seq_grupo_rec_w		grupo_receita.nr_sequencia%type;
cd_especialidade_w		especialidade_proc.cd_especialidade%type;
nr_seq_regra_w			pls_regra_tx_proc_int.nr_sequencia%type;
tx_procedimento_w		pls_regra_tx_proc_int.tx_procedimento%type;
ie_valido_w			varchar(1) := 'N';

BEGIN

select	max(nr_seq_grupo_rec)
into STRICT	nr_seq_grupo_rec_w
from	procedimento
where	cd_procedimento = dados_conta_proc_p.cd_procedimento
and	ie_origem_proced = dados_conta_proc_p.ie_origem_proced;

if (dados_conta_proc_p.cd_procedimento IS NOT NULL AND dados_conta_proc_p.cd_procedimento::text <> '' AND dados_conta_proc_p.ie_origem_proced IS NOT NULL AND dados_conta_proc_p.ie_origem_proced::text <> '')then
	cd_especialidade_w := obter_dados_estrut_proc(dados_conta_proc_p.cd_procedimento, dados_conta_proc_p.ie_origem_proced,'C','E');
else
	cd_especialidade_w := null;
end if;

for r_C01_w in C01(dados_conta_proc_p, dados_segurado_p, cd_especialidade_w, nr_seq_grupo_rec_w) loop
	
	ie_valido_w := 'S';
	
	if (r_C01_w.nr_seq_grupo_contrato IS NOT NULL AND r_C01_w.nr_seq_grupo_contrato::text <> '') then
		ie_valido_w := pls_se_grupo_preco_contrato(r_C01_w.nr_seq_grupo_contrato, null, dados_segurado_p.nr_seq_intercambio);
	end if;
	
	if (r_C01_w.nr_seq_grupo_servico IS NOT NULL AND r_C01_w.nr_seq_grupo_servico::text <> '') and (ie_valido_w = 'S') then
		ie_valido_w := pls_se_grupo_preco_servico(r_C01_w.nr_seq_grupo_servico, dados_conta_proc_p.cd_procedimento, dados_conta_proc_p.ie_origem_proced);
	end if;
	
	if (ie_valido_w = 'S') then
		nr_seq_regra_w := r_C01_w.nr_sequencia;
		tx_procedimento_w := r_C01_w.tx_procedimento;
		
		exit;
	end if;
end loop;

nr_seq_regra_p	:= nr_seq_regra_w;
tx_item_p	:= tx_procedimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_regra_tx_proc_inter ( dados_conta_proc_p pls_cta_valorizacao_pck.dados_conta_proc, dados_segurado_p pls_cta_valorizacao_pck.dados_beneficiario, nr_seq_regra_p INOUT pls_regra_tx_proc_int.nr_sequencia%type, tx_item_p INOUT pls_regra_tx_proc_int.tx_procedimento%type) FROM PUBLIC;
