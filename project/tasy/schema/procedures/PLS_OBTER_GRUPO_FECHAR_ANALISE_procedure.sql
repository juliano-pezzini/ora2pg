-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_grupo_fechar_analise (nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nr_seq_regra_p INOUT bigint, nr_seq_grupo_p INOUT bigint) AS $body$
DECLARE


nr_seq_grupo_w		bigint;
nr_seq_regra_w 		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_grupo
	from	pls_fim_analise_conta
	where	cd_estabelecimento = cd_estabelecimento_p
	and	ie_situacao = 'A'
	order by nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	nr_seq_grupo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

nr_seq_regra_p := nr_seq_regra_w;
nr_seq_grupo_p := nr_seq_grupo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_grupo_fechar_analise (nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nr_seq_regra_p INOUT bigint, nr_seq_grupo_p INOUT bigint) FROM PUBLIC;

