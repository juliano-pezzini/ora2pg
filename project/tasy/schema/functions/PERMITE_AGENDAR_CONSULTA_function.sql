-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION permite_agendar_consulta (nr_seq_agenda_p bigint, cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_proc_interno_w   agenda_lista_espera.nr_seq_proc_interno%type;
cd_procedimento_w     	agenda_lista_espera.cd_procedimento%type;
ie_origem_proced_w    	agenda_lista_espera.ie_origem_proced%type;
cd_area_proced_w      	especialidade_proc.cd_area_procedimento%type;
cd_espec_proced_w     	grupo_proc.cd_especialidade%type;
cd_grupo_proced_w    	procedimento.cd_grupo_proc%type;
cd_paciente_w	        agenda_lista_espera.cd_pessoa_fisica%type;
qtde_registros_w      	bigint := 0;
cd_medico_exec_w      	agenda_lista_espera.cd_medico_exec%type;
cd_estabelecimento_w  	estabelecimento.cd_estabelecimento%type;
cd_convenio_w		agenda_lista_espera.cd_convenio%type;
cd_categoria_w		agenda_lista_espera.cd_categoria%type;
cd_plano_w		agenda_lista_espera.cd_plano%type;
ie_tipo_agend_w		varchar(1);
		
/* A principio sera criado o tratamento apenas para considerar regras sem ser por grupo OS-1736845*/

BEGIN

cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

select	coalesce(max(a.nr_seq_proc_interno), 0),
	coalesce(max(a.cd_procedimento),0),
	coalesce(max(a.ie_origem_proced),0),
	coalesce(max(a.cd_pessoa_fisica),0),
	coalesce(max(a.cd_medico_exec),0),
	coalesce(max(a.cd_convenio),0),
	coalesce(max(a.cd_categoria),0),
	coalesce(max(a.cd_plano),0)
into STRICT	nr_seq_proc_interno_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	cd_paciente_w,
	cd_medico_exec_w,
	cd_convenio_w,
	cd_categoria_w,
	cd_plano_w
from	agenda_lista_espera a
where	a.nr_sequencia = nr_seq_agenda_p
order by cd_tipo_agenda,
	nr_seq_proc_interno,
	cd_medico,
	cd_especialidade;
	
select	coalesce(max(cd_area_procedimento),0),
	coalesce(max(cd_especialidade),0),                                                  
	coalesce(max(cd_grupo_proc),0)                                                                                                             
into STRICT	cd_area_proced_w,                                                          
	cd_espec_proced_w,                                                             
	cd_grupo_proced_w                                                          
from	estrutura_procedimento_v                                                   
where	cd_procedimento = cd_procedimento_w                                       
and	ie_origem_proced = ie_origem_proced_w;

select	count(nr_sequencia)
into STRICT	qtde_registros_w
from	agenda_cons_regra_proc
where	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
and	coalesce(cd_agenda,cd_agenda_p) = cd_agenda_p;

ie_tipo_agend_w := AGEINT_OBTER_TIPO_AGENDA(cd_agenda_p);

if (qtde_registros_w > 0) then
	select	count(nr_sequencia)
	into STRICT	qtde_registros_w
	from	agenda_cons_regra_proc
	where	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
	and	coalesce(cd_agenda,cd_agenda_p) = cd_agenda_p
	and	((cd_convenio = cd_convenio_w) or (coalesce(cd_convenio::text, '') = ''))
	and	((cd_categoria = cd_categoria_w) or (coalesce(cd_categoria::text, '') = ''))
	and	((cd_plano_convenio = cd_plano_w) or (coalesce(cd_plano_convenio::text, '') = ''))
	and	((cd_area_procedimento = cd_area_proced_w) or (coalesce(cd_area_procedimento::text, '') = ''))
	and	((cd_especialidade = cd_espec_proced_w) or (coalesce(cd_especialidade::text, '') = ''))
	and	((cd_grupo_proc = cd_grupo_proced_w) or (coalesce(cd_grupo_proc::text, '') = ''))
	and	((cd_procedimento = cd_procedimento_w) or (coalesce(cd_procedimento::text, '') = ''))
	and	((coalesce(cd_procedimento::text, '') = '') or ((ie_origem_proced = ie_origem_proced_w) or (coalesce(ie_origem_proced::text, '') = '')))
	and	((nr_seq_proc_interno = nr_seq_proc_interno_w) or (coalesce(nr_seq_proc_interno::text, '') = ''))
	and	ie_permite <> 'N'
	and ((ie_agenda = ie_tipo_agend_w) or (coalesce(ie_agenda,'A') = 'A'))
	order by coalesce(cd_procedimento,0),
		coalesce(nr_seq_proc_interno,0),
		coalesce(cd_area_procedimento,0),
		coalesce(cd_especialidade,0),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_convenio, 0);

	if (qtde_registros_w > 0)	then
		return 'S';
	else
		return 'N';
	end if;
else
	return 'S';
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION permite_agendar_consulta (nr_seq_agenda_p bigint, cd_agenda_p bigint) FROM PUBLIC;
