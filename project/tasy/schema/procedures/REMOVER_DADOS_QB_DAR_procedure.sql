-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_dados_qb_dar (nr_seq_qb_dados_p bigint) AS $body$
BEGIN

	DELETE
	FROM QUERY_BUILDER_DISPLAY qbdi
	WHERE EXISTS (
				SELECT
					1 
				from
					query_builder_dados qbda 
				where
					qbdi.nm_tabela = qbda.nm_tabela
					and qbdi.cd_funcao = qbda.cd_funcao 
					and qbdi.nr_seq_objeto_schematic = qbda.nr_seq_objeto_schematic 
					and qbda.nr_sequencia = nr_seq_qb_dados_p
	);

    DELETE 
	FROM DAR_QUERY_CONDITIONS dqc
	WHERE EXISTS (
				SELECT
					1 
				from
					query_builder_dados qbda 
				where
					dqc.nm_tabela = qbda.nm_tabela
					and dqc.cd_funcao = qbda.cd_funcao 
					and dqc.nr_seq_objeto_schematic = qbda.nr_seq_objeto_schematic 
					and qbda.nr_sequencia = nr_seq_qb_dados_p
	);

    DELETE 
	FROM DAR_QUERY_FILTER_DATE dqfd
	WHERE EXISTS (
				SELECT
					1 
				from
					query_builder_dados qbda 
				where
					dqfd.nm_tabela = qbda.nm_tabela
					and dqfd.cd_funcao = qbda.cd_funcao 
					and dqfd.nr_seq_objeto_schematic = qbda.nr_seq_objeto_schematic 
					and qbda.nr_sequencia = nr_seq_qb_dados_p
	);

    DELETE FROM QUERY_BUILDER_DADOS WHERE NR_SEQUENCIA = nr_seq_qb_dados_p;

    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_dados_qb_dar (nr_seq_qb_dados_p bigint) FROM PUBLIC;

