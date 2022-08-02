-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_gravar_historico ( nr_prescricao_p bigint, nm_usuario_p text, ie_momento_geracao_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_material_w		integer;
ds_horarios_w			varchar(2000);
qt_dose_w			double precision;
cd_unidade_medida_w		varchar(30);
cd_intervalo_w			varchar(7);
ie_via_aplicacao_w		varchar(5);

C01 CURSOR FOR
SELECT	nr_sequencia,
	ds_horarios,
	qt_dose,
	cd_unidade_medida,
	cd_intervalo,
	ie_via_aplicacao
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	(ds_horarios IS NOT NULL AND ds_horarios::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_material_w,
	ds_horarios_w,
	qt_dose_w,
	cd_unidade_medida_w,
	cd_intervalo_w,
	ie_via_aplicacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('prescr_mat_hist_seq')
	into STRICT	nr_sequencia_w
	;

	insert into prescr_mat_hist(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_momento_geracao,
		nr_prescricao,
		nr_seq_material,
		ds_horarios,
		qt_dose,
		cd_unidade_medida,
		cd_intervalo,
		ie_via_aplicacao)
	values (nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_momento_geracao_p,
		nr_prescricao_p,
		nr_seq_material_w,
		ds_horarios_w,
		qt_dose_w,
		cd_unidade_medida_w,
		cd_intervalo_w,
		ie_via_aplicacao_w);

	end;
end loop;
close C01;

--if (nvl(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_gravar_historico ( nr_prescricao_p bigint, nm_usuario_p text, ie_momento_geracao_p text) FROM PUBLIC;

