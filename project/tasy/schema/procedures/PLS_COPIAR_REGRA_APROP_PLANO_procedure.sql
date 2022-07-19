-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_regra_aprop_plano ( nr_seq_tabela_origem_p bigint, nr_seq_tabela_p bigint, nr_seq_contrato_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_apropriacao_w	pls_regra_apropriacao.nr_sequencia%type;
nr_seq_plano_w		pls_plano.nr_sequencia%type;
nr_seq_preco_w		pls_plano_preco.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_classif_dependencia,
		dt_inicio_vigencia,
		dt_fim_vigencia
	from	pls_regra_apropriacao
	where	nr_seq_tabela_plano	= nr_seq_tabela_origem_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_fim_vigencia,clock_timestamp()) >= clock_timestamp();

C02 CURSOR(	nr_seq_apropriacao_pc	pls_regra_apropriacao.nr_sequencia%type) FOR
	SELECT	nr_seq_preco,
		ie_permite_reajustar,
		nr_seq_centro_apropriacao,
		vl_apropriacao,
		tx_apropriacao
	from	pls_regra_apropriacao_item
	where	nr_seq_apropriacao	= nr_seq_apropriacao_pc;
BEGIN

select	max(nr_seq_plano)
into STRICT	nr_seq_plano_w
from	pls_tabela_preco
where	nr_sequencia	= nr_seq_tabela_origem_p;

for r_c01_w in C01 loop
	select	nextval('pls_regra_apropriacao_seq')
	into STRICT	nr_seq_apropriacao_w
	;

	insert	into	pls_regra_apropriacao(	nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_contrato,
			nr_seq_plano,
			nr_seq_tabela,
			nr_seq_classif_dependencia,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			nm_usuario_liberacao,
			dt_liberacao)
		values (	nr_seq_apropriacao_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_contrato_p,
			nr_seq_plano_w,
			nr_seq_tabela_p,
			r_c01_w.nr_seq_classif_dependencia,
			r_c01_w.dt_inicio_vigencia,
			r_c01_w.dt_fim_vigencia,
			nm_usuario_p,
			clock_timestamp());

	for r_c02_w in C02(r_c01_w.nr_sequencia) loop
		select	max(nr_sequencia)
		into STRICT	nr_seq_preco_w
		from	pls_plano_preco
		where	nr_seq_tabela	= nr_seq_tabela_p
		and	nr_seq_preco_origem	= r_c02_w.nr_seq_preco;

		insert	into	pls_regra_apropriacao_item(	nr_sequencia,
				nr_seq_apropriacao,
				ie_permite_reajustar,
				nr_seq_centro_apropriacao,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_preco,
				vl_apropriacao,
				tx_apropriacao)
			values (	nextval('pls_regra_apropriacao_item_seq'),
				nr_seq_apropriacao_w,
				r_c02_w.ie_permite_reajustar,
				r_c02_w.nr_seq_centro_apropriacao,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_preco_w,
				r_c02_w.vl_apropriacao,
				r_c02_w.tx_apropriacao);
	end loop;
end loop;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_regra_aprop_plano ( nr_seq_tabela_origem_p bigint, nr_seq_tabela_p bigint, nr_seq_contrato_p bigint, nm_usuario_p text) FROM PUBLIC;

