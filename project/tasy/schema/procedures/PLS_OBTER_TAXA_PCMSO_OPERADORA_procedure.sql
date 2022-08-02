-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_taxa_pcmso_operadora ( dt_procedimento_p timestamp, nr_seq_congenere_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, pr_taxa_p INOUT bigint) AS $body$
DECLARE


pr_taxa_w			double precision	:= 0;

C01 CURSOR FOR
	SELECT	a.pr_taxa
	from	pls_regra_pcmso	a
	where	dt_procedimento_p	between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,dt_procedimento_p)
	and	a.nr_seq_congenere	= nr_seq_congenere_p
	order by dt_inicio_vigencia;

BEGIN
open C01;
loop
fetch C01 into
	pr_taxa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

pr_taxa_p	:= coalesce(pr_taxa_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_taxa_pcmso_operadora ( dt_procedimento_p timestamp, nr_seq_congenere_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, pr_taxa_p INOUT bigint) FROM PUBLIC;

