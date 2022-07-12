-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_sib_mov_alteracao_pck.obter_alteracoes ( nr_seq_movimento_p pls_sib_movimento.nr_sequencia%type) RETURNS SETOF T_MOVIMENTO_ALTERACOES AS $body$
DECLARE


t_movimento_alteracoes_row_w	t_movimento_alteracoes_row;


C01 CURSOR(	nr_seq_movimento_pc	pls_sib_movimento.nr_sequencia%type) FOR
	SELECT	'1' cd_campo,
		'Nome' ds_campo,
		a.nm_beneficiario valor_anterior,
		b.nm_beneficiario valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	SELECT	'8' cd_campo,
		'Código beneficiário' ds_campo,
		a.cd_beneficiario valor_anterior,
		b.cd_beneficiario valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'4' cd_campo,
		'CPF' ds_campo,
		a.nr_cpf valor_anterior,
		b.nr_cpf valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'36' cd_campo,
		'Declaração nascido vivo' ds_campo,
		a.nr_dn valor_anterior,
		b.nr_dn valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'5' cd_campo,
		'Pis/Pasep' ds_campo,
		a.nr_pis_pasep valor_anterior,
		b.nr_pis_pasep valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'7' cd_campo,
		'Cartão nacional SUS' ds_campo,
		a.nr_cns valor_anterior,
		b.nr_cns valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'3' cd_campo,
		'Sexo' ds_campo,
		a.cd_sexo valor_anterior,
		b.cd_sexo valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'2' cd_campo,
		'Data de nascimento' ds_campo,
		CASE WHEN coalesce(a.dt_nascimento::text, '') = '' THEN ''  ELSE to_char(a.dt_nascimento,'dd/mm/yyyy') END  valor_anterior,
		CASE WHEN coalesce(b.dt_nascimento::text, '') = '' THEN ''  ELSE to_char(b.dt_nascimento,'dd/mm/yyyy') END  valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'31' cd_campo,
		'Data de cancelamento' ds_campo,
		CASE WHEN coalesce(a.dt_cancelamento::text, '') = '' THEN ''  ELSE to_char(a.dt_cancelamento,'dd/mm/yyyy') END  valor_anterior,
		CASE WHEN coalesce(b.dt_cancelamento::text, '') = '' THEN ''  ELSE to_char(b.dt_cancelamento,'dd/mm/yyyy') END  valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'20' cd_campo,
		'Data de reativação' ds_campo,
		CASE WHEN coalesce(a.dt_reativacao::text, '') = '' THEN ''  ELSE to_char(a.dt_reativacao,'dd/mm/yyyy') END  valor_anterior,
		CASE WHEN coalesce(b.dt_reativacao::text, '') = '' THEN ''  ELSE to_char(b.dt_reativacao,'dd/mm/yyyy') END  valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'32' cd_campo,
		'Motivo de cancelamento' ds_campo,
		a.cd_motivo_cancelamento valor_anterior,
		b.cd_motivo_cancelamento valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'6' cd_campo,
		'Nome da mãe' ds_campo,
		a.nm_mae valor_anterior,
		b.nm_mae valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'18' cd_campo,
		'Código beneficiário titular' ds_campo,
		a.cd_beneficiario_titular valor_anterior,
		b.cd_beneficiario_titular valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'13' cd_campo,
		'Relação dependência' ds_campo,
		to_char(a.cd_relacao_dependencia) valor_anterior,
		to_char(b.cd_relacao_dependencia) valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'12' cd_campo,
		'Data de contratação' ds_campo,
		CASE WHEN coalesce(a.dt_contratacao::text, '') = '' THEN ''  ELSE to_char(a.dt_contratacao,'dd/mm/yyyy') END  valor_anterior,
		CASE WHEN coalesce(b.dt_contratacao::text, '') = '' THEN ''  ELSE to_char(b.dt_contratacao,'dd/mm/yyyy') END  valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'9' cd_campo,
		'Código plano ANS' ds_campo,
		a.nr_plano_ans valor_anterior,
		b.nr_plano_ans valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'10' cd_campo,
		'Código plano SCPA' ds_campo,
		a.nr_plano_operadora valor_anterior,
		b.nr_plano_operadora valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'11' cd_campo,
		'Código plano portabilidade' ds_campo,
		a.nr_plano_portabilidade valor_anterior,
		b.nr_plano_portabilidade valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'14' cd_campo,
		'CPT' ds_campo,
		to_char(a.ie_cpt) valor_anterior,
		to_char(b.ie_cpt) valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'15' cd_campo,
		'Itens excluídos da cobertura' ds_campo,
		to_char(a.ie_itens_excluidos_cobertura) valor_anterior,
		to_char(b.ie_itens_excluidos_cobertura) valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'16' cd_campo,
		'CNPJ' ds_campo,
		a.nr_cnpj valor_anterior,
		b.nr_cnpj valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'17' cd_campo,
		'CEI' ds_campo,
		a.nr_cei valor_anterior,
		b.nr_cei valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'37' cd_campo,
		'CAEPF' ds_campo,
		a.cd_caepf valor_anterior,
		b.cd_caepf valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'28' cd_campo,
		'Reside no exterior' ds_campo,
		to_char(a.ie_reside_exterior) valor_anterior,
		to_char(b.ie_reside_exterior) valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'21' cd_campo,
		'Tipo de endereço' ds_campo,
		a.ie_tipo_endereco valor_anterior,
		b.ie_tipo_endereco valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'27' cd_campo,
		'CEP' ds_campo,
		a.cd_cep valor_anterior,
		b.cd_cep valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'22' cd_campo,
		'Logradouro' ds_campo,
		a.ds_logradouro valor_anterior,
		b.ds_logradouro valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'33' cd_campo,
		'Nº Logradouro' ds_campo,
		a.nr_logradouro valor_anterior,
		b.nr_logradouro valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'34' cd_campo,
		'Complemento' ds_campo,
		a.ds_complemento valor_anterior,
		b.ds_complemento valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'35' cd_campo,
		'Bairro' ds_campo,
		a.ds_bairro valor_anterior,
		b.ds_bairro valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'26' cd_campo,
		'Município logradouro' ds_campo,
		a.cd_municipio_ibge valor_anterior,
		b.cd_municipio_ibge valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc
	
