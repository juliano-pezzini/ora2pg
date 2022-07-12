-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ocor_imp_pck.obter_seq_ocorrencia ( nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE

nr_sequencia_w	pls_ocorrencia_imp.nr_sequencia%type;

BEGIN

-- Para procedimento

if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then

	select	max(a.nr_sequencia)
	into STRICT	nr_sequencia_w
	from	pls_ocorrencia_imp a
	where	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p
	and	a.nr_seq_conta		= nr_seq_conta_p
	and	a.nr_seq_conta_proc	= nr_seq_conta_proc_p;
-- Para material

elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then

	select	max(a.nr_sequencia)
	into STRICT	nr_sequencia_w
	from	pls_ocorrencia_imp a
	where	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p
	and	a.nr_seq_conta		= nr_seq_conta_p
	and	a.nr_seq_conta_mat	= nr_seq_conta_mat_p;
-- Para Conta

elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	select	max(a.nr_sequencia)
	into STRICT	nr_sequencia_w
	from	pls_ocorrencia_imp a
	where	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p
	and	a.nr_seq_conta		= nr_seq_conta_p
	and	a.ie_incidencia_ocor 	= 'C';
end if;

return nr_sequencia_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ocor_imp_pck.obter_seq_ocorrencia ( nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type) FROM PUBLIC;
