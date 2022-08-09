-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_alerta_api ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_api_p text, ds_resultado_curto_p text, ds_resultado_p text, nr_gravidade_p bigint, nr_seq_cpoe_p bigint default null, cd_material_p bigint default null, nr_seq_controle_p bigint default null, ds_sub_tipo_api_p text default null, nr_seq_id_client_p bigint default null, nr_agrupamento_p bigint default null, ds_itens_interacao_p text default null) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_registro_w	bigint;
nr_gravidade_w		alerta_api.nr_gravidade%type;
nr_count_w			integer;


BEGIN

if	((nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_prescricao_p > 0) or (coalesce(nr_seq_cpoe_p,0) > 0)) then
	
	select 	coalesce(max(nr_sequencia), 0)
	into STRICT 	nr_seq_registro_w
	from 	prescr_material
	where 	nr_sequencia 	= nr_seq_material_p
	and 	nr_prescricao 	= nr_prescricao_p;
	
	if (nr_seq_registro_w > 0) or (coalesce(nr_seq_cpoe_p,0) > 0) then

		nr_gravidade_w := get_severity_level(nr_gravidade_p, cd_api_p);

		if (coalesce(nr_seq_cpoe_p,0) > 0) then
			select count(*)
			  into STRICT nr_count_w
			  from alerta_api a
			 where a.nr_seq_id_medispan = nr_seq_id_client_p
			   and a.nr_seq_cpoe = nr_seq_cpoe_p
			   and a.cd_material = cd_material_p
			   and a.nr_gravidade = nr_gravidade_w
			   and a.cd_api = cd_api_p
			   and ((cd_api_p = 'C') and (a.nr_agrupamento = nr_agrupamento_p)
			    or (cd_api_p <> 'C'));
		else
			select count(*)
			  into STRICT nr_count_w
			  from alerta_api a
			 where a.nr_seq_id_medispan = nr_seq_id_client_p
			   and a.nr_prescricao = nr_prescricao_p
			   and a.nr_seq_material = nr_seq_material_p
			   and a.nr_gravidade = nr_gravidade_w
			   and a.cd_api = cd_api_p
			   and ((cd_api_p = 'C') and (a.nr_agrupamento = nr_agrupamento_p)
			    or (cd_api_p <> 'C'));
		end if;

		/* Controle para evitar duplicidade */

		if (nr_count_w = 0) then

			select	nextval('alerta_api_seq')
			into STRICT	nr_sequencia_w
			;
			
			insert into alerta_api(
				nr_sequencia,		
				nr_prescricao,
				nr_seq_material,
				cd_api,
				ds_resultado_curto,
				ds_resultado,
				nr_gravidade,
				nr_seq_cpoe,
				cd_material,
				nr_seq_controle,
				ds_sub_tipo_api,
				nr_seq_id_medispan,
				nr_agrupamento,
				ds_itens_interacao)
			values (	
				nr_sequencia_w,		
				nr_prescricao_p,
				nr_seq_material_p,
				cd_api_p,
				substr(ds_resultado_curto_p, 1, 2000),
				ds_resultado_p,
				nr_gravidade_w,
				nr_seq_cpoe_p,
				cd_material_p,
				nr_seq_controle_p,
				ds_sub_tipo_api_p,
				nr_seq_id_client_p,
				nr_agrupamento_p,
				ds_itens_interacao_p);

			commit;

		end if;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_alerta_api ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_api_p text, ds_resultado_curto_p text, ds_resultado_p text, nr_gravidade_p bigint, nr_seq_cpoe_p bigint default null, cd_material_p bigint default null, nr_seq_controle_p bigint default null, ds_sub_tipo_api_p text default null, nr_seq_id_client_p bigint default null, nr_agrupamento_p bigint default null, ds_itens_interacao_p text default null) FROM PUBLIC;
