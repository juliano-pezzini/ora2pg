-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_att_contrato_operadora () AS $body$
DECLARE


nr_seq_contrato_w	bigint;
cd_estabelecimento_w	smallint;
nr_seq_operadora_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_estabelecimento
	from	pls_contrato;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_contrato_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_operadora_w
	from	pls_outorgante
	where	cd_estabelecimento	= cd_estabelecimento_w;


	update	pls_contrato
	set	nr_seq_operadora = nr_seq_operadora_w
	where	nr_sequencia	= nr_seq_contrato_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_att_contrato_operadora () FROM PUBLIC;
