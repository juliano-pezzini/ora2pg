-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_periodo_pgto ( nr_seq_prestador_p bigint, dt_mes_competencia_p timestamp, ie_tipo_guia_p text, nr_seq_regra_p INOUT bigint, nr_seq_periodo_p INOUT bigint) AS $body$
DECLARE


nr_seq_classificacao_w		bigint;
nr_seq_regra_w 			bigint;
nr_seq_periodo_w		bigint;
nr_dia_limite_w			bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_periodo_pgto
	from	pls_conta_integracao_pgto	a
	where	a.ie_situacao		= 'A'
	and	((coalesce(a.nr_seq_classificacao,0) = 0) or (coalesce(a.nr_seq_classificacao,0) = nr_seq_classificacao_w))
	and	((coalesce(to_char(a.dt_referencia),'X') = 'X') or (trunc(dt_mes_competencia_p) <= trunc(a.dt_referencia)))
	and	((coalesce(ie_tipo_guia,'X') = 'X') or (coalesce(ie_tipo_guia,'X') = ie_tipo_guia_p))
	order by a.dt_referencia desc,
		 coalesce(a.nr_seq_classificacao,0),
		 coalesce(ie_tipo_guia,'X');


BEGIN
nr_seq_classificacao_w := pls_obter_dados_prestador(nr_seq_prestador_p, 'NRCLA');

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	nr_seq_periodo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

nr_seq_regra_p 		:= nr_seq_regra_w;
nr_seq_periodo_p	:= nr_seq_periodo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_periodo_pgto ( nr_seq_prestador_p bigint, dt_mes_competencia_p timestamp, ie_tipo_guia_p text, nr_seq_regra_p INOUT bigint, nr_seq_periodo_p INOUT bigint) FROM PUBLIC;
