-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desbloqueio_cheque (cd_estabelecimento_p bigint, dt_deposito_p timestamp, vl_cheque_p bigint, nr_seq_camara_deposito_p bigint, nr_seq_camara_cheque_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_desbloqueio_w		timestamp;
nr_seq_regra_w		bigint;
nr_seq_regra_valor_w	bigint;
qt_dia_desbloqueio_w	bigint;
qt_dia_util_w		bigint;

c01 CURSOR FOR
SELECT	nr_sequencia
from	regra_desbloqueio_cheque
where	cd_estabelecimento	= cd_estabelecimento_p
and	nr_seq_camara		= nr_seq_camara_deposito_p;

c02 CURSOR FOR
SELECT	nr_sequencia
from	regra_desbloq_valor
where	nr_seq_regra		= nr_seq_regra_w
and	vl_cheque_p		between vl_inicial and vl_final;

c03 CURSOR FOR
SELECT	qt_dia_desbloqueio
from	regra_desbloq_camara
where	nr_seq_camara		= nr_seq_camara_cheque_p
and	nr_seq_regra_valor	= nr_seq_regra_valor_w;


BEGIN

dt_desbloqueio_w		:= null;
if (dt_deposito_p IS NOT NULL AND dt_deposito_p::text <> '') then
	open c01;
	loop
	fetch c01 into
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		open c02;
		loop
		fetch c02 into
			nr_seq_regra_valor_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			open c03;
			loop
			fetch c03 into
				qt_dia_desbloqueio_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */

				qt_dia_util_w		:= 1;
				dt_desbloqueio_w		:= obter_proximo_dia_util(cd_estabelecimento_p, dt_deposito_p + 1);

				while(qt_dia_util_w < qt_dia_desbloqueio_w) loop

					dt_desbloqueio_w	:= dt_desbloqueio_w + 1;

					-- Identificar se o dia atual é dia útil
					if (obter_se_dia_util(dt_desbloqueio_w, cd_estabelecimento_p) = 'S') then
						qt_dia_util_w	:= qt_dia_util_w + 1;
					end if;

				end loop;


			end loop;
			close c03;

		end loop;
		close c02;

	end loop;
	close c01;
end if;

return	dt_desbloqueio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desbloqueio_cheque (cd_estabelecimento_p bigint, dt_deposito_p timestamp, vl_cheque_p bigint, nr_seq_camara_deposito_p bigint, nr_seq_camara_cheque_p bigint) FROM PUBLIC;

