-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_orientacao_proc_agexame (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_tipo_classif_pac_p bigint, nr_seq_agenda_p bigint, ie_consulta_p text default 'N') RETURNS varchar AS $body$
DECLARE


TYPE lista_macros IS TABLE OF varchar(255) INDEX BY integer;

ds_orientacao_w		varchar(6000) := '';
ds_orientacao_pac_w	varchar(6000) := '';
ds_orientacao_obs_w	varchar(6000)	:= '';
ds_orient_convenio_w	varchar(2000) := '';
ie_orientacao_w		varchar(01);
cd_plano_convenio_w	varchar(10);
cd_categoria_w		varchar(10);
qt_idade_w		bigint;
ds_orient_paciente_w	varchar(4000) := '';
nr_seq_classif_w	bigint;
cd_estabelecimento_w	smallint;
cd_medico_exec_w	varchar(10);
ds_orientacao_ageint_w 	text := '';
ds_orientacao_ageint_w2 text := '';
nr_seq_topografia_w	agenda_paciente.cd_topografia_proced%type;
ie_tipo_atendimento_w	agenda_paciente.ie_tipo_atendimento%type;
lista_macros_w	lista_macros;
ind	bigint := 0;
qt_valor_w	AGEINT_ORIENT_PREP_MACRO.vl_macro%type := 0;
ds_lista_macro_w varchar(4000) := ageint_obter_macro_prep('S');
ds_macro_w varchar(255) := '';
nr_seq_prep_w	ageint_orient_preparo.nr_sequencia%type;
cd_estab_agenda_w	agenda.cd_estabelecimento%type;

C01 CURSOR FOR
	SELECT	ds_orientacao
	from	proc_interno_conv_orient
	where	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0)
	and	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''))
	and	((coalesce(cd_categoria, coalesce(cd_categoria_w,'0')) = coalesce(cd_categoria_w,'0')) or (coalesce(cd_categoria_w,'0') = '0'))
	and	((coalesce(cd_plano, coalesce(cd_plano_convenio_w,'0')) = coalesce(cd_plano_convenio_w,'0')) or (coalesce(cd_plano_convenio_w,'0') = '0'))
	and	qt_idade_w between coalesce(qt_idade_min, qt_idade_w) and coalesce(qt_idade_max, qt_idade_w)
	and (coalesce(nr_seq_classif, coalesce(nr_seq_classif_w,0)) = coalesce(nr_seq_classif_w,0))
	order by	coalesce(nr_seq_proc_interno,0),	
		coalesce(nr_seq_classif,0);
	
C02 CURSOR FOR	
	SELECT	ds_orientacao_pac
	from	proc_interno_pac_orient
	where	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0)
	and	coalesce(ie_situacao,'A') = 'A'
	and	qt_idade_w between coalesce(qt_idade_min, qt_idade_w) and coalesce(qt_idade_max, qt_idade_w)
	and (coalesce(nr_seq_classif, coalesce(nr_seq_classif_w,0)) = coalesce(nr_seq_classif_w,0))
	and (coalesce(nr_seq_tipo_classif_pac, coalesce(nr_seq_tipo_classif_pac_p,0)) = coalesce(nr_seq_tipo_classif_pac_p,0))
	and (coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w,1)) = coalesce(cd_estabelecimento_w,1))
	and	((cd_pessoa_fisica = cd_medico_exec_w) or (coalesce(cd_pessoa_fisica::text, '') = ''))
	order by	coalesce(nr_seq_proc_interno,0),	
		coalesce(nr_seq_classif,0);
		
c03 CURSOR FOR
  	SELECT	ds_orientacao_preparo,
			nr_sequencia
	from (SELECT	aop.nr_sequencia,
             		aopr.nr_seq_orient_preparo,
               		aop.ds_orientacao_preparo
        	from 	ageint_orient_preparo    aop,
             		ageint_orient_prep_regra aopr
        	where 	aop.nr_sequencia = aopr.nr_seq_orient_preparo
        	and 	coalesce(aopr.nr_seq_proc_interno, nr_seq_proc_interno_p) = nr_seq_proc_interno_p
        	and 	coalesce(aopr.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
		and	coalesce(aopr.nr_seq_topografia, coalesce(nr_seq_topografia_w,0)) = coalesce(nr_seq_topografia_w,0)
		and	coalesce(aopr.ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w,0)) = coalesce(ie_tipo_atendimento_w,0)
        	and 	aop.ie_situacao = 'A'
			and 	coalesce(aop.ie_tipo_orient, 'P') = 'P'
		and	coalesce(aopr.ie_consulta,'N') = ie_consulta_p
        	order by coalesce(aopr.nr_seq_apres,999), aop.nr_sequencia) alias11;


BEGIN

cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

select	max(ds_orientacao)
into STRICT	ds_orientacao_w
from	procedimento
where	cd_procedimento = cd_procedimento_p
and	ie_origem_proced = ie_origem_proced_p;

