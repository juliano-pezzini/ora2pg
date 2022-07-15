-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_encaminhar_atendimento ( nr_seq_atend_event_p mprev_atendimento_evento.nr_sequencia%type, cd_profissional_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_tipo_evento_p mprev_tipo_evento_atend.nr_sequencia%type, nr_seq_status_evento_p mprev_status_atendimento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_atend_pac_w	mprev_atendimento_evento.nr_sequencia%type;
cd_procedimento_w	mprev_atendimento_evento.cd_procedimento%type;
ie_origem_proced_w	mprev_atendimento_evento.ie_origem_proced%type;
ds_observacao_w		mprev_atendimento_evento.ds_observacao%type;
ie_prof_adic_w		mprev_atendimento_evento.ie_prof_adic%type;
nr_seq_atendimento_w	mprev_atendimento_evento.nr_seq_atendimento%type;

BEGIN

if (nr_seq_atend_event_p IS NOT NULL AND nr_seq_atend_event_p::text <> '') then
select	NR_SEQ_ATEND_PACIENTE,
	cd_procedimento,
	ie_origem_proced,
	ds_observacao,
	ie_prof_adic,
	nr_seq_atendimento
into STRICT	nr_seq_atend_pac_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	ds_observacao_w,
	ie_prof_adic_w,
	nr_seq_atendimento_w
from	mprev_atendimento_evento
where	nr_sequencia = nr_seq_atend_event_p;

update	mprev_atendimento_evento
set	dt_fim_evento = clock_timestamp(),
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_sequencia = nr_seq_atend_event_p;


insert into mprev_atendimento_evento(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_atend_paciente,
	nr_seq_tipo_evento,
	nr_seq_status,
	dt_inicio_evento,
	cd_procedimento,
	cd_profissional,
	ie_origem_proced,
	ds_observacao,
	ie_prof_adic,
	nr_seq_atendimento
) values (
	nextval('mprev_atendimento_evento_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_atend_pac_w,
	nr_seq_tipo_evento_p,
	nr_seq_status_evento_p,
	clock_timestamp(),
	cd_procedimento_w,
	cd_profissional_p,
	ie_origem_proced_w,
	ds_observacao_w,
	ie_prof_adic_w,
	nr_seq_atendimento_w
);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_encaminhar_atendimento ( nr_seq_atend_event_p mprev_atendimento_evento.nr_sequencia%type, cd_profissional_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_tipo_evento_p mprev_tipo_evento_atend.nr_sequencia%type, nr_seq_status_evento_p mprev_status_atendimento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

