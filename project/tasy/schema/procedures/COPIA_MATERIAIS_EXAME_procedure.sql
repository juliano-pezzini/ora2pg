-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_materiais_exame ( nr_seq_exame_p bigint, cd_exame_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_exame_w		bigint;


BEGIN


select	max(nr_seq_exame)
into STRICT	nr_seq_exame_w
from	exame_laboratorio
where	upper(cd_exame) = upper(cd_exame_p);

insert into exame_lab_material(nr_seq_exame,
	nr_seq_material,
	ie_prioridade,
	dt_atualizacao,
	nm_usuario,
	ds_unidade_medida,
	qt_decimais,
	ds_formula,
	cd_equipamento,
	ie_formato_resultado,
	qt_coleta,
	nr_etiqueta,
	ie_situacao,
	nr_seq_unid_med,
	qt_volume_referencia,
	nr_seq_conservacao,
	nr_seq_unid_med_volume)
SELECT	nr_seq_exame_p,
	nr_seq_material,
	ie_prioridade,
	clock_timestamp(),
	nm_usuario_p,
	ds_unidade_medida,
	qt_decimais,
	ds_formula,
	cd_equipamento,
	ie_formato_resultado,
	qt_coleta,
	nr_etiqueta,
	ie_situacao,
	nr_seq_unid_med,
	qt_volume_referencia,
	nr_seq_conservacao,
	nr_seq_unid_med_volume
from	exame_lab_material a
where	nr_seq_exame	= nr_seq_exame_w
and	not exists (select 1 from exame_lab_material w
		   where w.nr_seq_exame = nr_seq_exame_p
		   and w.nr_seq_material = a.nr_seq_material);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_materiais_exame ( nr_seq_exame_p bigint, cd_exame_p text, nm_usuario_p text) FROM PUBLIC;
