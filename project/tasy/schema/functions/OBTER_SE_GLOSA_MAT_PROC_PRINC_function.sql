-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_glosa_mat_proc_princ (nr_seq_material_p bigint, nr_conta_dest_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_proc_retorno_w		procedimento_paciente.cd_procedimento%type;
nr_seq_proc_princ_w		material_atend_paciente.nr_seq_proc_princ%type;
nr_atendimento_w		material_atend_paciente.nr_atendimento%type;
cd_convenio_w			material_atend_paciente.cd_convenio%type;
nr_interno_conta_proc_w		procedimento_paciente.nr_interno_conta%type;
cd_convenio_proc_w		procedimento_paciente.cd_convenio%type;
cd_categoria_proc_w		procedimento_paciente.cd_categoria%type;
cd_situacao_glosa_proc_w	procedimento_paciente.cd_situacao_glosa%type;
nr_atendimento_proc_w		procedimento_paciente.nr_atendimento%type;
cd_procedimento_w		procedimento_paciente.cd_procedimento%type;
ie_status_conta_proc_w		conta_paciente.ie_status_acerto%type;
ie_glosa_mat_proc_princ_w	parametro_faturamento.ie_glosa_mat_proc_princ%type;
cd_estabelecimento_w		conta_paciente.cd_estabelecimento%type;
cd_conv_conta_dest_w		conta_paciente.cd_convenio_parametro%type;

				 

BEGIN 
cd_procedimento_w	:= 0;
 
if (coalesce(nr_seq_material_p,0) > 0) then 
 
	select	max(nr_seq_proc_princ), 
		max(nr_atendimento), 
		max(cd_convenio) 
	into STRICT	nr_seq_proc_princ_w, 
		nr_atendimento_w, 
		cd_convenio_w 
	from	material_atend_paciente 
	where	nr_sequencia = nr_seq_material_p;
	 
	if (coalesce(nr_seq_proc_princ_w,0) > 0) then 
	 
		select	max(cd_convenio_parametro) 
		into STRICT	cd_conv_conta_dest_w 
		from	conta_paciente 
		where	nr_interno_conta = nr_conta_dest_p;
	 
		select	max(cd_estabelecimento) 
		into STRICT	cd_estabelecimento_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_w;
 
		select	max(nr_interno_conta), 
			max(cd_convenio), 
			max(cd_categoria), 
			max(cd_situacao_glosa), 
			max(nr_atendimento), 
			max(cd_procedimento) 
		into STRICT	nr_interno_conta_proc_w, 
			cd_convenio_proc_w, 
			cd_categoria_proc_w, 
			cd_situacao_glosa_proc_w, 
			nr_atendimento_proc_w, 
			cd_procedimento_w 
		from	procedimento_paciente 
		where	nr_sequencia = nr_seq_proc_princ_w;
 
		begin 
		select	coalesce(max(ie_status_acerto),2) 
		into STRICT	ie_status_conta_proc_w 
		from 	conta_paciente 
		where 	nr_interno_conta = nr_interno_conta_proc_w;
		exception 
			when others then 
			ie_status_conta_proc_w:= 2;
		end;
 
		select	coalesce(max(ie_glosa_mat_proc_princ), 'N') 
		into STRICT	ie_glosa_mat_proc_princ_w 
		from	parametro_faturamento 
		where	cd_estabelecimento	= cd_estabelecimento_w;
 
		if (ie_glosa_mat_proc_princ_w = 'S') and (ie_status_conta_proc_w = 1) and (nr_atendimento_proc_w	= nr_atendimento_w) and 
			((cd_situacao_glosa_proc_w 	= 1) or (cd_convenio_w <> coalesce(cd_conv_conta_dest_w,cd_convenio_proc_w))) then 
			cd_proc_retorno_w	:= cd_procedimento_w;
		end if;
		 
	end if;
	 
end if;
 
 
return	cd_proc_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_glosa_mat_proc_princ (nr_seq_material_p bigint, nr_conta_dest_p bigint) FROM PUBLIC;

