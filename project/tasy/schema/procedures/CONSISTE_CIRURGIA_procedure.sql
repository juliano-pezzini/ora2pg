-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_cirurgia (nr_cirurgia_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ds_consistencia_p INOUT text) AS $body$
DECLARE

 
 
ds_consistencia_w		varchar(2000)	:= '';
nr_atendimento_w		bigint;
ie_consiste_clinica_sus_w	varchar(01);
ie_tipo_convenio_w		bigint;
ie_clinica_w			bigint;


BEGIN 
 
if (nr_atendimento_p > 0) then 
	begin 
 
	ie_consiste_clinica_sus_w := Obter_Param_Usuario(901, 47, obter_perfil_ativo, nm_usuario_p, 0, ie_consiste_clinica_sus_w);
 
	if (ie_consiste_clinica_sus_w = 'S') then 
		begin 
 
		select	coalesce(max(ie_tipo_convenio), 0) 
		into STRICT	ie_tipo_convenio_w 
		from	convenio 
		where	cd_convenio	= obter_convenio_atendimento(nr_atendimento_p);
 
		select	coalesce(max(ie_clinica), 0) 
		into STRICT	ie_clinica_w 
		from	atendimento_paciente 
		where	nr_atendimento	= nr_atendimento_p;
 
		if (ie_tipo_convenio_w = 3) and (ie_clinica_w <> 2) then 
			begin 
		 
			ds_consistencia_w	:= 'Este atendimento é do convênio SUS e possui clínica diferente de cirúrgica!';
 
			end;
		end if;
 
		end;
	end if;
 
	end;
end if;
 
ds_consistencia_p	:= ds_consistencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_cirurgia (nr_cirurgia_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ds_consistencia_p INOUT text) FROM PUBLIC;

