-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_marcar_dias_trat_ageint ( nr_seq_pendencia_p bigint, dt_agenda_p timestamp, nm_usuario_p text, nr_seq_local_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_min_duracao_p bigint, nr_seq_item_p bigint, nr_seq_prof_p bigint default null, ds_retorno_p INOUT text DEFAULT NULL, ie_consiste_estab_p text DEFAULT NULL, ie_valida_agrupamento_p text default 'N') AS $body$
DECLARE


dt_agenda_w	timestamp;
ie_Gerar_w	varchar(10);
ds_retorno_w	varchar(4000);
ie_primeiro_w	varchar(1)	:= 'S';
ds_sep_w	varchar(3);
ie_consiste_estab_w	varchar(1);
qt_marcacao_w	bigint;
dt_agenda_ww	timestamp;

C01 CURSOR FOR
	SELECT	to_date(to_char(coalesce(a.dt_prevista_agenda, coalesce(a.dt_real, a.dt_prevista)),'dd/mm/yyyy') || ' ' || to_char(dt_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	from	paciente_atendimento a
	where	a.nr_Seq_pend_agenda	= nr_seQ_pendencia_p
	and		coalesce(a.dt_suspensao::text, '') = ''
	and		coalesce(a.dt_prevista_agenda, coalesce(a.dt_real,a.dt_prevista))	>= trunc(dt_agenda_p)
	and		((coalesce(a.cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p and ie_consiste_estab_w = 'S') or ie_consiste_estab_w = 'N')
	and		((not exists (SELECT 1 from agenda_quimio_marcacao x where x.nr_seq_pend_agenda = a.nr_Seq_pend_agenda and trunc(coalesce(a.dt_prevista_agenda, a.dt_prevista)) = trunc(x.dt_agenda)) and qt_marcacao_w = 0)
	or (exists (select 1 from agenda_quimio_marcacao x where x.nr_seq_pend_agenda = a.nr_Seq_pend_agenda and trunc(coalesce(a.dt_prevista_agenda, a.dt_prevista)) = trunc(x.dt_agenda)) and qt_marcacao_w = 1))
	and		coalesce(a.dt_cancelamento::text, '') = ''
	order by 1;


BEGIN

ie_consiste_estab_w	:= coalesce(ie_consiste_estab_p,'S');

begin
select	1
into STRICT	qt_marcacao_w
from	agenda_quimio_marcacao
where	nr_seq_pend_agenda	= nr_seq_pendencia_p
and		dt_agenda_p between dt_Agenda and dt_Agenda + (nr_duracao - 1) / 1440  LIMIT 1;
exception
	when others then
		qt_marcacao_w	:= 0;
end;

open C01;
loop
fetch C01 into
	dt_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		
	if (trunc(dt_agenda_p)	<> trunc(dt_agenda_w)) then
		CALL Qt_Gerar_Horario(nr_seq_pendencia_p, null, trunc(dt_agenda_w), nm_usuario_p, nr_min_duracao_p,
				cd_pessoa_fisica_p ,null, null, nr_seq_local_p,nr_seq_item_p,'');
	end if;
	select	coalesce(max(dt_agenda), dt_Agenda_w)
	into STRICT	dt_agenda_ww
	from	agenda_quimio_marcacao
	where	nr_seq_pend_agenda	= nr_seq_pendencia_p
	and		dt_agenda_w between trunc(dt_Agenda) and trunc(dt_Agenda) + 86399/86400
	and		coalesce(ie_Gerado,'N')	= 'N';
	
	ie_gerar_w := Qt_Atualizar_Dados_Marcacao(nr_seq_pendencia_p, 0, dt_agenda_ww, nm_usuario_p, nr_seq_local_p, cd_estabelecimento_p, nr_seq_item_p, ie_gerar_w, nr_seq_prof_p, ie_consiste_estab_w, null, ie_valida_agrupamento_p);
	if (ie_Gerar_w	<> 'S') then
		if (ie_primeiro_w	= 'S') then
			ds_retorno_w	:= wheb_mensagem_pck.get_texto(795113);
			ie_primeiro_w	:= 'N';
		end if;
		ds_retorno_w	:= substr(ds_retorno_w || ds_sep_w || to_char(dt_agenda_w,'dd/mm/yyyy'),1,4000);
		ds_sep_w	:= ', ';
	end if;
	end;
end loop;
close C01;

ds_retorno_p	:= substr(ds_retorno_w,1,4000);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_marcar_dias_trat_ageint ( nr_seq_pendencia_p bigint, dt_agenda_p timestamp, nm_usuario_p text, nr_seq_local_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_min_duracao_p bigint, nr_seq_item_p bigint, nr_seq_prof_p bigint default null, ds_retorno_p INOUT text DEFAULT NULL, ie_consiste_estab_p text DEFAULT NULL, ie_valida_agrupamento_p text default 'N') FROM PUBLIC;
