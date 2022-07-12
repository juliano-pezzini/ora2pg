-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_marcado_diag_proc ( nr_seq_diag_doenca_p bigint, nr_seq_proc_pac_p bigint, nr_cirurgia_p bigint, nm_tabela_p text) RETURNS bigint AS $body$
DECLARE


retorno_w	cirurgia_descr_relevante.nr_sequencia%type;


BEGIN

	if (nm_tabela_p = 'DIAGNOSTICO_DOENCA') then
		select	coalesce(max(nr_sequencia), 0)
		into STRICT	retorno_w
		from	cirurgia_descr_relevante
		where	nr_seq_diag_doenca = nr_seq_diag_doenca_p
		and		nr_cirurgia = nr_cirurgia_p;
	end if;

	if (nm_tabela_p = 'PROCEDIMENTO_PAC_MEDICO') then
		select	coalesce(max(nr_sequencia), 0)
		into STRICT	retorno_w
		from	cirurgia_descr_relevante
		where	nr_seq_proc_pac = nr_seq_proc_pac_p
		and		nr_cirurgia = nr_cirurgia_p;
	end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_marcado_diag_proc ( nr_seq_diag_doenca_p bigint, nr_seq_proc_pac_p bigint, nr_cirurgia_p bigint, nm_tabela_p text) FROM PUBLIC;

