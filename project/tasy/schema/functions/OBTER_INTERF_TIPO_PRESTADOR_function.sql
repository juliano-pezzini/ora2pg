-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_interf_tipo_prestador ( cd_medico_executor_p text, cd_cgc_prestador_p text, cd_setor_atendimento_p bigint, cd_cgc_estabelecimento_p text) RETURNS varchar AS $body$
DECLARE


/*		M - Médico
		L - Laboratório
		R - Raio-X
		H - Hospital
		C - Clínica
		P - Pronto Socorro
		F - Farmácia			*/
ds_resultado_w		varchar(6);
cd_medico_executor_w	varchar(10);
cd_cgc_prestador_w	varchar(2);
cd_classif_setor_w	varchar(2);


BEGIN
ds_resultado_w		:= null;

select	cd_classif_setor
into STRICT		cd_classif_setor_w
from		setor_atendimento
where		cd_setor_atendimento	= cd_setor_atendimento_p;

if (cd_medico_executor_p IS NOT NULL AND cd_medico_executor_p::text <> '') then
	ds_resultado_w	:= 'M';

elsif (cd_cgc_prestador_p = cd_cgc_estabelecimento_p) then
	if (cd_classif_setor_w in (2,3,4)) then
		ds_resultado_w	:= 'H';
	elsif (cd_classif_setor_w = 1) then
		ds_resultado_w	:= 'P';
	elsif (cd_classif_setor_w = 7) then
		ds_resultado_w	:= 'F';
	else
		ds_resultado_w	:= 'S' || cd_setor_atendimento_p;
	end if;
else
	ds_resultado_w	:= 'C';

end if;
return ds_resultado_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_interf_tipo_prestador ( cd_medico_executor_p text, cd_cgc_prestador_p text, cd_setor_atendimento_p bigint, cd_cgc_estabelecimento_p text) FROM PUBLIC;
