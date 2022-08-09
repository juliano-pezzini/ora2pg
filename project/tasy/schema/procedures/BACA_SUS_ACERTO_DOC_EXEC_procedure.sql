-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_sus_acerto_doc_exec () AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_LOTE_w		varchar(20);
IE_DOC_EXECUTOR_w	smallint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	procedimento_paciente
	where	ie_origem_proced	= 7
	and	coalesce(IE_DOC_EXECUTOR::text, '') = '';


BEGIN

open	c01;
loop
fetch	c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	max(NR_LOTE)
	into STRICT	nr_lote_w
	from	sus_aih_opm
	where	nr_seq_procedimento	= nr_sequencia_w;

	if (nr_lote_w IS NOT NULL AND nr_lote_w::text <> '') and (upper(substr(nr_lote_w, length(nr_lote_w) - 1, length(nr_lote_w))) = 'F8') then
		IE_DOC_EXECUTOR_w	:= 3;
	else
		IE_DOC_EXECUTOR_w	:= 5;
	end if;

	update	procedimento_paciente
	set	IE_DOC_EXECUTOR		= IE_DOC_EXECUTOR_w
	where	nr_sequencia		= nr_sequencia_w;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_sus_acerto_doc_exec () FROM PUBLIC;
