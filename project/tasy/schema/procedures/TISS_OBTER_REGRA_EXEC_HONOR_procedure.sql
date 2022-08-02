-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_obter_regra_exec_honor ( cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_resp_credito_p text, cd_setor_atendimento_p bigint, cd_medico_executor_p text, ie_regra_p INOUT text, cd_cgc_prestador_p INOUT text, ie_exec_regra_p INOUT text, ie_fatur_medico_p text, ie_grau_partic_tiss_p text, cd_interno_p INOUT text, ds_prestador_tiss_p INOUT text, nr_seq_regra_p INOUT bigint) AS $body$
DECLARE


ie_regra_w		varchar(5);
cd_cgc_prestador_w	varchar(255);
ie_exec_regra_w		varchar(5);
cd_interno_w		varchar(60);
ds_prestador_tiss_w	varchar(255);
nr_sequencia_w		bigint;

c01 CURSOR FOR
SELECT	ie_regra,
	cd_cgc_prestador,
	coalesce(ie_exec,'A'),
	cd_interno,
	ds_prestador_tiss,
	nr_sequencia
from	tiss_regra_exec_honor
where	cd_estabelecimento					= cd_estabelecimento_p
and	coalesce(cd_convenio, coalesce(cd_convenio_p, 0))			= coalesce(cd_convenio_p, 0)
and	coalesce(cd_medico_executor, coalesce(cd_medico_executor_p,0))		= coalesce(cd_medico_executor_p,0)
and	coalesce(ie_responsavel_credito, coalesce(ie_resp_credito_p, 'X')) 		= coalesce(ie_resp_credito_p, 'X')
and	coalesce(cd_setor_atendimento, coalesce(cd_Setor_atendimento_p,0))	= coalesce(cd_setor_atendimento_p,0)
and	coalesce(lpad(ie_grau_partic_tiss,2,'0'), coalesce(ie_grau_partic_tiss_p,'X'))	= coalesce(ie_grau_partic_tiss_p,'X')
and	(((coalesce(ie_fatur_medico,'N') = 'S') and (ie_fatur_medico_p = 'S')) or (ie_fatur_medico_p = 'N'))
order by	coalesce(cd_medico_executor,0),
	coalesce(ie_responsavel_credito,0),
	coalesce(cd_setor_atendimento,0),
	coalesce(cd_convenio,0),
	coalesce(ie_grau_partic_tiss,'X');


BEGIN

open c01;
loop
fetch c01 into
	ie_regra_w,
	cd_cgc_prestador_w,
	ie_exec_regra_w,
	cd_interno_w,
	ds_prestador_tiss_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ie_regra_w		:= ie_regra_w;
	cd_cgc_prestador_w	:= cd_cgc_prestador_w;
	ie_exec_regra_w 	:= ie_exec_regra_w;
	cd_interno_w		:= cd_interno_w;
	ds_prestador_tiss_w	:= ds_prestador_tiss_w;
	nr_sequencia_w		:= nr_sequencia_w;
end loop;
close c01;

ie_regra_p		:= ie_regra_w;
cd_cgc_prestador_p	:= cd_cgc_prestador_w;
ie_exec_regra_p		:= ie_exec_regra_w;
cd_interno_p		:= cd_interno_w;
ds_prestador_tiss_p	:= ds_prestador_tiss_w;
nr_seq_regra_p		:= nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_obter_regra_exec_honor ( cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_resp_credito_p text, cd_setor_atendimento_p bigint, cd_medico_executor_p text, ie_regra_p INOUT text, cd_cgc_prestador_p INOUT text, ie_exec_regra_p INOUT text, ie_fatur_medico_p text, ie_grau_partic_tiss_p text, cd_interno_p INOUT text, ds_prestador_tiss_p INOUT text, nr_seq_regra_p INOUT bigint) FROM PUBLIC;

