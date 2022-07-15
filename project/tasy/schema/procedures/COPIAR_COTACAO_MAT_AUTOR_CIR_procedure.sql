-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_cotacao_mat_autor_cir ( nr_sequencia_autor_p bigint, nr_sequencia_mat_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_cgc_w		varchar(14);
nr_seq_marca_w		bigint;
nr_sequencia_w		bigint;
cd_condicao_pagamento_w bigint;

c01 CURSOR FOR
SELECT 	nr_sequencia
from 	material_autor_cirurgia
where	nr_seq_autorizacao	= nr_sequencia_autor_p
and 	nr_sequencia		<> nr_sequencia_mat_p;

c02 CURSOR FOR
SELECT 	a.cd_cgc,
	a.nr_seq_marca,
	a.cd_condicao_pagamento
from 	material_autor_cir_cot a
where	a.nr_sequencia		= nr_sequencia_mat_p
and	not exists (select 1
			from 	material_autor_cir_cot x
			where (x.cd_cgc	= a.cd_cgc or
				coalesce(a.cd_cgc::text, '') = '')
			and 	x.nr_sequencia	= nr_sequencia_w);


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	open c02;
	loop
	fetch c02 into
		cd_cgc_w,
		nr_seq_marca_w,
		cd_condicao_pagamento_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		insert into material_autor_cir_cot(nr_sequencia,
				cd_cgc,
				dt_atualizacao,
				nm_usuario,
				vl_cotado,
				vl_unitario_cotado,
				ie_aprovacao,
				cd_condicao_pagamento)
			values (nr_sequencia_w,
				cd_cgc_w,
				clock_timestamp(),
				nm_usuario_p,
				0,
				0,
				'N',
				cd_condicao_pagamento_w);

	end loop;
	close c02;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_cotacao_mat_autor_cir ( nr_sequencia_autor_p bigint, nr_sequencia_mat_p bigint, nm_usuario_p text) FROM PUBLIC;

