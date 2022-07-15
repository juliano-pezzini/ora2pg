-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_estorna_movto_conjunto ( nr_seq_lote_transf_p bigint) AS $body$
DECLARE


nr_seq_movto_conj_w		bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_movto_conj_w
from	cm_conjunto_movto
where	nr_seq_lote_transf = nr_seq_lote_transf_p;

if (nr_seq_movto_conj_w > 0) then
	begin

	delete
	from	cm_conjunto_movto
	where	nr_sequencia = nr_seq_movto_conj_w;

	end;
end if;

/* Não deve ter commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_estorna_movto_conjunto ( nr_seq_lote_transf_p bigint) FROM PUBLIC;

