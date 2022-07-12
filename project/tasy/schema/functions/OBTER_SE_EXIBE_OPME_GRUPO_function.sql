-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_opme_grupo ( nr_seq_agenda_p bigint, nr_seq_agenda_proc_adic_p bigint, nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE

 
cd_especialidade_w	bigint:=null;
cd_medico_w		varchar(10):=null;
cd_convenio_w		bigint:=null;
cd_especialidade_ww	bigint:=null;
cd_medico_ww		varchar(10):=null;
cd_convenio_ww		bigint:=null;
qt_idade_paciente_w	smallint;
ie_sexo_w		varchar(1);
ie_exibe_w		varchar(1);
qt_registro_w		bigint;
ie_tipo_convenio_w	smallint;
		

BEGIN 
 
select	obter_especialidade_medico(cd_medico,'C'), 
	cd_medico, 
	cd_convenio, 
	coalesce(qt_idade_paciente,obter_idade_pf(cd_pessoa_fisica,clock_timestamp(),'A')), 
	obter_sexo_pf(cd_pessoa_fisica,'C') 
into STRICT	cd_especialidade_w, 
	cd_medico_w, 
	cd_convenio_w, 
	qt_idade_paciente_w, 
	ie_sexo_w	 
from	agenda_paciente 
where	nr_sequencia = nr_seq_agenda_p;
 
if (coalesce(nr_seq_agenda_proc_adic_p,0) > 0) then 
	select	obter_especialidade_medico(b.cd_medico,'C'), 
		b.cd_medico, 
		b.cd_convenio, 
		coalesce(a.qt_idade_paciente,obter_idade_pf(a.cd_pessoa_fisica,clock_timestamp(),'A')), 
		obter_sexo_pf(a.cd_pessoa_fisica,'C') 
	into STRICT	cd_especialidade_ww, 
		cd_medico_ww, 
		cd_convenio_ww, 
		qt_idade_paciente_w, 
		ie_sexo_w	 
	from	agenda_paciente a, 
		agenda_paciente_proc b 
	where	a.nr_sequencia 	= b.nr_sequencia 
	and	a.nr_sequencia 	= nr_seq_agenda_p 
	and	b.nr_seq_agenda = nr_seq_agenda_proc_adic_p;
end if;	
 
ie_tipo_convenio_w	:= 	coalesce(obter_tipo_convenio(coalesce(cd_convenio_ww,cd_convenio_w)),0);
 
 
select	count(*) 
into STRICT	qt_registro_w 
from	proc_interno_opme a 
where	a.nr_sequencia = nr_sequencia_p 
and	((coalesce(a.cd_medico::text, '') = '') or (a.cd_medico	= coalesce(cd_medico_ww,cd_medico_w))) 
and	coalesce(a.cd_convenio,coalesce(coalesce(cd_convenio_ww,cd_convenio_w),0))	= coalesce(coalesce(cd_convenio_ww,cd_convenio_w),0) 
and	coalesce(a.ie_tipo_convenio,ie_tipo_convenio_w)	= ie_tipo_convenio_w 
and	((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade = coalesce(cd_especialidade_ww,cd_especialidade_w))) 
and (coalesce(qt_idade_paciente_w,0) between coalesce(a.qt_idade_minima,0) and coalesce(a.qt_idade_maxima,999)) 
and	((coalesce(a.ie_sexo::text, '') = '') or (a.ie_sexo = ie_sexo_w)) 
and 	(((a.ie_somente_exclusivo = 'S') and not exists (	SELECT 1 
								from	proc_interno_opme x 
								where	a.nr_seq_proc_interno   	= x.nr_seq_proc_interno 
								and	x.cd_medico			= coalesce(cd_medico_ww,cd_medico_w))) or (coalesce(a.ie_somente_exclusivo,'N') = 'N'));
 
if (qt_registro_w > 0) then 
	ie_exibe_w	:= 'S';
else	 
	ie_exibe_w	:= 'N';
end if;	
 
return	ie_exibe_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_opme_grupo ( nr_seq_agenda_p bigint, nr_seq_agenda_proc_adic_p bigint, nr_sequencia_p bigint ) FROM PUBLIC;

