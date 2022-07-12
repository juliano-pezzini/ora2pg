-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conversao_proc_conv ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_especialidade_p bigint, nr_atendimento_p bigint, dt_procedimento_p text, cd_setor_atend_p bigint, nr_seq_atepacu_p bigint, nr_seq_proc_int_p bigint, nr_sequencia_p bigint, nr_seq_pacote_p bigint, vl_procedimento_p bigint, ie_funcao_medico_p text) RETURNS varchar AS $body$
DECLARE

 
cd_item_convenio_w		varchar(20)	:= '';
cd_grupo_w			varchar(10)	:= '';
nr_seq_conversao_w		bigint	:= 0;
ie_tipo_atendimento_w		varchar(15);
cd_tipo_acomodacao_w		bigint;
ie_pacote_w			varchar(1);
cd_plano_w			varchar(10);
ie_clinica_w			integer;
cd_tipo_acomod_conv_w		smallint;
qt_idade_w			bigint;
cd_pessoa_fisica_w		varchar(10);
ie_sexo_w			varchar(1);
cd_empresa_ref_w		bigint;
ie_carater_inter_sus_w		varchar(2);
nr_seq_pacote_w			bigint;
cd_dependente_w			smallint;


BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	select	coalesce(max(obter_tipo_atendimento(nr_atendimento_p)),'0'), 
		coalesce(max(obter_clinica_atend(nr_atendimento_p,'C')),0) 
	into STRICT	ie_tipo_atendimento_w, 
		ie_clinica_w 
	;
	 
end if;
 
if (nr_seq_atepacu_p IS NOT NULL AND nr_seq_atepacu_p::text <> '') then 
	select	max(cd_tipo_acomodacao) 
	into STRICT	cd_tipo_acomodacao_w 
	from	atend_paciente_unidade 
	where	nr_seq_interno	= nr_seq_atepacu_p;
end if;
 
ie_pacote_w	:= 'N';
 
if (nr_seq_pacote_p = nr_sequencia_p) then 
	ie_pacote_w	:= 'S';
end if;
 
select 	coalesce(max(cd_plano_convenio),'0'), 
	coalesce(max(cd_empresa),0), 
	max(cd_dependente) 
into STRICT	cd_plano_w, 
	cd_empresa_ref_w, 
	cd_dependente_w 
from 	atend_categoria_convenio 
where 	nr_atendimento = nr_atendimento_p 
and 	cd_convenio = cd_convenio_p;
 
select 	max(cd_tipo_acomodacao) 
into STRICT	cd_tipo_acomod_conv_w 
from 	atend_categoria_convenio 
where 	nr_atendimento = nr_atendimento_p 
and 	cd_convenio = cd_convenio_p;
 
select	max(cd_pessoa_fisica), 
	max(ie_carater_inter_sus) 
into STRICT	cd_pessoa_fisica_w, 
	ie_carater_inter_sus_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
begin 
select	max(obter_idade(dt_nascimento, coalesce(dt_obito,clock_timestamp()),'DIA')), 
	max(ie_sexo) 
into STRICT	qt_idade_w, 
	ie_sexo_w 
from	pessoa_fisica 
where	cd_pessoa_fisica = cd_pessoa_fisica_w;
exception 
when others then 
	qt_idade_w	:= 0;
	ie_sexo_w	:= '';
end;
 
nr_seq_pacote_w	:= 0;
if (nr_sequencia_p = nr_seq_pacote_p) then 
	select	max(nr_seq_pacote) 
	into STRICT	nr_seq_pacote_w 
	from	atendimento_pacote 
	where	nr_seq_procedimento = nr_sequencia_p 
	and	nr_atendimento = nr_atendimento_p;	
end if;
 
SELECT * FROM converte_proc_convenio(cd_estabelecimento_p, cd_convenio_p, null, cd_procedimento_p, ie_origem_proced_p, cd_especialidade_p, null, ie_tipo_atendimento_w, to_date(dt_procedimento_p,'dd/mm/yyyy hh24:mi:ss'), cd_item_convenio_w, cd_grupo_w, nr_seq_conversao_w, cd_setor_atend_p, cd_tipo_acomodacao_w, nr_seq_proc_int_p, ie_pacote_w, cd_plano_w, ie_clinica_w, vl_procedimento_p, ie_funcao_medico_p, cd_tipo_acomod_conv_w, qt_idade_w, ie_sexo_w, cd_empresa_ref_w, ie_carater_inter_sus_w, nr_seq_pacote_w, null, null, cd_dependente_w) INTO STRICT cd_item_convenio_w, cd_grupo_w, nr_seq_conversao_w;
	 
return cd_item_convenio_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conversao_proc_conv ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_especialidade_p bigint, nr_atendimento_p bigint, dt_procedimento_p text, cd_setor_atend_p bigint, nr_seq_atepacu_p bigint, nr_seq_proc_int_p bigint, nr_sequencia_p bigint, nr_seq_pacote_p bigint, vl_procedimento_p bigint, ie_funcao_medico_p text) FROM PUBLIC;
