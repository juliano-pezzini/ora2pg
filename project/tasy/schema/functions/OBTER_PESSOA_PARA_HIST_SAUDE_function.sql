-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_para_hist_saude ( nr_seq_emissao_p bigint) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
nr_episodio_w		    prontuario_emissao.nr_seq_episodio%type;
dt_inicio_w		      prontuario_emissao.dt_inicial%type;
dt_fim_w		        prontuario_emissao.dt_final%type;


BEGIN
	select	max(nr_seq_episodio),
		max(dt_inicial),
		max(dt_final)
	into STRICT	nr_episodio_w,
		dt_inicio_w,
		dt_fim_w
	from 	prontuario_emissao
	where	nr_sequencia = nr_seq_emissao_p;

	select	distinct cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from (
	  SELECT max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_medic_uso
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	
union all

	  SELECT max(cd_pessoa_fisica) cd_pessoa_fisica
	  from plano_versao
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from historico_saude_internacao
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from historico_saude_tratamento
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_acessorio
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_amputacao
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from pf_tipo_deficiencia
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_pflegegrad
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_rep_prescricao
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from cih_pac_fat_risco
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_hist_social
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_transfusao
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_vacina
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_alergia
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_antec_clinico
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_exame
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_ocorrencia
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from paciente_habito_vicio
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	  
union all

	  select max(cd_pessoa_fisica) cd_pessoa_fisica
	  from historico_saude_cirurgia
	  where cd_pessoa_fisica = OBTER_PACIENTE_EPISODIO(nr_episodio_w)
	  and ( coalesce(dt_fim_w::text, '') = '' or coalesce(dt_inicio_w::text, '') = '' or dt_liberacao between dt_inicio_w and dt_fim_w)
	) x
	where cd_pessoa_fisica = cd_pessoa_fisica;

	return cd_pessoa_fisica_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_para_hist_saude ( nr_seq_emissao_p bigint) FROM PUBLIC;

