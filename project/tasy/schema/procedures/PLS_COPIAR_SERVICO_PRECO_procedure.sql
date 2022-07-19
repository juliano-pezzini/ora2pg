-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_servico_preco ( nr_seq_prestador_p bigint, cd_edicao_amb_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into pls_regra_preco_proc(
	nr_sequencia, cd_area_procedimento, cd_especialidade,
	cd_grupo_proc, cd_procedimento, dt_atualizacao,
	dt_atualizacao_nrec, ie_origem_proced, nm_usuario,
	nm_usuario_nrec, nr_seq_prestador, cd_edicao_amb,
	cd_estabelecimento, dt_inicio_vigencia, ie_situacao,
	tx_ajuste_ch_honor, tx_ajuste_custo_oper, tx_ajuste_filme,
	tx_ajuste_geral, tx_ajuste_partic, vl_ch_custo_oper,
	vl_ch_honorarios, vl_filme, ie_tipo_tabela,
	cd_especialidade_prest, nr_seq_cbo_saude, ie_gerar_remido)
SELECT	nextval('pls_regra_preco_proc_seq'), cd_area_procedimento, cd_especialidade_proc,
	cd_grupo_proc, cd_procedimento, clock_timestamp(),
	clock_timestamp(), ie_origem_proced, nm_usuario_p,
	nm_usuario_nrec, nr_seq_prestador, cd_edicao_amb_p,
	1, clock_timestamp(), 1,
	1, 1, 1,
	1, 1, 1,
	1, 1, 'P',
	cd_especialidade, nr_seq_cbo_saude, 'N'
from	pls_prestador_proc
where	nr_seq_prestador	= nr_seq_prestador_p
and	cd_procedimento 	in (	SELECT	cd_procedimento
					from	preco_amb a,
						edicao_amb b
					where	b.cd_edicao_amb = cd_edicao_amb_p
					and	b.cd_edicao_amb = a.cd_edicao_amb);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_servico_preco ( nr_seq_prestador_p bigint, cd_edicao_amb_p bigint, nm_usuario_p text) FROM PUBLIC;

