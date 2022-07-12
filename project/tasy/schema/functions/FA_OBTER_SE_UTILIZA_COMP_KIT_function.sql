-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_se_utiliza_comp_kit ( cd_kit_material_p bigint, nr_seq_componente_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


cd_medico_w				varchar(10);
cd_medico_ww			varchar(10);
nr_seq_regra_w			bigint;
ie_utiliza_w			varchar(1);
qt_idade_w				smallint;
cd_pessoa_fisica_w		varchar(10);
cd_estabelecimento_w	smallint;
qt_peso_w				double precision;
cd_setor_atendimento_w	integer;
cd_convenio_w			integer;
cd_convenio_ww			integer;
cd_material_w			integer;


BEGIN
select 	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estabelecimento_w
;

if (coalesce(cd_pessoa_fisica_p,0) > 0) then
	select	max(cd_medico_resp),
			obter_conv_pf_atend(max(cd_pessoa_fisica),'C')
	into STRICT	cd_medico_w,
			cd_convenio_w
	from	atendimento_paciente
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;

if (cd_kit_material_p IS NOT NULL AND cd_kit_material_p::text <> '') and (nr_seq_componente_p IS NOT NULL AND nr_seq_componente_p::text <> '') then
	begin
	/* regra componente */

	select	coalesce(max(cd_medico),'0')
	into STRICT	cd_medico_ww
	from	componente_kit
	where	cd_kit_material	= cd_kit_material_p
	and		nr_sequencia	= nr_seq_componente_p
	and		coalesce(cd_estab_regra, cd_estabelecimento_w) = cd_estabelecimento_w;

	/* somente um médico utiliza */

	if (coalesce(cd_medico_ww,'0') <> '0') and (cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') and (cd_medico_ww = cd_medico_w) then
		ie_utiliza_w	:= 'S';
	
	/* somente um médico utiliza */

	elsif (coalesce(cd_medico_ww,'0') <> '0') and (cd_medico_ww <> cd_medico_w) then
		ie_utiliza_w	:= 'N';

	elsif (coalesce(cd_medico_ww,'0') = '0') then
		/* regra específica médico */

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_regra_w
		from	regra_componente_kit
		where	cd_kit_material	= cd_kit_material_p
		and		nr_seq_componente	= nr_seq_componente_p
		and		cd_medico		= coalesce(cd_medico_w,'0');
		
		if (coalesce(nr_seq_regra_w,0) > 0) then
			select	ie_utiliza_componente
			into STRICT	ie_utiliza_w
			from	regra_componente_kit
			where	nr_sequencia = nr_seq_regra_w;
		else
			/* regra geral */

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_regra_w
			from	regra_componente_kit
			where	cd_kit_material	= cd_kit_material_p
			and		nr_seq_componente	= nr_seq_componente_p
			and		coalesce(cd_medico::text, '') = '';

			if (coalesce(nr_seq_regra_w,0) > 0) then
				select	ie_utiliza_componente
				into STRICT	ie_utiliza_w
				from	regra_componente_kit
				where	nr_sequencia = nr_seq_regra_w;
			else
				/* sem regras */

				ie_utiliza_w	:= 'S';
			end if;
		end if;
	end if;

	/* consistir idade */

	if (ie_utiliza_w = 'S') and (cd_pessoa_fisica_p > 0) then
		begin
		select	coalesce(max(cd_pessoa_fisica),'0'),
				obter_peso_pf(max(cd_pessoa_fisica)),
				coalesce(obter_setor_atendimento(max(nr_atendimento)),0)
		into STRICT	cd_pessoa_fisica_w,
				qt_peso_w,
				cd_setor_atendimento_w
		from	atendimento_paciente
		where	cd_pessoa_fisica	=	cd_pessoa_fisica_p;
	
		select	coalesce(max(obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A')),0)
		into STRICT	qt_idade_w
		;

		select	coalesce(max('S'),'N')
		into STRICT	ie_utiliza_w
		from	componente_kit
		where	qt_idade_w between coalesce(qt_idade_minima,0) and coalesce(qt_idade_maxima,999)
		and		cd_kit_material	= cd_kit_material_p
		and		nr_sequencia	= nr_seq_componente_p
		and		coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
		and		coalesce(cd_estab_regra, cd_estabelecimento_w) = cd_estabelecimento_w;
		
		if (ie_utiliza_w = 'S') and (coalesce(qt_peso_w,0) > 0) then
			select	coalesce(max('S'),'N')
			into STRICT	ie_utiliza_w
			from	componente_kit
			where	qt_peso_w between coalesce(qt_peso_min,-1) and coalesce(qt_peso_max,999)
			and		cd_kit_material		= cd_kit_material_p
			and		nr_sequencia		= nr_seq_componente_p
			and		coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
			and		coalesce(cd_estab_regra, cd_estabelecimento_w) = cd_estabelecimento_w;
		end if;	
		end;
	end if;
	
	if (ie_utiliza_w = 'S') then
		select	coalesce(max(cd_convenio),0)
		into STRICT	cd_convenio_ww
		from	componente_kit
		where	cd_kit_material	= cd_kit_material_p
		and		nr_sequencia	= nr_seq_componente_p
		and		coalesce(cd_estab_regra, cd_estabelecimento_w) = cd_estabelecimento_w;
		if (cd_convenio_ww > 0) and (cd_convenio_w = cd_convenio_ww) then
			ie_utiliza_w	:= 'S';
		elsif (cd_convenio_ww > 0) and (cd_convenio_w <> cd_convenio_ww) then
			ie_utiliza_w	:= 'N';
		elsif (cd_convenio_ww = 0) then
			select	max(cd_material)
			into STRICT	cd_material_w
			from	componente_kit
			where	nr_sequencia = nr_seq_componente_p;
			
			select	coalesce(max('N'),'S') -- Caso encontrar algum componente com o convênio da cirurgia. Os componentes sem convênio não devem ser apresentados.
			into STRICT	ie_utiliza_w
			from	componente_kit x
			where	x.ie_situacao	  	= 'A'
			and		x.cd_kit_material	= cd_kit_material_p
			and		x.cd_material	  	= cd_material_w
			and		x.cd_convenio 	  	= cd_convenio_w
			and		((coalesce(x.cd_estab_regra::text, '') = '') or (x.cd_estab_regra = cd_estabelecimento_w));
		end if;	
	end if;	
	end;
end if;

return ie_utiliza_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_se_utiliza_comp_kit ( cd_kit_material_p bigint, nr_seq_componente_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

