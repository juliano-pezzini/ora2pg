-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_insert_prot_dieta_jejum ( nr_atendimento_p cpoe_dieta.nr_atendimento%type, cd_protocolo_p protocolo_medic_jejum.cd_protocolo%type, nr_sequencia_p protocolo_medic_jejum.nr_sequencia%type, nr_seq_jejum_prot_p protocolo_medic_jejum.nr_seq_jejum %type, nm_usuario_p cpoe_dieta.nm_usuario%type, cd_estabelecimento_p bigint, cd_perfil_p bigint, nr_seq_jejum_p INOUT cpoe_dieta.nr_sequencia%type) AS $body$
DECLARE


nr_seq_tipo_w			protocolo_medic_jejum.nr_seq_tipo%type;
nr_seq_objetivo_w		protocolo_medic_jejum.nr_seq_objetivo%type;
ie_inicio_w				protocolo_medic_jejum.ie_inicio%type;
dt_inicio_w				protocolo_medic_jejum.dt_inicio%type;
dt_fim_w				protocolo_medic_jejum.dt_fim%type;
dt_evento_w				protocolo_medic_jejum.dt_evento%type;
qt_min_ant_w			protocolo_medic_jejum.qt_min_ant%type;
qt_min_depois_w			protocolo_medic_jejum.qt_min_depois%type;
qt_hora_ant_w			protocolo_medic_jejum.qt_hora_ant%type;
qt_hora_depois_w		protocolo_medic_jejum.qt_hora_depois%type;
ds_evento_w				protocolo_medic_jejum.ds_evento%type;
ds_observacao_w			protocolo_medic_jejum.ds_observacao%type;

nr_sequencia_w			cpoe_dieta.nr_sequencia%type;
ie_duracao_w			cpoe_dieta.ie_duracao%type;

c01 CURSOR FOR
SELECT	nr_seq_tipo,
		nr_seq_objetivo,
		ie_inicio,
		dt_inicio,
		dt_evento,
		qt_min_ant,
		qt_min_depois,
		qt_hora_ant,
		qt_hora_depois,
		ds_evento,
		ds_observacao
from	protocolo_medic_jejum
where	nr_sequencia		= nr_sequencia_p
and		cd_protocolo	 	= cd_protocolo_p
and		nr_seq_jejum		= nr_seq_jejum_prot_p;


BEGIN
open c01;
loop
fetch c01 into	nr_seq_tipo_w,
				nr_seq_objetivo_w,
				ie_inicio_w,
				dt_inicio_w,
				dt_evento_w,
				qt_min_ant_w,
				qt_min_depois_w,
				qt_hora_ant_w,
				qt_hora_depois_w,
				ds_evento_w,
				ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ie_duracao_w := 'C';
	if (ie_inicio_w  ('P','C')) then
		ie_duracao_w := 'R';
	end if;

	if (dt_inicio_w <= clock_timestamp()) or (coalesce(dt_inicio_w::text, '') = '') then
		dt_inicio_w := trunc(clock_timestamp(),'hh');
		if (dt_inicio_w <= clock_timestamp()) then
			dt_inicio_w := dt_inicio_w + 1/24;
		end if;
	end if;

	select	nextval('cpoe_dieta_seq')
	into STRICT	nr_sequencia_w
	;

	insert into cpoe_dieta(
			nr_sequencia,
			nr_atendimento,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			ie_tipo_dieta,
			ie_inicio,
			dt_inicio_jejum,
			dt_fim,
			dt_inicio,
			nr_seq_objetivo,
			nr_seq_tipo,
			qt_min_ant,
			qt_min_depois,
			qt_hora_ant,
			qt_hora_depois,
			ds_evento,
			ds_observacao,
			ie_duracao)
		values (
			nr_sequencia_w,
			nr_atendimento_p,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'J',
			ie_inicio_w,
			dt_inicio_w,
			null,
			dt_inicio_w,
			nr_seq_objetivo_w,
			nr_seq_tipo_w,
			qt_min_ant_w,
			qt_min_depois_w,
			qt_hora_ant_w,
			qt_hora_depois_w,
			ds_evento_w,
			ds_observacao_w,
			ie_duracao_w);

	nr_seq_jejum_p := nr_sequencia_w;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_insert_prot_dieta_jejum ( nr_atendimento_p cpoe_dieta.nr_atendimento%type, cd_protocolo_p protocolo_medic_jejum.cd_protocolo%type, nr_sequencia_p protocolo_medic_jejum.nr_sequencia%type, nr_seq_jejum_prot_p protocolo_medic_jejum.nr_seq_jejum %type, nm_usuario_p cpoe_dieta.nm_usuario%type, cd_estabelecimento_p bigint, cd_perfil_p bigint, nr_seq_jejum_p INOUT cpoe_dieta.nr_sequencia%type) FROM PUBLIC;

