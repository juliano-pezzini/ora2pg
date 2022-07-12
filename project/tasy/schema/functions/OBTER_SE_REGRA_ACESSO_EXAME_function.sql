-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_acesso_exame ( cd_perfil_p bigint, cd_convenio_p bigint, nr_seq_exame_p bigint, nr_seq_grupo_p bigint, ie_tipo_consulta_p text, nr_prescricao_p bigint default null, nr_seq_prescr_p bigint default null, ie_tipo_atendimento_p bigint default null) RETURNS varchar AS $body$
DECLARE


/*
ie_tipo_consulta_p  (Tipo de acesso utilizado no laboratorio Web):
P : Paciente
A : Atendimento
C : Credenciado / Medico
*/
			
ie_restricao_w		varchar(1);
ie_restricao_regra_w	varchar(1);
qt_regra_exame_w	bigint;	
ds_resultado_w		exame_lab_result_item.ds_resultado%type;	

			
c01 CURSOR FOR
	SELECT	coalesce(ie_permite_acesso_internet,'S')
	from	lab_regra_visual_exame
	where	ie_situacao 	= 'A'
	and	coalesce(cd_perfil, coalesce(cd_perfil_p,0))	 = coalesce(cd_perfil_p,0)
	and	coalesce(cd_convenio, coalesce(cd_convenio_p,0))	 = coalesce(cd_convenio_p,0)
	and	coalesce(nr_seq_exame, coalesce(nr_seq_exame_p,0)) = coalesce(nr_seq_exame_p,0)
	and	coalesce(nr_seq_grupo, coalesce(nr_seq_grupo_p,0)) = coalesce(nr_seq_grupo_p,0)
	and coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p, 0)) = coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(ds_resultado, coalesce(ds_resultado_w, ' ')) = coalesce(ds_resultado_w, ' ')
	order 	by  cd_perfil desc , nr_seq_exame desc, nr_seq_grupo desc,  cd_convenio desc;
	
	
c02 CURSOR FOR
	SELECT	coalesce(ie_permite_acesso_internet_med,'S')
	from	lab_regra_visual_exame
	where	ie_situacao 	= 'A'
	and	coalesce(cd_perfil, coalesce(cd_perfil_p,0))	 = coalesce(cd_perfil_p,0)
	and	coalesce(cd_convenio, coalesce(cd_convenio_p,0))	 = coalesce(cd_convenio_p,0)
	and	coalesce(nr_seq_exame, coalesce(nr_seq_exame_p,0)) = coalesce(nr_seq_exame_p,0)
	and	coalesce(nr_seq_grupo, coalesce(nr_seq_grupo_p,0)) = coalesce(nr_seq_grupo_p,0)
	and coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p, 0)) = coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(ds_resultado, coalesce(ds_resultado_w, ' ')) = coalesce(ds_resultado_w, ' ')
	order 	by  cd_perfil desc , nr_seq_exame desc, nr_seq_grupo desc,  cd_convenio desc;	
	

BEGIN

ie_restricao_w := 'S';

select	count(*)
into STRICT	qt_regra_exame_w
from	lab_regra_visual_exame;

if (qt_regra_exame_w > 0) then
		
	if(nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then
		select MAX(coalesce(ds_resultado, coalesce(qt_resultado,pr_resultado)))
		into STRICT 	ds_resultado_w
		from	exame_lab_resultado a,
			exame_lab_result_item b
		where  a.nr_seq_resultado = b.nr_seq_resultado
		and	a.nr_prescricao = nr_prescricao_p
		and 	b.nr_seq_prescr = nr_seq_prescr_p
		and 	b.nr_seq_exame = nr_seq_exame_p;
	end if;
		
        if 	((ie_tipo_consulta_p = 'P') or (ie_tipo_consulta_p = 'A')) then
	
	        open c01;
	        loop
	        fetch c01 into
		        ie_restricao_regra_w;
	        EXIT WHEN NOT FOUND; /* apply on c01 */
		        begin
		        ie_restricao_w := ie_restricao_regra_w;
		        end;
	        end loop;
	        close c01;		
		
        elsif (ie_tipo_consulta_p = 'C') then
	
		open c02;
		loop
		fetch c02 into
			ie_restricao_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			ie_restricao_w := ie_restricao_regra_w;
			end;
		end loop;
		close c02;

	end if;
end if;

return	ie_restricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_acesso_exame ( cd_perfil_p bigint, cd_convenio_p bigint, nr_seq_exame_p bigint, nr_seq_grupo_p bigint, ie_tipo_consulta_p text, nr_prescricao_p bigint default null, nr_seq_prescr_p bigint default null, ie_tipo_atendimento_p bigint default null) FROM PUBLIC;

