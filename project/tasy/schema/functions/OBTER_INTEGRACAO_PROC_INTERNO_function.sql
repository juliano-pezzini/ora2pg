-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_integracao_proc_interno ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE, nr_seq_prescr_p prescr_procedimento.nr_sequencia%TYPE, nr_seq_proc_interno_p prescr_procedimento.nr_seq_proc_interno%TYPE, ie_tipo_integracao_p regra_proc_interno_integra.ie_tipo_integracao%TYPE ) RETURNS varchar AS $body$
DECLARE


nr_seq_proc_interno_w	prescr_procedimento.nr_seq_proc_interno%TYPE;
cd_integracao_w		    regra_proc_interno_integra.cd_integracao%TYPE;
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%TYPE;
qt_idade_w				regra_proc_interno_integra.qt_idade_max%TYPE;
dt_nasc_w				pessoa_fisica.dt_nascimento%TYPE;
cd_pessoa_fisica_w		prescr_medica.cd_pessoa_fisica%TYPE;
ie_lado_w				prescr_procedimento.ie_lado%TYPE;
ie_sexo_w				pessoa_fisica.ie_sexo%TYPE;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento%TYPE;
nr_atendimento_w		prescr_medica.nr_atendimento%TYPE;
cd_estabelecimento_w    prescr_medica.cd_estabelecimento%TYPE;
ds_modalidade_w			modalidade.ds_modalidade%TYPE;
			

BEGIN

nr_seq_proc_interno_w := nr_seq_proc_interno_p;

if (coalesce(nr_seq_proc_interno_w::text, '') = '') then

	select	max(nr_seq_proc_interno)
	into STRICT	nr_seq_proc_interno_w
	from	prescr_procedimento
	where	nr_prescricao 	= nr_prescricao_p
	and	nr_sequencia 	= nr_seq_prescr_p;

end if;


 if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then

 	select	max(ie_lado)
	into STRICT	ie_lado_w
	from	prescr_procedimento
	where	nr_prescricao 	= nr_prescricao_p
	and	nr_sequencia 	= nr_seq_prescr_p;

 	select	cd_estabelecimento,cd_pessoa_fisica,nr_atendimento
    into STRICT    cd_estabelecimento_w,cd_pessoa_fisica_w,nr_atendimento_w
	from	prescr_medica
	where	nr_prescricao 	= nr_prescricao_p;
	
	select ie_tipo_atendimento,cd_setor_desejado
	into STRICT 	ie_tipo_atendimento_w,cd_setor_atendimento_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;
	
	select ie_sexo,dt_nascimento
	into STRICT ie_sexo_w,dt_nasc_w
	from pessoa_fisica
	where cd_pessoa_fisica = cd_pessoa_fisica_w;
	
	select floor(months_between(clock_timestamp(), dt_nasc_w) /12) into STRICT qt_idade_w;

	select max(mo.ds_modalidade)
	into STRICT ds_modalidade_w
	from ATENDIMENTO_PACIENTE ap 
	join SETOR_ATENDIMENTO sa on (ap.cd_setor_desejado = sa.cd_setor_atendimento) 
	join MODALIDADE_SETOR ms on (ms.cd_setor_atendimento = sa.cd_setor_atendimento)
	join MODALIDADE mo ON (ms.nr_seq_modalidade = mo.nr_sequencia)
	where ap.nr_atendimento = nr_atendimento_w;

	select	max(cd_integracao)
	into STRICT	cd_integracao_w
	from	regra_proc_interno_integra
	where	nr_seq_proc_interno	= nr_seq_proc_interno_w
	and	ie_tipo_integracao	= ie_tipo_integracao_p
	and ((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''))
	and ((coalesce(ie_lado::text, '') = '') or (ie_lado = ie_lado_w))
	and ((coalesce(ie_sexo::text, '') = '') or (ie_sexo = ie_sexo_w))
	and ((coalesce(qt_idade_min::text, '') = '' and coalesce(qt_idade_max::text, '') = '') or (qt_idade_w between qt_idade_min and qt_idade_max))
	and ((coalesce(ie_tipo_atendimento::text, '') = '') or (ie_tipo_atendimento = ie_tipo_atendimento_w))
	and ((coalesce(ds_modalidade::text, '') = '') or (UPPER(ds_modalidade) like upper(ds_modalidade_w)))
	and	(cd_integracao IS NOT NULL AND cd_integracao::text <> '');
	
end if;

return	cd_integracao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_integracao_proc_interno ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE, nr_seq_prescr_p prescr_procedimento.nr_sequencia%TYPE, nr_seq_proc_interno_p prescr_procedimento.nr_seq_proc_interno%TYPE, ie_tipo_integracao_p regra_proc_interno_integra.ie_tipo_integracao%TYPE ) FROM PUBLIC;

