-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_inconsistencias_farm ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_inconsistencia_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE

						
nr_pescricao_w 				prescr_material.nr_prescricao%type;
nr_seq_material_w			prescr_material.nr_sequencia%type;
nr_seq_mat_cpoe_w			prescr_material.nr_seq_mat_cpoe%type;

nr_seq_solucao_w			prescr_solucao.nr_seq_solucao%type;
nr_seq_dialise_cpoe_w		prescr_solucao.nr_seq_dialise_cpoe%type;

nr_seq_Inconsistencia_w 	prescr_material_incon_farm.nr_Seq_Inconsistencia%type;
nr_prescricao_vigente_w		prescr_medica.nr_prescricao%type;
ie_lib_prot_onc_w			gpt_presentation_rule.ie_lib_prot_onc%type;

c01 CURSOR FOR
SELECT 	b.nr_prescricao,
		b.nr_sequencia,
		a.nr_seq_atend
from	prescr_medica a,
		prescr_material b,
		prescr_material_incon_farm c
where 	a.nr_prescricao 			= b.nr_prescricao
and		b.nr_prescricao 			= c.nr_prescricao
and		b.nr_sequencia  			= c.nr_seq_material
and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and 	coalesce(a.dt_liberacao_farmacia::text, '') = ''
and		(a.dt_inicio_analise_farm IS NOT NULL AND a.dt_inicio_analise_farm::text <> '')
and		a.nm_usuario_analise_farm   = nm_usuario_p
and		c.nr_seq_inconsistencia 	= nr_seq_Inconsistencia_w
and		b.nr_seq_mat_cpoe 			= nr_seq_mat_cpoe_w;

c02 CURSOR FOR
SELECT 	b.nr_prescricao,
		b.nr_sequencia_solucao,
		a.nr_seq_atend
from	prescr_medica a,
		prescr_material b,
		prescr_material_incon_farm c
where 	a.nr_prescricao 			= b.nr_prescricao
and		b.nr_prescricao 			= c.nr_prescricao
and		b.nr_sequencia_solucao		= c.nr_seq_solucao
and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and 	coalesce(a.dt_liberacao_farmacia::text, '') = ''
and		(a.dt_inicio_analise_farm IS NOT NULL AND a.dt_inicio_analise_farm::text <> '')
and		a.nm_usuario_analise_farm   = nm_usuario_p
and		c.nr_seq_inconsistencia 	= nr_seq_Inconsistencia_w
and		b.nr_seq_mat_cpoe 			= nr_seq_mat_cpoe_w;

c03 CURSOR FOR
SELECT  a.oid as row_id
from    prescr_material_incon_farm a,
        prescr_solucao b
where   a.nr_prescricao = b.nr_prescricao
and     b.nr_seq_solucao = a.nr_seq_solucao
and     b.nr_prescricao >= nr_prescricao_vigente_w
and     b.nr_seq_dialise_cpoe = nr_seq_dialise_cpoe_w
and		a.nr_seq_inconsistencia = nr_seq_inconsistencia_w;

BEGIN

select	coalesce(max(ie_lib_prot_onc), 'N')
into STRICT	ie_lib_prot_onc_w
from	gpt_presentation_rule
where	cd_perfil = wheb_usuario_pck.get_cd_perfil;

