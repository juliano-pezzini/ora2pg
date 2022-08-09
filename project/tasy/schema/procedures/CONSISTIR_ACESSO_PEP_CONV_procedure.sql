-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_acesso_pep_conv ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_bloqueia_p INOUT text, ds_consistencia_p INOUT text) AS $body$
DECLARE

 
ie_forma_consistir_w		varchar(15);
cd_setor_pac_w			bigint;
cd_setor_usuario_w		bigint;
ie_setor_pac_lib_w		varchar(1);
cd_convenio_w			bigint;
ie_registro_pep_w		varchar(10);
					

BEGIN 
 
if (nr_atendimento_p	> 0) then 
	begin 
	cd_convenio_w	:= obter_convenio_atendimento(nr_atendimento_p);
	exception 
	when others then 
		cd_convenio_w	:= 0;
	end;
	 
	if (cd_convenio_w	> 0) then 
		select	coalesce(max(IE_REGISTRO_PEP),'S') 
		into STRICT	ie_registro_pep_w 
		from	convenio_estabelecimento 
		where	cd_convenio	= cd_convenio_w 
		and	cd_estabelecimento = cd_estabelecimento_p;
		 
		if (ie_registro_pep_w	= 'N') then 
			ds_consistencia_p	:= wheb_mensagem_pck.get_texto(306617, 'NM_CONVENIO=' || obter_nome_convenio(cd_convenio_w)); -- O convênio #@NM_CONVENIO#@ não permite a utilização do PEP 
			ie_bloqueia_p		:= 'S';
		end if;
	end if;
	 
end if;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_acesso_pep_conv ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_bloqueia_p INOUT text, ds_consistencia_p INOUT text) FROM PUBLIC;
