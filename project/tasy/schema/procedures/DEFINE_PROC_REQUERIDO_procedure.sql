-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE define_proc_requerido (NR_ATENDIMENTO_P bigint, CD_CONVENIO_P bigint, CD_PROC_EXECUTADO_P bigint, IE_ORIGEM_EXECUTADO_P bigint, DS_PROC_REQUERIDO_P INOUT text, IE_OBRIGATORIO_P INOUT text) AS $body$
DECLARE


qt_proc_w			integer		:= 0;


BEGIN

ds_proc_requerido_p			:= '';
select	count(*)
into STRICT		qt_proc_w
from		procedimento_requerido a
where		cd_proc_executado		= cd_proc_executado_p
  and		ie_origem_executado	= ie_origem_executado_p
  and		cd_convenio			= cd_convenio_p
  and		coalesce(ie_obrigatorio,'N')	= 'S';
if (qt_proc_w > 0) then
	begin
	select	count(*)
	into STRICT		qt_proc_w
	from		procedimento_requerido a
	where		cd_proc_executado		= cd_proc_executado_p
	  and		ie_origem_executado	= ie_origem_executado_p
	  and		cd_convenio			= cd_convenio_p
	  and		coalesce(ie_obrigatorio,'N')	= 'S'
	  and		not exists (SELECT 1
			from procedimento_paciente b
			where nr_atendimento		= nr_atendimento_p
			  and a.cd_proc_requerido	= b.cd_procedimento
			  and a.ie_origem_Requerido	= b.ie_origem_proced);
	if (qt_proc_w > 0) then
		ds_proc_requerido_p			:= wheb_mensagem_pck.get_texto(306670, null); -- Erro
	end if;
	end;
end if;

select	count(*)
into STRICT		qt_proc_w
from		procedimento_requerido a
where		cd_proc_executado		= cd_proc_executado_p
  and		ie_origem_executado	= ie_origem_executado_p
  and		cd_convenio			= cd_convenio_p
  and		coalesce(ie_obrigatorio,'N')	= 'N';
if (ds_proc_requerido_p = '') and (qt_proc_w > 0) then
	begin
	select	count(*)
	into STRICT		qt_proc_w
	from		procedimento_requerido a
	where		cd_proc_executado		= cd_proc_executado_p
	  and		ie_origem_executado	= ie_origem_executado_p
	  and		cd_convenio			= cd_convenio_p
	  and		coalesce(ie_obrigatorio,'N')	= 'N'
	  and		exists (SELECT 1
			from procedimento_paciente b
			where nr_atendimento		= nr_atendimento_p
			  and a.cd_proc_requerido	= b.cd_procedimento
			  and a.ie_origem_Requerido	= b.ie_origem_proced);
	if (qt_proc_w = 0) then
		ds_proc_requerido_p			:= wheb_mensagem_pck.get_texto(306670, null); -- Erro
	end if;
	end;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE define_proc_requerido (NR_ATENDIMENTO_P bigint, CD_CONVENIO_P bigint, CD_PROC_EXECUTADO_P bigint, IE_ORIGEM_EXECUTADO_P bigint, DS_PROC_REQUERIDO_P INOUT text, IE_OBRIGATORIO_P INOUT text) FROM PUBLIC;

