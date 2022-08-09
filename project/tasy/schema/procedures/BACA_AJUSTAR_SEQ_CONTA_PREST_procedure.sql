-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_seq_conta_prest () AS $body$
DECLARE


cd_cgc_w		varchar(14);
cd_pessoa_fisica_w	varchar(10);
cd_banco_w		integer;
cd_agencia_bancaria_w	varchar(8);
nr_conta_w		varchar(20);
nr_sequencia_w		bigint;
nr_seq_prest_pagto_w	bigint;

C01 CURSOR FOR
	SELECT	cd_cgc,
		cd_pessoa_fisica,
		cd_banco,
		cd_agencia_bancaria,
		nr_conta,
		nr_sequencia
	from	pls_prestador_pagto
	where	(cd_banco IS NOT NULL AND cd_banco::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	cd_cgc_w,
	cd_pessoa_fisica_w,
	cd_banco_w,
	cd_agencia_bancaria_w,
	nr_conta_w,
	nr_seq_prest_pagto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	pessoa_juridica_conta
		where	cd_cgc			= cd_cgc_w
		and	cd_banco		= cd_banco_w
		and	cd_agencia_bancaria	= cd_agencia_bancaria_w
		and	nr_conta		= nr_conta_w;

		update	pls_prestador_pagto
		set	nr_seq_pessoa_jur_conta	= nr_sequencia_w
		where	nr_sequencia		= nr_seq_prest_pagto_w;
	else
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	pessoa_fisica_conta
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	cd_banco		= cd_banco_w
		and	cd_agencia_bancaria	= cd_agencia_bancaria_w
		and	nr_conta		= nr_conta_w;

		update	pls_prestador_pagto
		set	nr_seq_pessoa_fisica_conta	= nr_sequencia_w
		where	nr_sequencia			= nr_seq_prest_pagto_w;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_seq_conta_prest () FROM PUBLIC;
