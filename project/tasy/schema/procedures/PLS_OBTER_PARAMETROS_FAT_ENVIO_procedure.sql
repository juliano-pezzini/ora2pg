-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_parametros_fat_envio ( nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, nr_seq_regra_p INOUT bigint) AS $body$
DECLARE


nr_seq_regra_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_parametros_fat_envio
	where	((nr_seq_contrato = nr_seq_contrato_p) or (coalesce(nr_seq_contrato::text, '') = ''))
	and	((nr_seq_intercambio = nr_seq_intercambio_p) or (coalesce(nr_seq_intercambio::text, '') = ''));


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	null;
	end;
end loop;
close C01;

nr_seq_regra_p	:= nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_parametros_fat_envio ( nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, nr_seq_regra_p INOUT bigint) FROM PUBLIC;
