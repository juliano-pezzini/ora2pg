-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_copartic_proc_lib ( nr_seq_tipo_copart_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_clinica_p bigint, nr_seq_saida_int_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(10);
cd_procedimento_w		bigint;
cd_area_w			bigint;
cd_especialidade_w		bigint;
cd_grupo_w			bigint;
ie_origem_proced_w		bigint;
nr_seq_clinica_w		bigint;
nr_seq_saida_int_w		bigint;

C01 CURSOR FOR
	SELECT	b.ie_liberado
	from	pls_tipo_coparticipacao a,
		pls_coparticipacao_proc b
	where	a.nr_sequencia	= b.nr_seq_tipo_coparticipacao
	and	a.nr_sequencia					= nr_seq_tipo_copart_p
	and	coalesce(b.cd_procedimento, cd_procedimento_p)	= cd_procedimento_p
	and	coalesce(b.ie_origem_proced, ie_origem_proced_w) 	= ie_origem_proced_w
	and	coalesce(b.cd_grupo_proc, cd_grupo_w)		= cd_grupo_w
	and	coalesce(b.cd_especialidade, cd_especialidade_w)	= cd_especialidade_w
	and	coalesce(b.cd_area_procedimento, cd_area_w) 		= cd_area_w
	and	coalesce(b.nr_seq_clinica, nr_seq_clinica_w)		= nr_seq_clinica_w
	and	coalesce(b.nr_seq_saida_int, nr_seq_saida_int_w)	= nr_seq_saida_int_w
	order by
		b.cd_area_procedimento,
		b.cd_especialidade,
		b.cd_grupo_proc,
		b.cd_procedimento;


BEGIN

ds_retorno_w	:= 'N';

nr_seq_clinica_w	:= coalesce(nr_seq_clinica_p,0);
nr_seq_saida_int_w	:= coalesce(nr_seq_saida_int_p,0);

SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w;

open C01;
loop
fetch C01 into
	ds_retorno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_copartic_proc_lib ( nr_seq_tipo_copart_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_clinica_p bigint, nr_seq_saida_int_p bigint) FROM PUBLIC;
