-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_dt_limite_int ( nm_usuario_p text) AS $body$
DECLARE


nr_seq_prestador_w	bigint;
dt_limite_integracao_w	smallint;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_limite_integracao
	from	pls_prestador
	order by nr_sequencia;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_prestador_w,
	dt_limite_integracao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (dt_limite_integracao_w IS NOT NULL AND dt_limite_integracao_w::text <> '') then
		insert into pls_regra_prest_integracao(dt_atualizacao, dt_atualizacao_nrec, dt_limite_integracao,
			ie_referencia, ie_situacao, nm_usuario,
			nm_usuario_nrec, nr_seq_prestador, nr_sequencia)
		values (clock_timestamp(), clock_timestamp(), dt_limite_integracao_w,
			'P', 'A', nm_usuario_p,
			 nm_usuario_p, nr_seq_prestador_w, nextval('pls_regra_prest_integracao_seq'));
	end if;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_dt_limite_int ( nm_usuario_p text) FROM PUBLIC;

