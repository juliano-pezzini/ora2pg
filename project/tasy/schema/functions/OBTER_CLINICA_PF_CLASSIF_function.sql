-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_clinica_pf_classif ( cd_funcao_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
qt_regra_w		bigint;
qt_regra_sem_classif_w	bigint;
ds_retorno_w		varchar(80);
nr_seq_classif_w		bigint;
ie_clinica_w		integer;
qt_perm_w		bigint;
nr_seq_classif_ww		bigint;
ds_classificacao_w		varchar(80);
ds_classif_retorno_w	varchar(80);
qt_regra_agenda_w		bigint;
cd_perfil_w		integer;
qt_especialidade_w		bigint;
cd_especialidade_w	varchar(80);
ie_perm_espec_w		varchar(1);
cd_especialidade_regra_w	 bigint;
nr_Seq_Classif_pf_W	bigint;
ds_classif_esp_ret_w	varchar(80);
ie_consiste_classif_w	varchar(1);

C01 CURSOR FOR 
	SELECT	ie_clinica, 
		nr_sequencia 
	from	pessoa_classif 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	((dt_referencia_p >= dt_inicio_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = '')) 
	and	((Dt_referencia_p <= dt_final_vigencia) or (coalesce(dt_final_vigencia::text, '') = '')) 
	and	((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = '')) 
	order by ie_clinica;
	
C02 CURSOR FOR 
	SELECT	cd_especialidade 
	from	pessoa_classif_espec 
	where	nr_seq_classif_pf	= nr_Seq_Classif_pf_W 
	and	((dt_referencia_p >= dt_inicio_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = '')) 
	and	((Dt_referencia_p <= dt_fim_vigencia) or (coalesce(dt_fim_vigencia::text, '') = '')) 
	and	ie_perm_espec_w		= 'N' 
	order by nr_sequencia;
	

BEGIN 
 
cd_perfil_w := Obter_perfil_Ativo;
 
 
select	max(cd_especialidade) 
into STRICT	cd_especialidade_w 
from	agenda 
where	cd_agenda	= cd_agenda_p;
 
	 
	open C01;
	loop 
	fetch C01 into	 
		ie_clinica_w, 
		nr_Seq_Classif_pf_W;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ie_clinica_w			:=	ie_clinica_w;
		 
			if (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '')then 
				select	coalesce(max(ie_classif_pf_agenda), 'N') 
				into STRICT	ie_consiste_classif_w 
				from	especialidade_medica 
				where	cd_especialidade	= cd_especialidade_w;
			end if;	
			ie_perm_espec_w	:=	'N';
			 
			select	count(*) 
			into STRICT	qt_especialidade_w 
			from	pessoa_classif_espec 
			where	nr_seq_classif_pf	= nr_Seq_Classif_pf_W;
			 
			if (ie_consiste_classif_w	= 'S') and (qt_especialidade_w	> 0) and (cd_especialidade_w > 0)	then 
				open C02;
				loop 
				fetch C02 into	 
					cd_especialidade_regra_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin 
					if (cd_especialidade_regra_w	= cd_Especialidade_w) then 
						ie_perm_espec_w	:= 'S';
					end if;
					end;
				end loop;
				close C02;
			else 
				ie_perm_espec_w	:= 'S';
			end if;			
		end;
	end loop;
	close C01;
	 
 
if	(((ie_perm_espec_w = 'S') or (qt_especialidade_w = 0)) and (ie_clinica_w <> 0)) then 
	begin 
	ds_retorno_w	:=	ie_clinica_w;
	end;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_clinica_pf_classif ( cd_funcao_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;

