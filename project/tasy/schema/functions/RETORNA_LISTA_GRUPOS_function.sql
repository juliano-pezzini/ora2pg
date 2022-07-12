-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retorna_lista_grupos (nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_grupo_w		bigint;
cd_especialidade_w	integer;
cd_area_w		integer;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_regra_w		bigint;
nr_seq_grupo_w		bigint;


C01 CURSOR FOR
SELECT	nr_sequencia
from	regra_laudo_grupo_proc
where	coalesce(cd_grupo_proc, coalesce(cd_grupo_w,0)) 		 = coalesce(cd_grupo_w,0)
and	coalesce(cd_especialidade, coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0)
and	coalesce(cd_area_procedimento, coalesce(cd_area_w,0))	 = coalesce(cd_area_w,0)
and	coalesce(cd_procedimento, coalesce(cd_procedimento_w,0))	 = coalesce(cd_procedimento_w,0)
and	((coalesce(cd_procedimento::text, '') = '') or (ie_origem_proced	= ie_origem_proced_w))
order by coalesce(cd_procedimento,0),
	coalesce(ie_origem_proced,ie_origem_proced_w),
	coalesce(cd_grupo_proc,0),
	coalesce(cd_especialidade,0),
	coalesce(cd_area_procedimento,0);

C02 CURSOR FOR
SELECT	nr_seq_grupo
from	regra_laudo_grupo
where	nr_seq_regra_grupo	= nr_seq_regra_w;



BEGIN

begin

select	cd_procedimento,
	ie_origem_proced
into STRICT	cd_procedimento_w,
	ie_origem_proced_w
from	procedimento_paciente
where	nr_sequencia_prescricao	= nr_seq_prescr_p
and	nr_prescricao 	= nr_prescricao_p;

select 	cd_grupo_proc,
	cd_especialidade,
	cd_area_procedimento
into STRICT	cd_grupo_w,
	cd_especialidade_w,
	cd_area_w
from	estrutura_procedimento_v
where	cd_procedimento 	= coalesce(cd_procedimento_w,0)
and	ie_origem_proced	= coalesce(ie_origem_proced_w,0);
exception
     	when others then
	begin
	cd_grupo_w		:= 0;
	cd_especialidade_w	:= 0;
	cd_area_w		:= 0;
	end;
end;

open C01;
	loop
	fetch C01 into
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		nr_seq_regra_w	:= nr_seq_regra_w;
	end loop;
	close C01;
ds_retorno_w := '';
open C02;
	loop
	fetch C02 into
		nr_seq_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		ds_retorno_w := ds_retorno_w || nr_seq_grupo_w || ',';
	end loop;
	close C02;
ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w)-1);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retorna_lista_grupos (nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;
