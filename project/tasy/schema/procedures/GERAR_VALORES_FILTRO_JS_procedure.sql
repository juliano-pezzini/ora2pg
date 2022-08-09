-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_valores_filtro_js ( nr_atendimento_p bigint, cd_paciente_reserva_p bigint, cd_classif_setor_p INOUT bigint, cd_unidade_basica_p INOUT text, cd_unidade_compl_p INOUT text, cd_setor_atendimento_p INOUT bigint, cd_tipo_acomodacao_p INOUT bigint) AS $body$
DECLARE

 
cd_classif_setor_w			bigint;
cd_unidade_basica_w		varchar(10);
cd_unidade_compl_w		varchar(10);
cd_setor_atendimento_w		integer;
cd_tipo_acomodacao_w		smallint;


BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')then 
	begin 
	 
	select	coalesce(max(cd_classif_setor), 0) 
	into STRICT	cd_classif_setor_w 
	from	setor_atendimento 
	where	cd_setor_atendimento = 	(SELECT obter_unidade_atendimento(nr_atendimento_p,'A', 'CS') 
				   	 );					
	 
	end;
end if;
 
select 	coalesce(max(cd_unidade_basica),''), 
	coalesce(max(cd_unidade_compl),''), 
	coalesce(max(cd_setor_atendimento),0), 
	coalesce(max(cd_tipo_acomodacao),0) 
into STRICT	cd_unidade_basica_w, 
	cd_unidade_compl_w, 
	cd_setor_atendimento_w, 
	cd_tipo_acomodacao_w 
from  	unidade_atendimento 
where  	ie_status_unidade    = 'R' 
and   	cd_paciente_reserva   = cd_paciente_reserva_p;
 
cd_classif_setor_p		:= cd_classif_setor_w;
cd_unidade_basica_p	:= cd_unidade_basica_w;
cd_unidade_compl_p	:= cd_unidade_compl_w;
cd_setor_atendimento_p	:= cd_setor_atendimento_w;
cd_tipo_acomodacao_p	:= cd_tipo_acomodacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_valores_filtro_js ( nr_atendimento_p bigint, cd_paciente_reserva_p bigint, cd_classif_setor_p INOUT bigint, cd_unidade_basica_p INOUT text, cd_unidade_compl_p INOUT text, cd_setor_atendimento_p INOUT bigint, cd_tipo_acomodacao_p INOUT bigint) FROM PUBLIC;