if (coalesce(nr_seq_proc_interno_p,0) > 0) then
	select	max(ie_orientacao),
		max(ds_orientacao_usuario),
		max(ds_observacao),
		max(ds_orientacao_pac)
	into STRICT	ie_orientacao_w,
		ds_orientacao_w,
		ds_orientacao_pac_w,
		ds_orientacao_obs_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_p;
	
	select	coalesce(max(cd_plano_convenio),'0'),
		coalesce(max(cd_categoria),'0')
	into STRICT	cd_plano_convenio_w,
		cd_categoria_w
	from	atend_categoria_convenio
	where	nr_atendimento = nr_atendimento_p;
	
	select	coalesce(max(a.qt_idade_paciente),0),
			max(a.cd_medico_exec),
			coalesce(max(a.ie_tipo_atendimento),0),
			coalesce(max(a.cd_topografia_proced),0),
			max(b.cd_estabelecimento)
	into STRICT	qt_idade_w,
		cd_medico_exec_w,
		ie_tipo_atendimento_w,
		nr_seq_topografia_w,
		cd_estab_agenda_w
	from	agenda_paciente a,
			agenda b
	where	a.cd_agenda = b.cd_agenda
	and   	a.nr_sequencia	= nr_seq_agenda_p;
	
	if (cd_estab_agenda_w IS NOT NULL AND cd_estab_agenda_w::text <> '') THEN
			cd_estabelecimento_w := cd_estab_agenda_w;
	end if;

	select	coalesce(max(nr_seq_classif),0)
	into STRICT	nr_seq_classif_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_p;
	
	ds_orient_convenio_w := '';
	ds_orient_paciente_w := '';
	
	open C01;
	loop
	fetch C01 into	
		ds_orient_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_orient_convenio_w := ds_orient_convenio_w;
		end;
	end loop;
	close C01;
	
	open C02;
	loop
	fetch C02 into	
		ds_orient_paciente_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ds_orient_paciente_w := ds_orient_paciente_w;
		end;
	end loop;
	close C02;
	
	if (coalesce(ie_consulta_p,'N') = 'S') then
		begin
		ind := 1;
		while(length(ds_lista_macro_w) > 0) loop
			ds_macro_w := substr(ds_lista_macro_w, 1, position(';' in ds_lista_macro_w)-1);
			ds_lista_macro_w := substr(ds_lista_macro_w, position(';' in ds_lista_macro_w)+1);
			lista_macros_w(ind) := ds_macro_w;
			ind := ind+1;
		end loop;

		open c03;
		loop
		fetch c03 into
			ds_orientacao_ageint_w,
			nr_seq_prep_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			if (ds_orientacao_ageint_w IS NOT NULL AND ds_orientacao_ageint_w::text <> '') then
				ind := lista_macros_w.last;
				while(ind > 0) loop
					select coalesce(max(vl_macro),0)
					into STRICT qt_valor_w
					from AGEINT_ORIENT_PREP_MACRO a
					where ie_macro = ind
					and a.nr_seq_orient_prep_regra in (SELECT x.nr_sequencia
									from AGEINT_ORIENT_PREP_REGRA x
									where coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
									and coalesce(nr_seq_proc_interno,nr_seq_proc_interno_p) = nr_seq_proc_interno_p
									and	coalesce(x.nr_seq_topografia, coalesce(nr_seq_topografia_w,0)) = coalesce(nr_seq_topografia_w,0)
									and	coalesce(x.ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w,0)) = coalesce(ie_tipo_atendimento_w,0)
									and x.nr_seq_orient_preparo = nr_seq_prep_w);
					ds_orientacao_ageint_w := replace_macro_clob(ds_orientacao_ageint_w, lista_macros_w(ind), qt_valor_w);
					ind := ind-1;
				end loop;
				ds_orientacao_ageint_w2 := ds_orientacao_ageint_w2 || ds_orientacao_ageint_w || chr(10);
	    	end if;
			end;
		end loop;
		close c03;
		
		exception
			when others then
				ds_orientacao_ageint_w2 := '';
		end;
	end if;

	if (ds_orientacao_ageint_w2 IS NOT NULL AND ds_orientacao_ageint_w2::text <> '') then
    		ds_orientacao_w := substr(ds_orientacao_ageint_w2,1,4000);	
	elsif (ie_orientacao_w = 'C') then
		ds_orientacao_w := ds_orient_convenio_w;
	elsif (ie_orientacao_w = 'A') and
		((ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') or (ds_orient_convenio_w IS NOT NULL AND ds_orient_convenio_w::text <> '') or (ds_orient_paciente_w IS NOT NULL AND ds_orient_paciente_w::text <> '') or (ds_orientacao_pac_w IS NOT NULL AND ds_orientacao_pac_w::text <> '') or (ds_orientacao_obs_w IS NOT NULL AND ds_orientacao_obs_w::text <> ''))then
		ds_orientacao_w := 	substr(ds_orientacao_w || chr(13) || chr(10) ||
					ds_orient_convenio_w || chr(13) || chr(10) || 
					ds_orient_paciente_w||chr(13)||chr(10)||
					ds_orientacao_pac_w||chr(13)||chr(10)||
					ds_orientacao_obs_w,1,4000);
	elsif (ie_orientacao_w	= 'I') and
		((ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') or (ds_orientacao_pac_w IS NOT NULL AND ds_orientacao_pac_w::text <> '') or (ds_orientacao_obs_w IS NOT NULL AND ds_orientacao_obs_w::text <> ''))
		then
		ds_orientacao_w := 	substr(ds_orientacao_w || chr(13) || chr(10) || 
					ds_orientacao_pac_w||chr(13)||chr(10)||
					ds_orientacao_obs_w,1,4000);
		
	end if;
end if;

return ds_orientacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_orientacao_proc_agexame (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_tipo_classif_pac_p bigint, nr_seq_agenda_p bigint, ie_consulta_p text default 'N') FROM PUBLIC;
