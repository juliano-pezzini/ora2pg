-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE laudo_pac_proced_beforepost ( nr_seq_proc_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_interno_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p text, ie_origem_proced_p text, nr_seq_exame_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_medico_executor_p INOUT text, cd_anestesista_p INOUT text, cd_medico_prescr_med_p INOUT text, cd_medico_ditado_p INOUT text, cd_projeto_p INOUT bigint, cd_protocolo_p INOUT bigint, ie_informar_pre_laudo_p INOUT text, cd_tecnico_resp_p INOUT text, cd_medico_prev_laudo_p INOUT text) AS $body$
DECLARE

 
cd_medico_executor_w	varchar(10)	:= '';
cd_anestesista_w	varchar(10)	:= '';
cd_medico_prescr_med_w	varchar(10)	:= '';
cd_medico_ditado_w	varchar(10)	:= '';
cd_tecnico_resp_w	varchar(10)	:= '';
cd_projeto_w      integer;
cd_protocolo_w		bigint;
ie_informar_pre_laudo_w	bigint;
ie_inf_pre_laudo_p_w	varchar(10)	:= '';
cd_tipo_protocolo_w	varchar(255)	:= '';
ie_obter_projeto_w		varchar(1);
cd_medico_prev_laudo_w	varchar(10)	:= '';


BEGIN 
 
cd_tipo_protocolo_w := obter_param_usuario(28, 10, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_tipo_protocolo_w);
ie_inf_pre_laudo_p_w := obter_param_usuario(28, 228, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_inf_pre_laudo_p_w);
ie_obter_projeto_w := obter_param_usuario(28, 88, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_obter_projeto_w);
 
if (nr_seq_proc_p > 0) then 
	begin 
	select	max(cd_medico_executor), 
		max(cd_medico_prev_laudo) 
	into STRICT	cd_medico_executor_w, 
		cd_medico_prev_laudo_w 
	from	procedimento_paciente 
	where	nr_sequencia = nr_seq_proc_p;
 
	select 	max(cd_pessoa_fisica) 
	into STRICT	cd_anestesista_w 
	from	procedimento_participante b, 
		funcao_medico a 
	where	a.ie_anestesista = 'S' 
	and	b.ie_funcao = a.cd_funcao 
	and	nr_sequencia = nr_seq_proc_p;
	end;
end if;
 
if (nr_prescricao_p > 0) then 
	begin 
	select	max(cd_medico) 
	into STRICT 	cd_medico_prescr_med_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;
	end;
end if;
 
if (nr_seq_interno_p > 0) then 
	begin 
	select	max(b.cd_pessoa_fisica) 
	into STRICT	cd_medico_ditado_w 
	from	usuario b, 
		prescr_proc_ditado a 
	where	a.nr_seq_prescr_proc = nr_seq_interno_p 
	and	a.nm_usuario = b.nm_usuario;
	end;
end if;
 
if (nr_seq_proc_interno_p > 0 and 
	'S' = ie_obter_projeto_w) then 
	begin 
	cd_projeto_w := obter_proj_estud_proced(nr_seq_proc_interno_p);
	end;
end if;
 
if (nr_seq_prescr_p > 0) then 
	select	max(b.cd_pessoa_fisica) cd_tecnico_resp 
	into STRICT	cd_tecnico_resp_w 
	from 	procedimento_paciente a, 
		usuario b 
	where 	a.nr_prescricao = nr_prescricao_p 
	and 	a.nr_sequencia_prescricao = nr_seq_prescr_p 
	and 	b.nm_usuario = a.nm_usuario_original;
end if;
 
 
 
cd_protocolo_w := obter_protocolo_procedimento(cd_procedimento_p,cd_tipo_protocolo_w,ie_origem_proced_p,nr_seq_proc_interno_p,nr_seq_exame_p);
 
select	count(*) 
into STRICT	ie_informar_pre_laudo_w 
from	tipo_evolucao b, 
	evolucao_paciente a, 
	prescr_procedimento c 
where	a.ie_tipo_evolucao = b.cd_tipo_evolucao 
and	b.ie_pre_laudo	 = 'S' 
and	a.nr_seq_int_prescr = c.nr_seq_interno 
and	c.nr_prescricao = nr_prescricao_p 
and	c.nr_sequencia = nr_seq_prescr_p;
 
ie_informar_pre_laudo_p := 'N';
 
if (ie_informar_pre_laudo_w > 0) and (ie_inf_pre_laudo_p_w = 'S') then 
	begin 
	ie_informar_pre_laudo_p := obter_texto_dic_objeto(128942, wheb_usuario_pck.get_nr_seq_idioma, null);
	end;
end if;
 
cd_medico_executor_p	:= cd_medico_executor_w;
cd_anestesista_p	:= cd_anestesista_w;
cd_medico_prescr_med_p	:= cd_medico_prescr_med_w;
cd_medico_ditado_p	:= cd_medico_ditado_w;
cd_projeto_p		:= cd_projeto_w;
cd_protocolo_p		:= cd_protocolo_w;
cd_tecnico_resp_p	:= cd_tecnico_resp_w;
cd_medico_prev_laudo_p	:= cd_medico_prev_laudo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE laudo_pac_proced_beforepost ( nr_seq_proc_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_interno_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p text, ie_origem_proced_p text, nr_seq_exame_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_medico_executor_p INOUT text, cd_anestesista_p INOUT text, cd_medico_prescr_med_p INOUT text, cd_medico_ditado_p INOUT text, cd_projeto_p INOUT bigint, cd_protocolo_p INOUT bigint, ie_informar_pre_laudo_p INOUT text, cd_tecnico_resp_p INOUT text, cd_medico_prev_laudo_p INOUT text) FROM PUBLIC;

