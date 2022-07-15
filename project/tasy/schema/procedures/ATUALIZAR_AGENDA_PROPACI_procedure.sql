-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_agenda_propaci (nr_sequencia_p bigint) AS $body$
DECLARE


nr_atendimento_w	bigint;
cd_procedimento_w	bigint;
dt_procedimento_w	timestamp;
nr_cirurgia_w		bigint;
CD_PESSOA_FISICA_w	varchar(10);
nr_Seq_agenda_w		prescr_medica.nr_seq_agenda%type;
nr_prescricao_w		bigint;
cd_estabelecimento_w	bigint;
nm_usuario_w		varchar(15);
cd_tipo_agenda_w	bigint;


BEGIN

select	nr_atendimento,
	cd_procedimento,
	dt_procedimento,
	nr_cirurgia,
	nr_prescricao,
	coalesce(NM_USUARIO_ORIGINAL,NM_USUARIO)
into STRICT	nr_atendimento_w,
	cd_procedimento_w,
	dt_procedimento_w,
	nr_cirurgia_w,
	nr_prescricao_w,
	nm_usuario_w
from procedimento_paciente
where nr_sequencia = nr_sequencia_p;

/*UPDATE AGENDA_PACIENTE
SET IE_STATUS_AGENDA	= 'E'
WHERE CD_PROCEDIMENTO	= cd_procedimento_w
  AND DT_AGENDA		< dt_procedimento_w
  AND NR_ATENDIMENTO	= nr_atendimento_w
  AND NR_CIRURGIA	= nr_cirurgia_w;

if	(SQL%ROWCOUNT = 0) then*/
SELECT 	CD_PESSOA_FISICA,
	cd_estabelecimento
into STRICT	CD_PESSOA_FISICA_w,
	cd_estabelecimento_w
FROM ATENDIMENTO_PACIENTE
WHERE NR_ATENDIMENTO = nr_atendimento_w;

UPDATE AGENDA_PACIENTE
SET IE_STATUS_AGENDA = 'E'
WHERE CD_PROCEDIMENTO = cd_procedimento_w
  AND ((DT_AGENDA < dt_procedimento_w) or (trunc(DT_AGENDA) = trunc(dt_procedimento_w)))
and ie_status_agenda not in ('C','L','B','F','I') /* Rafael em 12/12/2007 OS77024  */
  AND CD_PESSOA_FISICA = CD_PESSOA_FISICA_w;
/*end if;*/

select 	coalesce(max(nr_Seq_agenda),0)
into STRICT	nr_Seq_agenda_w
from	prescr_medica
where 	nr_prescricao = nr_prescricao_w;

IF (nr_Seq_agenda_w > 0) THEN
	
	select  max(a.cd_tipo_agenda)
	into STRICT	cd_tipo_agenda_w
	from    agenda a,
		agenda_paciente b
	where   a.cd_agenda = b.cd_agenda
	and     b.nr_sequencia = nr_seq_agenda_w;
	
	if (cd_tipo_agenda_w = 1) then
		CALL executar_evento_agenda('EPP', 'CI', nr_Seq_agenda_w, cd_estabelecimento_w, nm_usuario_w);
	else
		CALL executar_evento_agenda('EPP', 'E', nr_Seq_agenda_w, cd_estabelecimento_w, nm_usuario_w);
	end if;

END IF;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_agenda_propaci (nr_sequencia_p bigint) FROM PUBLIC;

