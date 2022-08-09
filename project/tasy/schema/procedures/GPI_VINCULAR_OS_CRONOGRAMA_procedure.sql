-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_vincular_os_cronograma ( nr_sequencia_p bigint ,nr_seq_ordem_p bigint,ie_operacao_p text) AS $body$
BEGIN

	if (upper(ie_operacao_p) = 'V') then

		update gpi_cronograma
		set    nr_seq_ordem = nr_seq_ordem_p
		where  nr_sequencia = nr_sequencia_p;

	else
		update gpi_cronograma
		set    nr_seq_ordem  = NULL
		where  nr_sequencia = nr_sequencia_p;

	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_vincular_os_cronograma ( nr_sequencia_p bigint ,nr_seq_ordem_p bigint,ie_operacao_p text) FROM PUBLIC;
