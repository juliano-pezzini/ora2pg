-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_ajustar_carencia_benef_int ( nr_seq_intercambio_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
dt_inclusao_operadora_w		timestamp;
nr_seq_carencia_w		bigint;
dt_fim_carencia_w		timestamp;
qt_dias_carencias_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	nr_seq_intercambio	= nr_seq_intercambio_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_carencia
	where	nr_seq_segurado	= nr_seq_segurado_w;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	dt_inclusao_operadora
	into STRICT	dt_inclusao_operadora_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;

	update	pls_segurado
	set	dt_contratacao	= dt_inclusao_operadora_w,
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_segurado_w;

	open C02;
	loop
	fetch C02 into
		nr_seq_carencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	dt_fim_vigencia
		into STRICT	dt_fim_carencia_w
		from	pls_carencia
		where	nr_sequencia	= nr_seq_carencia_w;

		qt_dias_carencias_w	:= dt_fim_carencia_w - dt_inclusao_operadora_w;

		update	pls_carencia
		set	qt_dias		= qt_dias_carencias_w,
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_carencia_w;

		end;
	end loop;
	close C02;
	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_ajustar_carencia_benef_int ( nr_seq_intercambio_p bigint, nm_usuario_p text) FROM PUBLIC;
