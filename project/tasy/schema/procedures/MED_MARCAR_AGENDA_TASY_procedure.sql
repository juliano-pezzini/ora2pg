-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_marcar_agenda_tasy (nr_seq_agenda_cons_p bigint, cd_agenda_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_pessoa_fisica_w		varchar(10);
dt_agenda_w			timestamp;
nr_minuto_duracao_w		bigint;
cd_medico_w			varchar(10);
cd_convenio_w			integer;
nr_sequencia_w			bigint;


BEGIN 
 
select	a.cd_pessoa_fisica, 
	a.dt_agenda, 
	a.nr_minuto_duracao, 
	a.cd_convenio, 
	b.cd_pessoa_fisica 
into STRICT	cd_pessoa_fisica_w, 
	dt_agenda_w, 
	nr_minuto_duracao_w, 
	cd_convenio_w, 
	cd_medico_w 
from	agenda b, 
	agenda_consulta a 
where	a.nr_sequencia	= nr_seq_agenda_cons_p 
and	a.cd_agenda	= b.cd_agenda;
 
 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_sequencia_w 
from	agenda_paciente 
where	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '') 
and	dt_agenda		= trunc(dt_agenda_w) 
and	hr_inicio		= dt_agenda_w 
and	cd_agenda		= cd_agenda_p;
 
if (nr_sequencia_w > 0) then 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262569);
end if;
 
select	nextval('agenda_paciente_seq') 
into STRICT	nr_sequencia_w
;
 
 
insert into agenda_paciente(CD_AGENDA       , 
	CD_PESSOA_FISICA    , 
	DT_AGENDA       , 
	HR_INICIO       , 
	NR_MINUTO_DURACAO   , 
	NM_USUARIO       , 
	DT_ATUALIZACAO     , 
	CD_MEDICO       , 
	NM_PESSOA_CONTATO   , 
	CD_PROCEDIMENTO    , 
	DS_OBSERVACAO     , 
	CD_CONVENIO      , 
	NR_CIRURGIA      , 
	DS_CIRURGIA      , 
	QT_IDADE_PACIENTE   , 
	CD_TIPO_ANESTESIA   , 
	IE_ORIGEM_PROCED    , 
	IE_STATUS_AGENDA    , 
	NM_INSTRUMENTADOR   , 
	NM_CIRCULANTE     , 
	IE_ORTESE_PROTESE   , 
	IE_CDI         , 
	IE_UTI         , 
	IE_BANCO_SANGUE    , 
	IE_SERV_ESPECIAL    , 
	CD_MOTIVO_CANCELAMENTO, 
	NR_SEQUENCIA      , 
	DS_SENHA        , 
	CD_TURNO        , 
	CD_ANESTESISTA     , 
	CD_PEDIATRA      , 
	NM_PACIENTE      , 
	IE_ANESTESIA      , 
	NR_ATENDIMENTO     , 
	IE_CARATER_CIRURGIA  , 
	CD_USUARIO_CONVENIO  , 
	NM_USUARIO_ORIG    , 
	QT_IDADE_MES      , 
	CD_PLANO        , 
	IE_LEITO        , 
	NR_TELEFONE      , 
	DT_AGENDAMENTO     , 
	IE_EQUIPAMENTO     , 
	IE_AUTORIZACAO     , 
	VL_PREVISTO      , 
	NR_SEQ_AGE_CONS    ) 
values (cd_agenda_p, 
	cd_pessoa_fisica_w, 
	trunc(dt_agenda_w), 
	dt_agenda_w,	 
	nr_minuto_duracao_w, 
	nm_usuario_p, 
	clock_timestamp(), 
	cd_medico_w, 
	null, 
	cd_procedimento_p, 
	null, 
	cd_convenio_w, 
	null, null, 
	null, null, 
	ie_origem_proced_p, 
	'N', null, null, 
	'N', 'N', 'N', 'N', 'N', 
	null, nr_sequencia_w, 
	null, null, null, null, 
	substr(obter_nome_pf(cd_pessoa_fisica_w),1,60), --Ivan em 10/03/2008 OS85558 
	null, null, null, 
	null, null, null, null, 
	'N', null, clock_timestamp(), 'N', 
	'N', null, nr_seq_agenda_cons_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_marcar_agenda_tasy (nr_seq_agenda_cons_p bigint, cd_agenda_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) FROM PUBLIC;