if (nr_prescricao_p > 0) and (nr_sequencia_p > 0)  and (nr_seq_inconsistencia_p > 0) then
	if (ie_opcao_p = 'R') then

		if (obter_funcao_origem_prescr(nr_prescricao_p) = 2314) then

			select	max(a.nr_sequencia_solucao)
			into STRICT	nr_seq_solucao_w
			from	prescr_material a
			where	a.nr_prescricao = nr_prescricao_p
			and		a.nr_sequencia = nr_sequencia_p;

		end if;

		insert	into	prescr_material_incon_farm(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				nr_seq_material,
				nr_seq_solucao,
				nr_seq_inconsistencia,
				ie_situacao)
		values (nextval('prescr_material_incon_farm_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_p,
				nr_sequencia_p,
				nr_seq_solucao_w,
				nr_seq_inconsistencia_p,
				'A');
	end if;
end if;
if (ie_opcao_p = 'E') and (nr_sequencia_p > 0) then

	select 	max(a.nr_prescricao),
			max(a.nr_seq_material),
			max(a.nr_Seq_Inconsistencia),
			max(b.nr_seq_mat_cpoe)
	into STRICT	nr_pescricao_w,
			nr_seq_material_w,
			nr_seq_Inconsistencia_w,
			nr_seq_mat_cpoe_w
	from	prescr_material_incon_farm a,
			prescr_material b,
			prescr_medica c
	where	c.nr_prescricao = b.nr_prescricao
	and		b.nr_prescricao = a.nr_prescricao
	and		b.nr_sequencia  = a.nr_seq_material
	and		coalesce(b.ie_suspenso,'N') <> 'S'
	and		c.cd_funcao_origem not in (924,950)
	and		a.nr_sequencia  = nr_sequencia_p;
	
	if (coalesce(nr_seq_material_w::text, '') = '') then
		
		select 	max(a.nr_prescricao),
				max(a.nr_seq_solucao),
				max(a.nr_Seq_Inconsistencia),
				max(b.nr_seq_mat_cpoe)
		into STRICT	nr_pescricao_w,
				nr_seq_solucao_w,
				nr_seq_Inconsistencia_w,
				nr_seq_mat_cpoe_w
		from	prescr_material_incon_farm a,
				prescr_material b,
				prescr_medica c
		where	c.nr_prescricao 		= b.nr_prescricao
		and		b.nr_prescricao			= a.nr_prescricao
		and		b.nr_sequencia_solucao 	= a.nr_seq_solucao
--		and		b.nr_sequencia  = a.nr_seq_material
		and		ie_agrupador 			in (1,4)
		and		coalesce(b.ie_suspenso,'N') 	<> 'S'
		and		c.cd_funcao_origem 		not in (924,950)
		and		a.nr_sequencia  		= nr_sequencia_p;
		
	end if;
	
	if (obter_funcao_ativa = 252) then
	
		if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then

			for c01_w in c01
			loop

				delete  
				from	prescr_material_incon_farm a
				where 	a.nr_prescricao = c01_w.nr_prescricao
				and		a.nr_seq_material = c01_w.nr_sequencia
				and		a.nr_seq_inconsistencia = nr_seq_Inconsistencia_w;

				if (ie_lib_prot_onc_w = 'S') and (c01_w.nr_seq_atend IS NOT NULL AND c01_w.nr_seq_atend::text <> '') then

					update	prescr_medica_compl a
					set		a.ie_consiste_prot_onc = 'N'
					where	a.nr_prescricao = c01_w.nr_prescricao
					and		not exists (SELECT	1
										from	prescr_material_incon_farm b
										where	b.nr_prescricao = a.nr_prescricao
										and		b.ie_situacao = 'A');

				end if;

			end loop;

		elsif (nr_seq_solucao_w IS NOT NULL AND nr_seq_solucao_w::text <> '') then

			for c02_w in c02
			loop

				delete
				from	prescr_material_incon_farm a
				where 	a.nr_prescricao = c02_w.nr_prescricao
				and		a.nr_seq_solucao = c02_w.nr_sequencia_solucao
				and		a.nr_seq_inconsistencia = nr_seq_Inconsistencia_w;

				if (ie_lib_prot_onc_w = 'S') and (c02_w.nr_seq_atend IS NOT NULL AND c02_w.nr_seq_atend::text <> '') then

					update	prescr_medica_compl
					set		ie_consiste_prot_onc = 'N'
					where	nr_prescricao = c02_w.nr_prescricao;

				end if;

			end loop;
		else

			select	max(b.nr_seq_dialise_cpoe),
					max(a.nr_seq_inconsistencia)
			into STRICT	nr_seq_dialise_cpoe_w,
					nr_seq_inconsistencia_w
			from	prescr_material_incon_farm a,
					prescr_solucao b
			where	a.nr_prescricao = b.nr_prescricao
			and		a.nr_seq_solucao = b.nr_seq_solucao
			and		a.nr_sequencia = nr_sequencia_p;
		
			if (nr_seq_dialise_cpoe_w IS NOT NULL AND nr_seq_dialise_cpoe_w::text <> '') then

				nr_prescricao_vigente_w := gpt_obter_prescricao_vigente(nr_seq_dialise_cpoe_w, 'DI');

				for r_c03_w in c03
				loop

					delete
					from	prescr_material_incon_farm a
					where 	a.rowid = r_c03_w.row_id;

				end loop;
			end if;

		end if;
	
	else
		delete	FROM prescr_material_incon_farm
		where	nr_sequencia = nr_sequencia_p;
	end if;
	

end if;	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_inconsistencias_farm ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_inconsistencia_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
