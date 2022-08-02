-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_ajuste_cpt_carencia () AS $body$
DECLARE


nr_seq_tipo_carencia_w	bigint;
nr_seq_carencia_w	bigint;
ie_cpt_w		varchar(1);

C01 CURSOR FOR
	SELECT	nr_seq_tipo_carencia,
		nr_sequencia
	from	pls_carencia
	where	coalesce(ie_cpt::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_tipo_carencia_w,
	nr_seq_carencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	begin
	if (coalesce(nr_seq_tipo_carencia_w,0) = 0) then
		ie_cpt_w	:= 'N';
	else
		select	max(ie_cpt)
		into STRICT	ie_cpt_w
		from	pls_tipo_carencia
		where	nr_sequencia	= nr_seq_tipo_carencia_w;
	end if;

	update	pls_carencia
	set	ie_cpt	= ie_cpt_w
	where	nr_sequencia	= nr_seq_carencia_w;
	exception
	when others then
		null;
	end;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_ajuste_cpt_carencia () FROM PUBLIC;

