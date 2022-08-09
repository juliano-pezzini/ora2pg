-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_qt_total_dias_lib (nr_prescricao_p bigint, nr_seq_material_p bigint) AS $body$
DECLARE


nr_prescricao_w			prescr_medica.nr_prescricao%type;
cd_material_w			prescr_material.cd_material%type;
ie_objetivo_w			prescr_material.ie_objetivo%type;
qt_total_dias_lib_w			prescr_material.qt_total_dias_lib%type;
cd_intervalo_w			prescr_material.cd_intervalo%type;	
ie_lib_auto_w			varchar(1) := 'N';
cd_perfil_w            			 bigint;
cd_estabelecimento_w		bigint;
ie_pend_dias_solic_w		varchar(1) := 'N';
cd_funcao_w			prescr_medica.cd_funcao_origem%type;
dt_prescricao_w			prescr_medica.dt_prescricao%type;
dt_posterior_w			prescr_medica.dt_prescricao%type;
nr_atendimento_w			prescr_medica.nr_atendimento%type;
cd_pessoa_fisica_w		prescr_medica.cd_pessoa_fisica%type;
ie_atb_pessoa_w			varchar(1);
cd_setor_atendimento_w		prescr_medica.cd_setor_atendimento%type;

c01 CURSOR FOR
SELECT	a.nr_prescricao
from	prescr_material a
where	a.nr_prescricao_original = nr_prescricao_p
and		a.cd_material = cd_material_w
and		(a.qt_total_dias_lib IS NOT NULL AND a.qt_total_dias_lib::text <> '')
and		coalesce(a.ie_ciclo_reprov::text, '') = ''

union all

SELECT	a.nr_prescricao
from 	prescr_material a,
		prescr_medica b
where 	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao <> nr_prescricao_p
and		a.ie_suspenso <> 'S'
and		((b.dt_inicio_prescr between dt_prescricao_w and dt_posterior_w) or (b.dt_prescricao between dt_prescricao_w and dt_posterior_w))
and 	coalesce(ie_ciclo_reprov,'N') = 'N'
and		b.nr_atendimento = nr_atendimento_w
and		a.cd_material = cd_material_w
and		coalesce(a.nr_prescricao_original::text, '') = ''
order by 1;

c02 CURSOR FOR
SELECT	a.nr_prescricao
from 	prescr_material a,
	prescr_medica b
where 	a.nr_prescricao	= b.nr_prescricao
and	a.nr_prescricao <> nr_prescricao_p
and	a.ie_suspenso	<> 'S'
and	((b.dt_inicio_prescr between dt_prescricao_w and dt_posterior_w) or (b.dt_prescricao between dt_prescricao_w and dt_posterior_w))
and 	coalesce(ie_ciclo_reprov,'N') = 'N'	
and	coalesce(ie_atb_pessoa_w,'N') = 'N'
and	b.nr_atendimento	= nr_atendimento_w
and	a.cd_material  	= cd_material_w

union all

SELECT	a.nr_prescricao
from 	prescr_material a,
	prescr_medica b
where 	a.nr_prescricao  = b.nr_prescricao
and	b.nr_prescricao	  <> nr_prescricao_p
and 	a.ie_suspenso	  <> 'S'
and	((b.dt_inicio_prescr between dt_prescricao_w and dt_posterior_w) or (b.dt_prescricao between dt_prescricao_w and dt_posterior_w))
and 	coalesce(ie_ciclo_reprov,'N') = 'N'	
and	coalesce(ie_atb_pessoa_w,'N') = 'S'
and 	b.cd_pessoa_fisica	   = cd_pessoa_fisica_w
and	a.cd_material 	   = cd_material_w
order by 1;



BEGIN


cd_perfil_w		:= coalesce(obter_perfil_ativo,0);
cd_estabelecimento_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);

select	max(cd_material),
	max(qt_total_dias_lib),
	max(cd_intervalo),
	max(ie_objetivo)
into STRICT 	cd_material_w,
	qt_total_dias_lib_w,
	cd_intervalo_w,
	ie_objetivo_w
from  	prescr_material                                                                                                                                                                                                                               
where 	nr_sequencia 	= nr_seq_material_p                                                                                                                                                                                                           
and	nr_prescricao 	= nr_prescricao_p                                                                                                                                                                                                             
and	(qt_total_dias_lib IS NOT NULL AND qt_total_dias_lib::text <> '');

select 	coalesce(max(cd_funcao_origem),924),
	max(dt_prescricao),
	max(nr_atendimento),
	max(cd_pessoa_fisica),
	max(cd_setor_atendimento)
into STRICT   	cd_funcao_w,
	dt_prescricao_w,
	nr_atendimento_w,
	cd_pessoa_fisica_w,
	cd_setor_atendimento_w
from   	prescr_medica
where  	nr_prescricao = nr_prescricao_p;


select	coalesce(max(ie_atb_pessoa),'N')
into STRICT	ie_atb_pessoa_w
from	parametro_medico
where	cd_estabelecimento	= cd_estabelecimento_w;

dt_posterior_w	:= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_prescricao_w) + qt_total_dias_lib_w;

ie_lib_auto_w  	:= Obter_se_lib_aut_antimic(cd_material_w, cd_perfil_w, cd_estabelecimento_w, wheb_usuario_pck.get_nm_usuario, cd_intervalo_w, cd_setor_atendimento_w, ie_objetivo_w);

ie_pend_dias_solic_w := obter_param_usuario(896, 7, cd_perfil_w, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_w, ie_pend_dias_solic_w);

if (cd_funcao_w = 950) then
	if (ie_lib_auto_w = 'S') then
		open C01;
		loop
		fetch C01 into	
		nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			update prescr_material
			set      qt_total_dias_lib    = qt_total_dias_lib_w
			where nr_prescricao        = nr_prescricao_w
			and  cd_material	        = cd_material_w
			and  (qt_total_dias_lib IS NOT NULL AND qt_total_dias_lib::text <> '');
			commit;
		end loop;
		close C01;
	end if;
else
	if (ie_pend_dias_solic_w = 'S') then
		open C02;
		loop
		fetch C02 into	
		nr_prescricao_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		update 	prescr_material
		set	qt_total_dias_lib      = qt_total_dias_lib_w
		where	nr_prescricao          = nr_prescricao_w
		and	cd_material             = cd_material_w;
			
		commit;
			
		end loop;
		close C02;
	end if;
end if;	


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_qt_total_dias_lib (nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;
