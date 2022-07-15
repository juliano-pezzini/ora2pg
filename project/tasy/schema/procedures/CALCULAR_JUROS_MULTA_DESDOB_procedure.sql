-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_juros_multa_desdob (nr_titulo_p bigint, ie_considera_saldo_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
dt_vencimento_w		timestamp;
vl_juros_w		double precision	:= 0;
vl_multa_w		double precision	:= 0;

c01 CURSOR FOR
SELECT	nr_sequencia,
	dt_vencimento
from	titulo_receber_desdob
where	nr_titulo	= nr_titulo_p
order by dt_vencimento;


BEGIN

Open c01;
loop
fetch c01 into
	nr_sequencia_w,
	dt_vencimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	SELECT * FROM calcular_juro_multa_titulo(0, nr_titulo_p, dt_vencimento_w, ie_considera_saldo_p, 'N', vl_juros_w, vl_multa_w) INTO STRICT vl_juros_w, vl_multa_w;

	update	titulo_receber_desdob
	set	vl_saldo_juros	= vl_juros_w,
		vl_saldo_multa	= vl_multa_w,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_w;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_juros_multa_desdob (nr_titulo_p bigint, ie_considera_saldo_p text, nm_usuario_p text) FROM PUBLIC;