union all

	select	'29' cd_campo,
		'Município residência' ds_campo,
		a.cd_municipio_ibge_resid valor_anterior,
		b.cd_municipio_ibge_resid valor_novo
	from	pls_sib_movimento_ant a,
		pls_sib_movimento b
	where	b.nr_sequencia	= a.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_movimento_pc;

BEGIN

for r_c01_w in C01(nr_seq_movimento_p) loop
	begin
	
	if (r_c01_w.valor_anterior <> r_c01_w.valor_novo) or ((r_c01_w.valor_anterior IS NOT NULL AND r_c01_w.valor_anterior::text <> '') and coalesce(r_c01_w.valor_novo::text, '') = '') or (coalesce(r_c01_w.valor_anterior::text, '') = '' and (r_c01_w.valor_novo IS NOT NULL AND r_c01_w.valor_novo::text <> '')) then
		t_movimento_alteracoes_row_w.cd_campo		:= r_c01_w.cd_campo;
		t_movimento_alteracoes_row_w.ds_campo		:= r_c01_w.ds_campo;
		t_movimento_alteracoes_row_w.ds_valor_anterior	:= r_c01_w.valor_anterior;
		t_movimento_alteracoes_row_w.ds_valor_novo	:= r_c01_w.valor_novo;
		
		RETURN NEXT t_movimento_alteracoes_row_w;
	end if;
	
	end;
end loop; --C01
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_sib_mov_alteracao_pck.obter_alteracoes ( nr_seq_movimento_p pls_sib_movimento.nr_sequencia%type) FROM PUBLIC;
