-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_anesthetic_scheduling ( nr_seq_agenda_anestesista_p bigint, cd_especialidade_p text, ie_tipo_agendamento_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_ageint INOUT bigint, nr_seq_ageint_item INOUT bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finality: 
------------------------------------------------------------------------------------------------------------------- 
Direct calling 
[ ] Dictionary objects [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Others: 
 ------------------------------------------------------------------------------------------------------------------ 
Attention points: 
------------------------------------------------------------------------------------------------------------------- 
References: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_ageint_w		bigint;
nr_seq_ageint_item_w		bigint;
nr_telefone_w		varchar(60);
qt_altura_cm_w		real;
dt_nascimento_w		timestamp;
nm_paciente_w		varchar(60);
cd_pessoa_fisica_w	varchar(10);
cd_medico_w		varchar(10);
nr_seq_status_w		bigint;
nr_duracao_w		bigint;


BEGIN 
 
select	max(a.cd_pessoa_fisica), 
	max(a.cd_medico), 
	max(a.nr_minuto_duracao) 
into STRICT	cd_pessoa_fisica_w, 
	cd_medico_w, 
	nr_duracao_w 
from	agenda_paciente	a 
where	a.nr_sequencia	= nr_seq_agenda_anestesista_p;
 
nr_telefone_w		:= obter_fone_pac_agenda(cd_pessoa_fisica_w);
dt_nascimento_w		:= to_date(obter_dados_pf(cd_pessoa_fisica_w,'DN'),'dd/mm/yyyy');
qt_altura_cm_w		:= obter_dados_pf(cd_pessoa_fisica_w,'AL');
nm_paciente_w		:= substr(obter_nome_pf(cd_pessoa_fisica_w),1,60);
 
 
select	min(nr_sequencia) 
into STRICT	nr_seq_status_w 
from 	agenda_integrada_status 
where 	ie_situacao = 'A' 
and 	ie_Status_tasy = 'EA';
 
select	nextval('agenda_integrada_seq') 
into STRICT	nr_seq_ageint_w
;
 
nr_seq_ageint := nr_seq_ageint_w;
 
insert into agenda_integrada(	nr_sequencia, 
		cd_pessoa_fisica, 
		nm_paciente, 
		nr_telefone, 
		dt_nascimento, 
		qt_altura_cm, 
		dt_inicio_agendamento, 
		cd_profissional, 
		nr_seq_status, 
		cd_estabelecimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_turno) 
values (	nr_seq_ageint_w, 
		cd_pessoa_fisica_w, 
		nm_paciente_w, 
		nr_telefone_w, 
		dt_nascimento_w, 
		qt_altura_cm_w, 
		clock_timestamp(), 
		cd_medico_w, 
		nr_seq_status_w, 
		cd_estabelecimento_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		'2');
		 
select	nextval('agenda_integrada_item_seq') 
into STRICT	nr_seq_ageint_item_w
;
 
nr_seq_ageint_item := nr_seq_ageint_item_w;
		 
insert into agenda_integrada_item( 
	nr_sequencia, 
	cd_especialidade, 
	ie_tipo_agendamento, 
	nr_minuto_duracao, 
	nr_seq_agenda_int, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	nr_seq_agenda_anestesista) 
values (nextval('agenda_integrada_item_seq'), 
	cd_especialidade_p, 
	ie_tipo_agendamento_p,					 
	nr_duracao_w, 
	nr_seq_ageint_w, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	nr_seq_agenda_anestesista_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_anesthetic_scheduling ( nr_seq_agenda_anestesista_p bigint, cd_especialidade_p text, ie_tipo_agendamento_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_ageint INOUT bigint, nr_seq_ageint_item INOUT bigint) FROM PUBLIC;

