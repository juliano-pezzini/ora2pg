-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_leito_sexo_pac_pan ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_sexo_compativel_w	varchar(1);
ie_sexo_unid_w		varchar(1);
ie_sexo_fixo_w		varchar(1);
ie_sexo_pf_w		varchar(1);
ie_livre_sexo_w		varchar(1);
ie_existe_paciente_w	varchar(1);
cd_tipo_acomodacao_w	bigint;
cd_genero_unid_w	unidade_atendimento.NR_SEQ_GENERO%type;
cd_genero_pf_w		PESSOA_FISICA_AUX.NR_SEQ_GENERO%type;


BEGIN

ie_sexo_compativel_w := 'S';

if (coalesce(nr_atendimento_p,0) > 0) then

	select	coalesce(ie_sexo_paciente,'L'),
		coalesce(ie_sexo_fixo,'N'),
		coalesce(cd_tipo_acomodacao,0),
		nr_seq_genero
	into STRICT	ie_sexo_unid_w,
		ie_sexo_fixo_w,
		cd_tipo_acomodacao_w,
		cd_genero_unid_w
	from 	unidade_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_p
	and	cd_unidade_basica = cd_unidade_basica_p
	and	cd_unidade_compl  = cd_unidade_compl_p;
	
	if (obter_se_sem_acomodacao(cd_tipo_acomodacao_w) = 'S') then
	    return 'S';
	end if;	
	
	select	coalesce(max(a.ie_sexo), 'L')
	into STRICT	ie_sexo_pf_w
	from	pessoa_fisica a,
		atendimento_paciente b
	where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and	b.nr_atendimento = nr_atendimento_p;
	
	select 	max(a.nr_seq_genero)
	into STRICT	cd_genero_pf_w
	from 	pessoa_fisica_aux a,
			atendimento_paciente b
	where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and		b.nr_atendimento = nr_atendimento_p;
	
	select	coalesce(max('S'),'N')
	into STRICT	ie_existe_paciente_w
	from	unidade_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_p
	and	cd_unidade_basica    = cd_unidade_basica_p
	and	ie_sexo_fixo 	     = 'N'
	and 	ie_status_unidade    = 'P';

	
	if (ie_existe_paciente_w  = 'S') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_livre_sexo_w
		from	unidade_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p
		and	cd_unidade_basica    = cd_unidade_basica_p
		and	ie_sexo_fixo 	     = 'N'
		and 	upper(ie_sexo_paciente)     = upper(ie_sexo_pf_w);
	else
		ie_livre_sexo_w := 'N';
	end if;
	
	if	(((ie_sexo_fixo_w = 'S') and (upper(ie_sexo_unid_w) = upper(ie_sexo_pf_w)) and (cd_genero_unid_w = cd_genero_pf_w or coalesce(cd_genero_unid_w::text, '') = '')) or
		((ie_existe_paciente_w = 'N') and ((ie_sexo_fixo_w = 'N') or (ie_sexo_unid_w in ('L','A'))) or
		 (ie_existe_paciente_w = 'S' AND ie_livre_sexo_w = 'S'))) then
		ie_sexo_compativel_w := 'S';
	else
		ie_sexo_compativel_w := 'N';
	end if;

end if;


return	ie_sexo_compativel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_leito_sexo_pac_pan ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nr_atendimento_p bigint) FROM PUBLIC;

