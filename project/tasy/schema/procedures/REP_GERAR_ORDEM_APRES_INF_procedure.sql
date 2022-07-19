-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_gerar_ordem_apres_inf ( nr_seq_grupo_p bigint, ie_acm_sn_final_p text, ie_informacao_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_item_w		varchar(255);
ie_acm_sn_w		varchar(1);
ie_via_aplicacao_w	varchar(5);
ie_ordem_rep_w		varchar(5);
cd_material_w		integer;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
nr_agrupamento_w	bigint;
nr_seq_apres_w		smallint := 9999;

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_item,
	ie_acm_sn,
	coalesce(ie_via_aplicacao,'XXXX'),
	nr_agrupamento
from	w_copia_rep
where	ie_tipo_item = ie_informacao_p;


BEGIN
if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then
	begin
	if (ie_informacao_p = 'M') then
		begin
		open c01;
		loop
		fetch c01 into	nr_sequencia_w,
				cd_item_w,
				ie_acm_sn_w,
				ie_via_aplicacao_w,
				nr_agrupamento_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			--if	(ie_via_aplicacao_w is not null) then
			--	begin
				cd_material_w := (cd_item_w)::numeric;

				select	coalesce(obter_estrutura_material(cd_material_w,'G'),0),
					coalesce(obter_estrutura_material(cd_material_w,'S'),0),
					coalesce(obter_estrutura_material(cd_material_w,'C'),0)
				into STRICT	cd_grupo_material_w,
					cd_subgrupo_material_w,
					cd_classe_material_w
				;

				select	coalesce(max(ie_ordem_rep),'N')
				into STRICT	ie_ordem_rep_w
				from	regra_ordem_grupo_rep
				where	nr_sequencia	= nr_seq_grupo_p;

				if (ie_acm_sn_w = 'N') then
					select	coalesce(min(nr_seq_apres),999)
					into STRICT	nr_seq_apres_w
					from	regra_ordem_medic_rep
					where	nr_seq_grupo = nr_seq_grupo_p
					and	coalesce(cd_material, cd_material_w) = cd_material_w
					and	coalesce(cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
					and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
					and	coalesce(cd_classe_material, cd_classe_material_w) = cd_classe_material_w
					and	coalesce(ie_via_aplicacao, ie_via_aplicacao_w) = ie_via_aplicacao_w
					and	((cd_material IS NOT NULL AND cd_material::text <> '') or (cd_grupo_material IS NOT NULL AND cd_grupo_material::text <> '') or (cd_subgrupo_material IS NOT NULL AND cd_subgrupo_material::text <> '') or (cd_classe_material IS NOT NULL AND cd_classe_material::text <> '') or (ie_via_aplicacao IS NOT NULL AND ie_via_aplicacao::text <> ''));
				end if;

				if (ie_acm_sn_w = 'S') and (ie_acm_sn_final_p = 'S') then
					begin
					nr_seq_apres_w := 9999;

					update	w_copia_rep
					set	nr_seq_apres_inf = nr_seq_apres_w
					where	nr_sequencia = nr_sequencia_w;

					end;
				else
					begin

					if (ie_ordem_rep_w = 'S') then
						nr_seq_apres_w	:= nr_agrupamento_w;
					end if;

					update	w_copia_rep
					set	nr_seq_apres_inf = nr_seq_apres_w
					where	nr_sequencia = nr_sequencia_w;

					end;
				end if;
				end;

			--end if;
			--end;
		end loop;
		close c01;
		end;
	end if;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_gerar_ordem_apres_inf ( nr_seq_grupo_p bigint, ie_acm_sn_final_p text, ie_informacao_p text) FROM PUBLIC;

