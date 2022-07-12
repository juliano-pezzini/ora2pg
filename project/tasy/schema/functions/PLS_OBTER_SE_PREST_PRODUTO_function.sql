-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_prest_produto ( nr_seq_plano_p bigint, nr_seq_prestador_p bigint, cd_especialidade_p bigint) RETURNS varchar AS $body$
DECLARE


cd_especialidade_w	especialidade_medica.cd_especialidade%type;

C01 CURSOR FOR
	SELECT	b.cd_especialidade_guia_med
	from	PLS_REDE_ATEND_REGRA	b,
		PLS_PLANO_REDE_ATEND	a
	where	b.nr_seq_rede		= a.NR_SEQ_REDE
	and	b.nr_seq_prestador	= nr_seq_prestador_p
	and	a.nr_seq_plano		= nr_seq_plano_p
	and	clock_timestamp() between b.DT_INICIO_VIGENCIA and coalesce(b.DT_FIM_VIGENCIA,clock_timestamp())
	and	b.IE_PERMITE		= 'S';


BEGIN

open C01;
loop
fetch C01 into
	cd_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	/*Senão tiver restrição pelo filtro, retorna S*/

	if (coalesce(cd_especialidade_p::text, '') = '') then
		close C01;
		return 'S';
	end if;

	if (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then
		if (coalesce(cd_especialidade_w,cd_especialidade_p) = cd_especialidade_p) then
			close C01;
			return 'S';
		end if;
	end if;

	end;
end loop;
close C01;

return	'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_prest_produto ( nr_seq_plano_p bigint, nr_seq_prestador_p bigint, cd_especialidade_p bigint) FROM PUBLIC;

