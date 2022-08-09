-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_marcar_dias_trat_transf ( nr_seq_pendencia_p bigint, nr_seq_atendimento_p bigint, dt_agenda_p timestamp, nr_seq_local_p bigint, cd_pessoa_fisica_p text, nr_min_duracao_p bigint, nr_seq_item_p bigint, nr_seq_prof_p bigint default null, ie_consiste_estab_p text DEFAULT NULL, qt_tempo_medic_p bigint DEFAULT NULL, nr_horas_marcacao_p bigint DEFAULT NULL, ds_retorno_p INOUT text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


dt_agenda_w		timestamp;
ie_Gerar_w		varchar(3);
ds_retorno_w		varchar(4000);
ie_primeiro_w		varchar(1)	:= 'S';
ds_sep_w		varchar(3);
ie_consiste_estab_w	varchar(1);
nr_seq_local_w		bigint;
dt_horario_w		timestamp;
ie_novo_automatico_w	varchar(1);
ds_msg_inf_w		varchar(255);
qt_tempo_medic_w	bigint;

qt_teste_w		bigint;
nr_seq_grupo_quimio_w	bigint;
dt_real_w		timestamp;
dt_marcacao_w		timestamp;
nr_seq_local_marc_w	bigint;
cd_setor_atendimento_w	paciente_setor.cd_setor_atendimento%type;

C01 CURSOR FOR
	SELECT	a.dt_real,
			qt_obter_dur_aplicacao(a.ds_dia_ciclo,b.nr_seq_medicacao,b.cd_protocolo,a.nr_seq_atendimento,coalesce(a.dt_real, a.dt_prevista),nr_seq_pendencia_p,nm_usuario_p,cd_estabelecimento_p),
			b.cd_setor_atendimento
	from	paciente_atendimento a,
		paciente_setor b
	where	a.nr_Seq_pend_agenda	= nr_seq_pendencia_p
	and	a.nr_seq_paciente	= b.nr_seq_paciente
	and	a.dt_real		>= trunc(clock_timestamp())
	and	a.dt_real		>= trunc(dt_real_w)
	and	((coalesce(a.cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p and ie_consiste_estab_w = 'S') or ie_consiste_estab_w = 'N')
	and	exists (SELECT 1 from agenda_quimio c where c.nr_seq_atendimento = a.nr_seq_atendimento and ie_status_agenda not in ('S','C','F'))
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	coalesce(a.dt_suspensao::text, '') = ''
	order by 1;

C02 CURSOR FOR
	SELECT	x.dt_horario,
		x.nr_seq_local
	from	w_agenda_quimio x,
		qt_local z
	where	z.nr_sequencia = x.nr_seq_local
	and	z.cd_estabelecimento = cd_estabelecimento_p
	and	x.nm_usuario = nm_usuario_p
	and	coalesce(z.nr_seq_grupo_quimio,0)	= coalesce(nr_seq_grupo_quimio_w,0)
	and	x.ie_status = 'L'
	and	not exists (	SELECT	1
				from	w_agenda_quimio y
				where	y.nr_seq_local = x.nr_seq_local
				and	y.ie_status <> 'L'
				and	y.dt_horario between x.dt_horario and x.dt_horario + qt_tempo_medic_w/1440)
	and	x.dt_horario > clock_timestamp()
	and	(to_char(x.dt_horario,'hh24:mi') > (select coalesce(max(to_char(hr_min_inicio,'hh24:mi')),'00:00') from parametro_agenda_quimio)
	and	((x.dt_horario > (clock_timestamp() + coalesce(nr_horas_marcacao_p,0)/24)) or (coalesce(nr_horas_marcacao_p,0) = 0)))
	and	Qt_Consitir_Classif_Dur(x.dt_horario, qt_tempo_medic_w, z.nr_sequencia, cd_setor_atendimento_w) = 'S'
	and	x.dt_horario between dt_agenda_w and trunc(dt_agenda_w) + 86399/86400
	--and	nvl(nr_seq_local_w,0)	= 0
	order by 1;


BEGIN
ie_novo_automatico_w	:= coalesce(Obter_Valor_Param_Usuario(865, 195, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N');
ie_consiste_estab_w	:= coalesce(ie_consiste_estab_p,'S');

select	max(nr_seq_grupo_quimio)
into STRICT	nr_seq_grupo_quimio_w
from	qt_local
where	nr_sequencia	= nr_seq_local_p;

select	max(dt_real)
into STRICT	dt_real_w
from	paciente_atendimento
where	nr_seq_atendimento	= nr_seq_atendimento_p;

delete from	w_consistencia_qt_marc
where	nr_seq_pend_agenda	= nr_seq_pendencia_p
or	nm_usuario		= nm_usuario_p;

open C01;
loop
fetch C01 into
	dt_agenda_w,
	qt_tempo_medic_w,
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	CALL Qt_Gerar_Horario(nr_seq_pendencia_p, null, trunc(dt_agenda_w), nm_usuario_p, nr_min_duracao_p,
				cd_pessoa_fisica_p ,null, null, nr_seq_local_p,nr_seq_item_p,'');

	ie_gerar_w := Qt_Atualiza_Dados_Transf(nr_seq_pendencia_p, nr_seq_atendimento_p, dt_agenda_w, nm_usuario_p, nr_seq_local_p, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p);
	nr_seq_local_w	:= 0;
	dt_horario_w	:= null;
	if (ie_Gerar_w	<> 'S') then
		CALL Qt_Gerar_Horario(nr_seq_pendencia_p, null, trunc(dt_agenda_w), nm_usuario_p, nr_min_duracao_p,
						cd_pessoa_fisica_p ,null, null, null,nr_seq_item_p,'');

		open C02;
		loop
		fetch C02 into
			dt_horario_w,
			nr_seq_local_w;
			begin
		EXIT WHEN NOT FOUND; /* apply on C02 */
			dt_marcacao_w		:= dt_horario_w;
			nr_seq_local_marc_w	:= nr_seq_local_w;
			exit;
			end;
		end loop;
		close C02;

		ie_gerar_w := Qt_Atualiza_Dados_Transf(nr_seq_pendencia_p, nr_seq_atendimento_p, dt_marcacao_w, nm_usuario_p, nr_seq_local_marc_w, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p);
	end if;

	if (ie_Gerar_w	<> 'S') then

		ds_msg_inf_w := null;

		if ('T' = ie_Gerar_w) then
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(238909) || chr(10);

		elsif ('Q' = ie_Gerar_w) then
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(286516) || chr(10);

		elsif ('G' = ie_Gerar_w) then
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(286518) || chr(10);

		elsif ('P' = ie_Gerar_w) then
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(795109) || chr(10);

		elsif ('E' = ie_Gerar_w) then
			ds_msg_inf_w 	:= wheb_mensagem_pck.get_texto(286334) || chr(10);

		elsif ('L' = ie_Gerar_w) then
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(286335) || chr(10);

		elsif ('H' = ie_Gerar_w) then
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(286336) || chr(10);

		elsif ('A' = ie_Gerar_w) then
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(795110) || chr(10);

		elsif ('M' = ie_Gerar_w) then
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(286333) || chr(10);

		elsif ('D' = ie_Gerar_w) then
			ds_msg_inf_w	:= wheb_mensagem_pck.get_texto(231858) || chr(10);

		elsif ('FT' = ie_gerar_w) then
			ds_msg_inf_w    := wheb_mensagem_pck.get_texto(286520) || chr(10);

		end if;

		insert into w_consistencia_qt_marc(
			dt_atualizacao,
			nm_usuario,
			dt_tratamento,
			ds_consistencia,
			nr_seq_pend_agenda )
		values (	clock_timestamp(),
			nm_usuario_p,
			dt_agenda_w,
			coalesce(ds_msg_inf_w,wheb_mensagem_pck.get_texto(795112) || '.'),
			nr_seq_pendencia_p);

		if ('S' = ie_primeiro_w) then
			ie_primeiro_w := 'N';
			ds_retorno_w	:= wheb_mensagem_pck.get_texto(795113);
		end if;

		ds_retorno_w	:= substr(ds_retorno_w || ds_sep_w || to_char(dt_agenda_w,'dd/mm/yyyy'),1,4000);
		ds_sep_w	:= ', ';
	end if;
	end;
end loop;
close C01;

ds_retorno_p	:= substr(ds_retorno_w,1,255);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_marcar_dias_trat_transf ( nr_seq_pendencia_p bigint, nr_seq_atendimento_p bigint, dt_agenda_p timestamp, nr_seq_local_p bigint, cd_pessoa_fisica_p text, nr_min_duracao_p bigint, nr_seq_item_p bigint, nr_seq_prof_p bigint default null, ie_consiste_estab_p text DEFAULT NULL, qt_tempo_medic_p bigint DEFAULT NULL, nr_horas_marcacao_p bigint DEFAULT NULL, ds_retorno_p INOUT text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
