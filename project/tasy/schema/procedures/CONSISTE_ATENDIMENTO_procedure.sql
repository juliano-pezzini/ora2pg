-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_atendimento (NR_ATENDIMENTO_P bigint, QT_PROCESSO_PENDENTE_P INOUT bigint, DS_ERRO_P INOUT text) AS $body$
DECLARE


QT_ATEN_SEM_ALTA_W       	bigint  	:= 0;
QT_PROCESSO_PENDENTE_W   	bigint  	:= 0;
QT_PROC_PENDENTE_W       	bigint  	:= 0;
QT_MAT_PENDENTE_W        	bigint  	:= 0;
QT_CONTA_PENDENTE_W      	bigint  	:= 0;
qt_prescr_proc_pendente_w	bigint  	:= 0;
qt_prescr_mat_pendente_w	bigint	:= 0;
DS_ERRO_W         	 varchar(255) 	:= '';
nr_prescricao_w			bigint;
ds_prescricao_w			varchar(4000) := '';
qt_registro_w		bigint	:= 0;

C01 CURSOR FOR
	SELECT	b.nr_prescricao
	from	prescr_procedimento b,
		prescr_medica	a
	where	a.nr_atendimento		= nr_atendimento_p
	and	b.nr_prescricao			= a.nr_prescricao
	and	b.cd_motivo_baixa		= 0
	and 	coalesce(b.DT_SUSPENSAO::text, '') = ''
	and 	coalesce(a.DT_SUSPENSAO::text, '') = ''
	and 	not exists (SELECT	1
		from	procedimento_paciente x
		where	x.nr_prescricao = b.nr_prescricao
		and	x.nr_sequencia_prescricao = b.nr_sequencia
		and	coalesce(x.cd_motivo_exc_conta::text, '') = '')
	group by	b.nr_prescricao;


C02 CURSOR FOR
	SELECT	b.nr_prescricao
	from	prescr_material	b,
		prescr_medica	a
	where	a.nr_atendimento		= nr_atendimento_p
	and	b.nr_prescricao			= a.nr_prescricao
	and	b.cd_motivo_baixa		= 0
	group by	b.nr_prescricao;


BEGIN

Select	count(*)
into STRICT	qt_aten_sem_alta_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p
and	coalesce(dt_alta::text, '') = '';

if	qt_aten_sem_alta_w > 0 then
	ds_erro_w			:= ds_erro_w || '1 ';
end if;

Select	count(*)
into STRICT	qt_processo_pendente_w
from	processo_atendimento
where	nr_atendimento  = nr_atendimento_p
and	coalesce(dt_fim_real::text, '') = '';

if	qt_processo_pendente_w > 0 then
	ds_erro_w			:= ds_erro_w || '2 ';
end if;

Select	count(*)
into STRICT	qt_mat_pendente_w
from	material_atend_paciente
where	nr_atendimento = nr_atendimento_p
and	qt_material <> 0
and	coalesce(cd_motivo_exc_conta::text, '') = ''
and	coalesce(nr_interno_conta::text, '') = '';

if	qt_mat_pendente_w > 0 then
	ds_erro_w			:= ds_erro_w || '3 ';
end if;

Select	count(*)
into STRICT	qt_proc_pendente_w
from	procedimento_paciente
where	nr_atendimento = nr_atendimento_p
and	qt_procedimento <> 0
and	coalesce(cd_motivo_exc_conta::text, '') = ''
and	coalesce(nr_interno_conta::text, '') = '';

if	qt_proc_pendente_w > 0 then
	ds_erro_w			:= ds_erro_w || '4 ';
end if;

Select	count(*)
into STRICT	qt_conta_pendente_w
from	conta_paciente
where	nr_atendimento		= nr_atendimento_p
and	ie_status_acerto	= 1;

if	qt_conta_pendente_w > 0 then
	ds_erro_w			:= ds_erro_w || '5 ';
end if;
qt_registro_w := 0;
open C01;
loop
fetch C01 into
	nr_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (qt_registro_w	>= 4) then
		exit;
	end if;
	ds_prescricao_w := ds_prescricao_w||','||nr_prescricao_w;
	qt_registro_w	:= qt_registro_w + 1;
	end;
end loop;
close C01;

if (ds_prescricao_w IS NOT NULL AND ds_prescricao_w::text <> '') then
	ds_erro_w	:= ds_erro_w	||'2162 ';
end if;

nr_prescricao_w := 0;
ds_prescricao_w := '';
qt_registro_w	:= 0;
open C02;
loop
fetch C02 into
	nr_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (qt_registro_w	>= 4) then
		exit;
	end if;
	ds_prescricao_w := ds_prescricao_w || ',' || to_char(nr_prescricao_w);
	qt_registro_w	:= qt_registro_w + 1;
	end;
end loop;
close C02;

if (ds_prescricao_w IS NOT NULL AND ds_prescricao_w::text <> '') then
	ds_erro_w	:= ds_erro_w	||'2179 ';
end if;

qt_processo_pendente_p		:= qt_processo_pendente_w;
ds_erro_p			:= ds_erro_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_atendimento (NR_ATENDIMENTO_P bigint, QT_PROCESSO_PENDENTE_P INOUT bigint, DS_ERRO_P INOUT text) FROM PUBLIC;

