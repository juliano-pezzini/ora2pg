-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resumo_agendamento ( dt_inicio_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_sequencia_w		bigint;
dt_inicio_agendamento_w	timestamp;
dt_fim_agendamento_w	timestamp;
cd_profissional_w	varchar(10);
qt_consulta_w		bigint;
qt_exame_w		bigint;
qt_agendamento_w	bigint;
qt_confirmado_w		bigint;
qt_cancelamento_w	bigint;
ie_status_tasy_w	varchar(15);
qt_min_duracao_w	double precision;
qt_transf_cons_w	bigint;
qt_transf_exame_w	bigint;
qt_transferido_w	bigint;
qt_consulta_marc_w	bigint;
qt_exame_marc_w		bigint;
ie_consid_agend_cons_w	varchar(1);

C01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.dt_inicio_agendamento,
	a.dt_fim_agendamento,
	a.cd_profissional,
	b.ie_status_tasy
from	agenda_integrada_status b,
	agenda_integrada a
where	a.dt_inicio_agendamento	>= dt_inicio_p
and	a.dt_fim_agendamento	<= fim_dia(dt_final_p)
and	a.nr_seq_status		= b.nr_sequencia
and	coalesce(a.cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p;


BEGIN

ie_consid_agend_cons_w := Obter_Param_Usuario(869, 189, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_consid_agend_cons_w);

delete	FROM w_resumo_agendamento
where	nm_usuario	= nm_usuario_p;

commit;

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	dt_inicio_agendamento_w,
	dt_fim_agendamento_w,
	cd_profissional_w,
	ie_status_tasy_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_transferido_w	:= 0;
	qt_agendamento_w	:= 1;
	qt_confirmado_w		:= 0;
	qt_cancelamento_w	:= 0;
	qt_min_duracao_w	:= Obter_Min_Entre_Datas(dt_inicio_agendamento_w,dt_fim_agendamento_w,1);
	qt_consulta_marc_w	:= 0;
	qt_exame_marc_w		:= 0;
	qt_consulta_w		:= 0;
	qt_exame_w		:= 0;
	if (ie_status_tasy_w = 'AG') then
		begin
		qt_confirmado_w	:= 1;

		if (ie_consid_agend_cons_w = 'S') then
			begin

			select	sum(CASE WHEN Obter_classif_tasy_Agecons(ie_classif_agenda)='N' THEN 1  ELSE 0 END ),
				sum(CASE WHEN ie_tipo_agendamento='E' THEN 1  ELSE CASE WHEN Obter_classif_tasy_Agecons(ie_classif_agenda)='X' THEN 1  ELSE 0 END  END )
			into STRICT	qt_consulta_w,
				qt_exame_w
			from	agenda_integrada_item
			where	nr_seq_agenda_int	= nr_sequencia_w;

			if (qt_consulta_w > 0) or (qt_exame_w > 0) then
				qt_confirmado_w	:= 1;
			end if;

			end;
		elsif (ie_consid_agend_cons_w = 'N') then

			select	sum(CASE WHEN ie_tipo_agendamento='C' THEN 1  ELSE 0 END ),
				sum(CASE WHEN ie_tipo_agendamento='E' THEN 1  ELSE 0 END )
			into STRICT	qt_consulta_w,
				qt_exame_w
			from	agenda_integrada_item
			where	nr_seq_agenda_int	= nr_sequencia_w;

		end if;

		select	coalesce(sum(CASE WHEN coalesce(ie_Transferido,'N')='S' THEN 1  ELSE 0 END ),0)
		into STRICT	qt_transf_cons_w
		from	agenda_integrada_item a,
				agenda_consulta b
		where	a.nr_seq_agenda_int	= nr_sequencia_w
		and	a.nr_seq_agenda_cons	= b.nr_sequencia;

		select	coalesce(sum(CASE WHEN coalesce(ie_Transferido,'N')='S' THEN 1  ELSE 0 END ),0)
		into STRICT	qt_transf_exame_w
		from	agenda_integrada_item a,
				agenda_paciente b
		where	a.nr_seq_agenda_int	= nr_sequencia_w
		and	a.nr_seq_agenda_exame	= b.nr_sequencia;

		qt_transferido_w	:= qt_transf_cons_w + qt_transf_exame_w;

		select	coalesce(sum(CASE WHEN coalesce(ie_status_agenda,'N')='N' THEN 1 WHEN coalesce(ie_status_agenda,'N')='R' THEN 1  ELSE 0 END ),0)
		into STRICT	qt_consulta_marc_w
		from	agenda_integrada_item a,
			agenda_consulta b
		where	a.nr_seq_agenda_int	= nr_sequencia_w
		and	a.nr_seq_agenda_cons	= b.nr_sequencia;

		select	coalesce(sum(CASE WHEN coalesce(ie_status_agenda,'N')='N' THEN 1 WHEN coalesce(ie_status_agenda,'N')='R' THEN 1  ELSE 0 END ),0)
		into STRICT	qt_exame_marc_w
		from	agenda_integrada_item a,
			agenda_paciente b
		where	a.nr_seq_agenda_int	= nr_sequencia_w
		and	a.nr_seq_agenda_exame	= b.nr_sequencia;

		end;
	elsif (ie_status_tasy_w = 'CA') then
		begin
		qt_cancelamento_w	:= 1;
		end;
	end if;

	insert into w_resumo_agendamento(
		dt_atualizacao,
		nm_usuario,
		cd_profissional,
		qt_agendamento,
		qt_confirmado,
		qt_cancelamento,
		qt_min_duracao,
		qt_exame,
		qt_consulta,
		dt_agendamento,
		qt_transferido,
		qt_exame_marc,
		qt_consulta_marc)
	values (	clock_timestamp(),
		nm_usuario_p,
		cd_profissional_w,
		qt_agendamento_w,
		qt_confirmado_w,
		qt_cancelamento_w,
		qt_min_duracao_w,
		qt_exame_w,
		qt_consulta_w,
		trunc(dt_inicio_agendamento_w),
		qt_transferido_w,
		qt_exame_marc_w,
		qt_consulta_marc_w);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_agendamento ( dt_inicio_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

