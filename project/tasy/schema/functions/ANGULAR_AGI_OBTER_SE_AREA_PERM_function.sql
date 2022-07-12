-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION angular_agi_obter_se_area_perm ( nr_seq_area_p bigint, cd_perfil_p bigint, cd_pessoa_Fisica_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 				varchar(1)	:= 'N';
qt_perm_Regra_w     		integer;
qt_regra_w   				integer;
nr_seq_regra_w      		ageint_regra_perm_area.nr_sequencia%type;
ie_regra_lib_area_perm_w	parametro_agenda_integrada.ie_regra_lib_area_perm%type;

C01 CURSOR FOR
     SELECT  nr_sequencia
     from    ageint_regra_perm_area
     where   coalesce(nr_seq_area,nr_seq_area_p)  = nr_seq_area_p
     and     ((coalesce(cd_pessoa_Fisica,cd_pessoa_fisica_p)          = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica_p::text, '') = ''))
     and     ((coalesce(cd_perfil, cd_perfil_p)                       = cd_perfil_p) or (coalesce(cd_perfil_p::text, '') = ''))
     and     ((coalesce(cd_setor_atendimento, cd_setor_atendimento_p) = cd_setor_atendimento_p) or (coalesce(cd_setor_atendimento_p::text, '') = ''))
     and     ie_situacao                     = 'A'
     and     ((coalesce(cd_estabelecimento, cd_estabelecimento_p)   = cd_estabelecimento_p) or (coalesce(cd_estabelecimento_p::text, '') = ''))
     order by coalesce(nr_seq_area,0),
              coalesce(cd_pessoa_fisica,'0'),
              coalesce(cd_perfil,0),
              coalesce(cd_setor_atendimento,0);
			
c02 CURSOR FOR
	SELECT	nr_sequencia
	from	ageint_regra_perm_area
	where	nr_seq_area	= nr_seq_area_p
	and		((coalesce(cd_pessoa_Fisica,cd_pessoa_fisica_p) = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica_p::text, '') = ''))
	and		((coalesce(cd_perfil, cd_perfil_p)	= cd_perfil_p) or (coalesce(cd_perfil_p::text, '') = ''))
	and		((coalesce(cd_setor_atendimento, cd_setor_atendimento_p) = cd_setor_atendimento_p) or (coalesce(cd_setor_atendimento_p::text, '') = ''))
	and		ie_situacao	= 'A'
	and		((coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p) or (coalesce(cd_estabelecimento_p::text, '') = ''))
	order by
		coalesce(cd_pessoa_fisica, '0'),
		coalesce(cd_setor_atendimento, 0),
		coalesce(cd_perfil, 0);

BEGIN

select 	coalesce(max(ie_regra_lib_area_perm),'N')
into STRICT	ie_regra_lib_area_perm_w
from	parametro_agenda_integrada
where	coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;

if (ie_regra_lib_area_perm_w = 'S') then

	open C01;
	loop
	fetch C01 into
		 nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		 begin
		 nr_seq_regra_w := nr_seq_regra_w;
		 end;
	end loop;
	close C01;

	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
		 select  coalesce(max(ie_perm_visualizar),'S')
		 into STRICT    ds_retorno_w
		 from    ageint_regra_perm_area
		 where   nr_sequencia = nr_seq_regra_w;
	else
		 ds_retorno_w := 'S';
	end if;

else

	select	count(*)
	into STRICT	qt_regra_w
	from	ageint_regra_perm_area
	where	nr_seq_area	= nr_seq_area_p
	and		ie_situacao	= 'A'
	and		coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;

	if (qt_regra_w	> 0) then
	
		for c_02 in c02 loop
			nr_seq_regra_w := c_02.nr_sequencia;
		end loop;
		
		if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
		
			select  coalesce(max(ie_perm_visualizar),'S')
			into STRICT    ds_retorno_w
			from    ageint_regra_perm_area
			where   nr_sequencia = nr_seq_regra_w;
		
		else
			ds_retorno_w := 'S';
		end if;
	else
		ds_Retorno_w	:= 'S';
	end if;

end if;

return       ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION angular_agi_obter_se_area_perm ( nr_seq_area_p bigint, cd_perfil_p bigint, cd_pessoa_Fisica_p text, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

