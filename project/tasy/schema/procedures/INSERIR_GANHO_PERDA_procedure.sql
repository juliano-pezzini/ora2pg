-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_ganho_perda ( nr_atendimento_p bigint, nr_cirurgia_p bigint, nr_seq_tipo_p bigint, cd_setor_atendimento_p bigint, dt_ocorrencia_p timestamp, qt_volume_p bigint, ie_liberado_p text, nr_hora_p bigint, ds_observacao_p text, nm_usuario_p text, ds_lista_inf_adic_p text, qt_ocorrencia_p bigint, nr_seq_pepo_p bigint, nr_sequencia_p INOUT bigint, qt_peso_p bigint default null, nr_seq_topografia_p bigint default null, ie_lado_p text default null, ie_rn_p text default null, nr_seq_horario_p bigint default null, nr_seq_dispositivo_p bigint default null, nr_seq_atend_disp_p bigint default null, ds_justificativa_retro_p text default null) AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_pessoa_fisica_w	varchar(10);
tam_lista_w		bigint;
ie_pos_virgula_w	bigint;
qt_passou_w		smallint := 0;
nr_seq_inf_w		bigint;
nr_seq_result_w		bigint;


BEGIN

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	usuario
where	nm_usuario	= nm_usuario_p;

select	nextval('atendimento_perda_ganho_seq')
into STRICT	nr_sequencia_w
;

insert into ATENDIMENTO_PERDA_GANHO(
	NR_SEQUENCIA,
	NR_ATENDIMENTO,
	DT_ATUALIZACAO,
	NM_USUARIO,
	NR_SEQ_TIPO,
	QT_VOLUME,
	DS_OBSERVACAO,
	DT_MEDIDA,
	CD_TURNO,
	CD_SETOR_ATENDIMENTO,
	CD_PROFISSIONAL,
	nr_cirurgia,
	ie_situacao,
	dt_liberacao,
	nr_hora,
	qt_ocorrencia,
	qt_peso,
	nr_seq_pepo,
	nr_seq_topografia,
	ie_lado,
	ie_recem_nato,
	nr_seq_horario,
	nr_seq_dispositivo,
	nr_seq_atend_disp,
    ds_justificativa_retro,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC )
values (	nr_sequencia_w,
	nr_atendimento_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_tipo_p,
	coalesce(qt_volume_p,0),
	ds_observacao_p,
	dt_ocorrencia_p,
	null,
	cd_setor_atendimento_p,
	cd_pessoa_fisica_w,
	nr_cirurgia_p,
	'A',
	CASE WHEN ie_liberado_p='S' THEN clock_timestamp()  ELSE null END ,
	nr_hora_p,
	coalesce(qt_ocorrencia_p,0),
	qt_peso_p,
	nr_seq_pepo_p,
	nr_seq_topografia_p,
	ie_lado_p,
	ie_rn_p,
	nr_seq_horario_p,
	nr_seq_dispositivo_p,
	nr_seq_atend_disp_p,
    ds_justificativa_retro_p,
	clock_timestamp(),
	nm_usuario_p);
	
	CALL Inserir_info_adic_perda(ds_lista_inf_adic_p, nr_sequencia_w, nm_usuario_p);
	
if (coalesce(qt_volume_p,0)	> 0) then
	CALL gerar_lancamento_automatico(nr_atendimento_p,null,381,nm_usuario_p,null,nr_seq_tipo_p,nr_sequencia_w,null,null,null);
end if;
	
commit;
nr_sequencia_p	:= nr_sequencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_ganho_perda ( nr_atendimento_p bigint, nr_cirurgia_p bigint, nr_seq_tipo_p bigint, cd_setor_atendimento_p bigint, dt_ocorrencia_p timestamp, qt_volume_p bigint, ie_liberado_p text, nr_hora_p bigint, ds_observacao_p text, nm_usuario_p text, ds_lista_inf_adic_p text, qt_ocorrencia_p bigint, nr_seq_pepo_p bigint, nr_sequencia_p INOUT bigint, qt_peso_p bigint default null, nr_seq_topografia_p bigint default null, ie_lado_p text default null, ie_rn_p text default null, nr_seq_horario_p bigint default null, nr_seq_dispositivo_p bigint default null, nr_seq_atend_disp_p bigint default null, ds_justificativa_retro_p text default null) FROM PUBLIC;

