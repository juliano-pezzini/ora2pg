-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_preco_beneficiario_pck.verificar_regra_apropriacao (nr_seq_plano_p pls_plano.nr_sequencia%type, nr_seq_tabela_p pls_tabela_preco.nr_sequencia%type, nr_seq_classif_dependencia_p pls_classif_dependencia.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_preco_p pls_segurado_preco.dt_reajuste%type, dt_contratacao_p pls_segurado.dt_contratacao%type) RETURNS bigint AS $body$
DECLARE


nr_seq_regra_aprop_w	pls_regra_apropriacao.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_seq_regra_aprop
	from (	SELECT	nr_sequencia	nr_seq_regra_aprop,
			nr_seq_classif_dependencia
		from	pls_regra_apropriacao
		where	nr_seq_plano			= nr_seq_plano_p
		and	nr_seq_tabela			= nr_seq_tabela_p
		and	nr_seq_contrato			= nr_seq_contrato_p
		and	((nr_seq_classif_dependencia	= nr_seq_classif_dependencia_p) or (coalesce(nr_seq_classif_dependencia::text, '') = ''))
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	dt_preco_p between dt_inicio_vigencia and fim_mes(coalesce(dt_fim_vigencia,dt_preco_p))
		and	dt_preco_p >= dt_contratacao_p
		
union all

		select	nr_sequencia	nr_seq_regra_aprop,
			nr_seq_classif_dependencia
		from	pls_regra_apropriacao
		where	nr_seq_plano			= nr_seq_plano_p
		and	nr_seq_tabela			= nr_seq_tabela_p
		and	nr_seq_contrato			= nr_seq_contrato_p
		and	((nr_seq_classif_dependencia	= nr_seq_classif_dependencia_p) or (coalesce(nr_seq_classif_dependencia::text, '') = ''))
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	dt_preco_p between trunc(dt_inicio_vigencia,'month') and fim_mes(coalesce(dt_fim_vigencia,dt_preco_p))
		and	dt_preco_p < dt_contratacao_p
	) alias15
	order by
		coalesce(nr_seq_classif_dependencia, 0);

BEGIN

for r_c01_w in c01 loop
	begin
	nr_seq_regra_aprop_w	:= r_c01_w.nr_seq_regra_aprop;
	end;
end loop;

return nr_seq_regra_aprop_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_preco_beneficiario_pck.verificar_regra_apropriacao (nr_seq_plano_p pls_plano.nr_sequencia%type, nr_seq_tabela_p pls_tabela_preco.nr_sequencia%type, nr_seq_classif_dependencia_p pls_classif_dependencia.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_preco_p pls_segurado_preco.dt_reajuste%type, dt_contratacao_p pls_segurado.dt_contratacao%type) FROM PUBLIC;