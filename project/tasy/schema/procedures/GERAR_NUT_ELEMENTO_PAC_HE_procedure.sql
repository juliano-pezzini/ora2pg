-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nut_elemento_pac_he ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_elemento_w		bigint;
nr_sequencia_w			bigint;
nr_sequencia_ww			bigint;
nr_sequencia_www		bigint;
cd_unidade_medida_w		varchar(30);
qt_fase_npt_w			bigint;
nr_seq_glicose_w		bigint;
nr_seq_padrao_w			bigint;
qt_dose_padrao_w		double precision;
qt_fase_w				double precision;
ie_processo_hidrico_w	varchar(15);
ie_tipo_elemento_w		varchar(1);

C01 CURSOR FOR
	SELECT	nr_sequencia,
			cd_unidade_medida,
			ie_tipo_elemento
	from 	nut_elemento
	where	ie_situacao	= 'A'
	and		ie_rep_he	= 'S'
	and		(cd_unidade_medida IS NOT NULL AND cd_unidade_medida::text <> '')
	order by nr_seq_apresent, ds_elemento;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from 	nut_elem_material
	where	ie_situacao	= 'A'
	and		ie_padrao	= 'S'
	and		nr_seq_elemento	= nr_seq_elemento_w
	and		coalesce(ie_tipo,'NPT') = 'NPT'
	order by cd_material;

c04 CURSOR FOR
	SELECT	nr_sequencia,
			qt_dose_padrao
	from	nut_elemento
	where	ie_rep_he 	= 'S'
	and		ie_situacao	= 'A'
	and		nr_sequencia	= nr_seq_elemento_w
	and		coalesce(qt_dose_padrao,0) > 0;


BEGIN

select	coalesce(max(ie_processo_hidrico),'N')
into STRICT	ie_processo_hidrico_w
from	prescr_rep_he
where	nr_sequencia = nr_sequencia_p;

open C01;
loop
fetch C01 into
		nr_seq_elemento_w,
		cd_unidade_medida_w,
		ie_tipo_elemento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_tipo_elemento_w = 'A' AND ie_processo_hidrico_w = 'S') or (ie_tipo_elemento_w <> 'A') then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_sequencia_w
		from	prescr_rep_he_elem
		where	nr_seq_rep_he	= nr_sequencia_p
		and		nr_seq_elemento	= nr_seq_elemento_w;

		if (nr_sequencia_w = 0) then
			begin
			select	nextval('prescr_rep_he_elem_seq')
			into STRICT	nr_sequencia_w
			;

			insert into prescr_rep_he_elem(
				nr_sequencia,
				nr_seq_rep_he,
				nr_seq_elemento,
				dt_atualizacao,
				nm_usuario,
				cd_unidade_medida,
				qt_elem_kg_dia,
				qt_diaria,
				qt_volume,
				qt_volume_corrigido,
				qt_volume_etapa,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
			values (
				nr_sequencia_w,
				nr_sequencia_p,
				nr_seq_elemento_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_unidade_medida_w,
				0,
				0,
				0,
				0,
				0,
				clock_timestamp(),
				nm_usuario_p);

			open C02;
			loop
			fetch C02 into
					nr_sequencia_www;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				select	nextval('prescr_rep_he_elem_mat_seq')
				into STRICT	nr_sequencia_ww
				;

				insert into prescr_rep_he_elem_mat(
					nr_sequencia,
					nr_seq_ele_rep,
					dt_atualizacao,
					nm_usuario,
					nr_seq_elem_mat,
					qt_volume,
					qt_vol_cor,
					dt_atualizacao_nrec,
					nm_usuario_nrec)
				values (	nr_sequencia_ww,
					nr_sequencia_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_sequencia_www,
					null,
					null,
					clock_timestamp(),
					nm_usuario_p);
			end loop;
			close C02;
			end;

			if (ie_tipo_elemento_w = 'C') then
				CALL Atualizar_rep_he_elem_mat(nr_sequencia_w,nm_usuario_p,ie_processo_hidrico_w);
			end if;

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_glicose_w
			from	nut_elemento
			where	ie_tipo_elemento = 'C';

			open C04;
			loop
			fetch C04 into
					nr_seq_padrao_w,
					qt_dose_padrao_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				update	prescr_rep_he_elem a
				set		qt_elem_kg_dia		= qt_dose_padrao_w
				where	nr_seq_rep_he		= nr_sequencia_p
				and		nr_seq_elemento		<> nr_seq_glicose_w
				and		nr_seq_elemento		= nr_seq_padrao_w
				and		qt_elem_kg_dia		= 0;

			end loop;
			close C04;
		end if;
	end if;
	end;

end Loop;
close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nut_elemento_pac_he ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
