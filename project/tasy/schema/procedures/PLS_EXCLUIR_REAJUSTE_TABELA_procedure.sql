-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_reajuste_tabela ( nr_seq_reajuste_p bigint, dt_mes_inicio_p timestamp, dt_mes_final_p timestamp, ie_opcao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
	1 - Fim dia
	2 - Mês
	3- Ano
	4 - Reajuste
*/
BEGIN

if (ie_opcao_p	= 1) then
	delete from pls_reajuste_tabela
	where	nr_seq_reajuste	= nr_seq_reajuste_p
	and trunc(dt_inicio_vigencia)  between trunc(dt_mes_inicio_p) and trunc(dt_mes_final_p);
elsif (ie_opcao_p	= 2) then
	delete from pls_reajuste_tabela
	where	nr_seq_reajuste	= nr_seq_reajuste_p
	and trunc(dt_inicio_vigencia, 'month') = trunc(dt_mes_final_p, 'month');
elsif (ie_opcao_p	= 3) then
	delete from pls_reajuste_tabela
	where	nr_seq_reajuste	= nr_seq_reajuste_p
	and trunc(dt_inicio_vigencia, 'yyyy') = trunc(dt_mes_inicio_p, 'yyyy');
elsif (ie_opcao_p	= 4) then
	delete from pls_reajuste_tabela
	where	nr_seq_reajuste	= nr_seq_reajuste_p;

	CALL pls_excluir_reaj_copartic(nr_seq_reajuste_p);
	CALL pls_excluir_reaj_inscricao(nr_seq_reajuste_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_reajuste_tabela ( nr_seq_reajuste_p bigint, dt_mes_inicio_p timestamp, dt_mes_final_p timestamp, ie_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;
