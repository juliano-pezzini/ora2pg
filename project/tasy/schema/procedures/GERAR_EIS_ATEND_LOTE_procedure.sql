-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_atend_lote ( dt_parametro_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



nr_sequencia_w			bigint;
cd_setor_atendimento_w		integer;
nr_seq_turno_w			bigint;
cd_local_estoque_w		bigint;
nr_seq_classif_w		bigint;
nr_seq_lote_sup_w		bigint;
nm_usuario_geracao_w		varchar(15);
dt_geracao_lote_w		timestamp;
dt_disp_farmacia_w		timestamp;
dt_limite_disp_farm_w		timestamp;
dt_entrega_setor_w		timestamp;
dt_limite_entrega_setor_w	timestamp;
dt_recebimento_setor_w		timestamp;
dt_limite_receb_setor_w		timestamp;

qt_min_atraso_entrega_w		double precision;
qt_min_atraso_disp_w		double precision;
qt_min_atraso_receb_w		double precision;
qt_atraso_entrega_w		double precision;
qt_atraso_disp_w		double precision;
qt_atraso_receb_w		double precision;
dt_inicio_w			timestamp;
dt_final_w			timestamp;
qt_existe_w			bigint;
cd_estab_lote_w		smallint;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
			a.cd_setor_atendimento,
			a.nr_seq_turno,
			a.nr_seq_classif,
			a.cd_local_estoque,
			coalesce(a.nm_usuario_atend, a.nm_usuario_geracao),
			a.nr_seq_lote_sup,
			a.dt_geracao_lote,
			a.dt_disp_farmacia,
			a.dt_limite_disp_farm,
			a.dt_entrega_setor,
			a.dt_limite_entrega_setor,
			a.dt_recebimento_setor,
			a.dt_limite_receb_setor,
			b.cd_estabelecimento
	from	ap_lote a,
			prescr_medica b
	where	a.nr_prescricao = b.nr_prescricao
	and 	a.dt_atend_farmacia between dt_inicio_w and dt_final_w;



BEGIN

dt_inicio_w := trunc(dt_parametro_p,'mm');
dt_final_w := fim_mes(dt_parametro_p);

delete
from	eis_atend_lote
where	dt_referencia = dt_inicio_w;
commit;


open C01;
loop
fetch C01 into
	nr_sequencia_w,
	cd_setor_atendimento_w,
	nr_seq_turno_w,
	nr_seq_classif_w,
	cd_local_estoque_w,
	nm_usuario_geracao_w,
	nr_seq_lote_sup_w,
	dt_geracao_lote_w,
	dt_disp_farmacia_w,
	dt_limite_disp_farm_w,
	dt_entrega_setor_w,
	dt_limite_entrega_setor_w,
	dt_recebimento_setor_w,
	dt_limite_receb_setor_w,
	cd_estab_lote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	qt_atraso_disp_w := 0;

	if (dt_disp_farmacia_w IS NOT NULL AND dt_disp_farmacia_w::text <> '') and (dt_limite_disp_farm_w IS NOT NULL AND dt_limite_disp_farm_w::text <> '') and (dt_limite_disp_farm_w < dt_disp_farmacia_w) then
		qt_atraso_disp_w := 1;
	end if;

	qt_atraso_entrega_w := 0;

	if (dt_entrega_setor_w IS NOT NULL AND dt_entrega_setor_w::text <> '') and (dt_limite_entrega_setor_w IS NOT NULL AND dt_limite_entrega_setor_w::text <> '') and (dt_limite_entrega_setor_w < dt_entrega_setor_w) then
		qt_atraso_entrega_w := 1;
	end if;

	qt_atraso_receb_w := 0;

	if (dt_recebimento_setor_w IS NOT NULL AND dt_recebimento_setor_w::text <> '') and (dt_limite_receb_setor_w IS NOT NULL AND dt_limite_receb_setor_w::text <> '') and (dt_limite_receb_setor_w < dt_recebimento_setor_w) then
		qt_atraso_receb_w := 1;
	end if;

	qt_min_atraso_disp_w := 0;

	if (qt_atraso_disp_w > 0)then
		qt_min_atraso_disp_w := obter_min_entre_datas(dt_limite_disp_farm_w,dt_disp_farmacia_w,1);
	end if;

	qt_min_atraso_entrega_w := 0;

	if (qt_atraso_entrega_w > 0)then
		qt_min_atraso_entrega_w := obter_min_entre_datas(dt_limite_entrega_setor_w,dt_entrega_setor_w,1);
	end if;

	qt_min_atraso_receb_w := 0;

	if (qt_atraso_receb_w > 0)then
		qt_min_atraso_receb_w := obter_min_entre_datas(dt_limite_receb_setor_w,dt_recebimento_setor_w,1);
	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	eis_atend_lote
	where	cd_setor_atendimento	= cd_setor_atendimento_w
	and		nr_seq_turno 			= nr_seq_turno_w
	and		nr_seq_classif 			= nr_seq_classif_w
	and		cd_local_estoque 		= cd_local_estoque_w
	and		dt_referencia 			= dt_inicio_w;

	if (qt_existe_w = 0) then

		insert into eis_atend_lote(
			nr_sequencia,
			ie_periodo,
			dt_atualizacao,
			nm_usuario,
			cd_setor_atendimento,
			nr_seq_turno,
			nr_seq_classif,
			cd_local_estoque,
			qt_atraso_entrega,
			qt_atraso_disp,
			qt_atraso_receb,
			qt_min_atraso_entrega,
			qt_min_atraso_disp,
			qt_min_atraso_receb,
			nm_usuario_atend,
			dt_referencia,
			cd_estabelecimento)
		values (	nr_sequencia_w,
			'D',
			clock_timestamp(),
			nm_usuario_p,
			cd_setor_atendimento_w,
			coalesce(nr_seq_turno_w,0),
			coalesce(nr_seq_classif_w,0),
			coalesce(cd_local_estoque_w,0),
			qt_atraso_entrega_w,
			qt_atraso_disp_w,
			qt_atraso_receb_w,
			qt_min_atraso_entrega_w,
			qt_min_atraso_disp_w,
			qt_min_atraso_receb_w,
			nm_usuario_geracao_w,
			dt_inicio_w,
			coalesce(cd_estab_lote_w,cd_estabelecimento_p));

	else

		update	eis_atend_lote
		set		qt_atraso_entrega 		= qt_atraso_entrega + qt_atraso_entrega_w,
				qt_atraso_disp 			= qt_atraso_disp + qt_atraso_disp_w,
				qt_atraso_receb 		= qt_atraso_receb + qt_atraso_receb_w,
				qt_min_atraso_entrega 	= qt_min_atraso_entrega + qt_min_atraso_entrega_w,
				qt_min_atraso_disp 		= qt_min_atraso_disp + qt_min_atraso_disp_w,
				qt_min_atraso_receb 	= qt_min_atraso_receb + qt_min_atraso_receb_w
		where	cd_setor_atendimento 	= cd_setor_atendimento_w
		and		nr_seq_turno 			= nr_seq_turno_w
		and		nr_seq_classif 			= nr_seq_classif_w
		and		cd_local_estoque 		= cd_local_estoque_w
		and		dt_referencia 			= dt_inicio_w;

	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_atend_lote ( dt_parametro_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

