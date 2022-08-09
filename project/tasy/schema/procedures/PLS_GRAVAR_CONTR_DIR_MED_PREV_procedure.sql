-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_contr_dir_med_prev ( nr_seq_regra_p bigint) AS $body$
DECLARE


nr_contrato_w			bigint;
nr_seq_contrato_w		bigint;


BEGIN

select	max(nr_contrato)
into STRICT	nr_contrato_w
from	PLS_REGRA_DIREITO_MED_PREV
where	nr_sequencia	= nr_seq_regra_p;

if (coalesce(nr_contrato_w,0) <> 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_contrato_w
	from	pls_contrato
	where	nr_contrato	= nr_contrato_w;

	if (coalesce(nr_seq_contrato_w,0) <> 0) then
		update	PLS_REGRA_DIREITO_MED_PREV
		set	nr_seq_contrato	= nr_seq_contrato_w
		where	nr_sequencia	= nr_seq_regra_p;
	end if;
else
	update	PLS_REGRA_DIREITO_MED_PREV
	set	nr_seq_contrato	 = NULL
	where	nr_sequencia	= nr_seq_regra_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_contr_dir_med_prev ( nr_seq_regra_p bigint) FROM PUBLIC;
