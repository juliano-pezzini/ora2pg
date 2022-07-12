-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_atendimento_pt ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_prescr_nao_liberada_p text, nr_prescricao_p bigint, nr_prescricoes_p text, nr_prescr_titulo_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE

 
nr_prescricao_w		bigint;
nr_atendimento_w	bigint;


BEGIN 
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	 
	nr_prescricao_w	:=	plt_obter_prescricao(nr_prescricao_p,nr_prescricoes_p,nr_prescr_titulo_p,nm_usuario_p,cd_pessoa_fisica_p,'U');
 
	if (nr_atendimento_p > 0) then 
		begin 
		 
		nr_atendimento_w := nr_atendimento_p;
		end;
	 
	else if (nr_prescricao_w > 0) then 
		begin 
		 
		select	coalesce(max(nr_atendimento),0) 
		into STRICT	nr_atendimento_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_w;
		 
		if (nr_atendimento_w = 0) then 
			begin 
			 
			select	coalesce(max(nr_atendimento),0) 
			into STRICT	nr_atendimento_w 
			from	atendimento_paciente 
			where	cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	coalesce(obter_setor_atendimento(nr_atendimento),0) > 0 
			and	coalesce(dt_alta::text, '') = '';			
			end;
		end if;		
		end;
	else if (cd_pessoa_fisica_p <> '') then 
		begin 
		 
		select	coalesce(max(nr_atendimento),0) 
		into STRICT	nr_atendimento_w 
		from	atendimento_paciente 
		where	cd_pessoa_fisica = cd_pessoa_fisica_p 
		and	coalesce(obter_setor_atendimento(nr_atendimento),0) > 0 
		and	coalesce(dt_alta::text, '') = '';
		end;
	end if;
	end if;
	end if;	
	end;
end if;
return	nr_atendimento_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_atendimento_pt ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_prescr_nao_liberada_p text, nr_prescricao_p bigint, nr_prescricoes_p text, nr_prescr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;

