-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_agendas ( ie_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

cd_medico_w  		varchar(10);
cd_pessoa_fisica_w	varchar(30);
nm_medico_w  		varchar(60);
nm_pessoa_fisica_w	varchar(60);
ds_classificacao_w		varchar(40);

ds_retorno_w  		varchar(255);
ds_convenio_w		varchar(255);
nr_minuto_duracao_w	bigint;
hr_inicio_w		timestamp;
nr_atendimento_w		bigint;
cd_setor_atendimento_w	bigint;
ie_reserva_leito_w		varchar(15);
ie_status_agenda_w	varchar(3);
ds_sala_w		varchar(255);

/*
cm - codigo medico
nm - nome medico
ca - codigo agenda
na - nome agenda
cl - classificacao
cv - Convenio
np - nome do paciente
CP - codigo Paciente
MD - Minutos de duracao
DA - Data do agendamento
NR - Numero do atendimento
CS - codigo setor atendimento
RL - Reserva leito
SA - Status da agenda
SL - Sala
*/
BEGIN
if (coalesce(ie_tipo_agenda_p,0) > 0) AND (coalesce(nr_seq_agenda_p,0) > 0) THEN
	if (ie_tipo_agenda_p in (1,2)) then
		select	cd_medico,
			substr(obter_nome_pf(cd_medico),1,60),
			cd_pessoa_fisica,
			coalesce(nr_minuto_duracao,0),
			hr_inicio,
			substr(obter_nome_pf(cd_pessoa_fisica),1,60),
			nr_atendimento,
			cd_setor_atendimento,
			ie_reserva_leito,
			ie_status_agenda,
			substr(obter_nome_agenda(cd_agenda),1,255)
  		into STRICT	cd_medico_w,
			nm_medico_w,
			cd_pessoa_fisica_w,
			nr_minuto_duracao_w,
			hr_inicio_w,
			nm_pessoa_fisica_w,
			nr_atendimento_w,
			cd_setor_atendimento_w,
			ie_reserva_leito_w,
			ie_status_agenda_w,
			ds_sala_w
		from	agenda_paciente
  		where	nr_sequencia = nr_seq_agenda_p;
 	elsif (ie_tipo_agenda_p in (3,5)) then
  		select a.cd_pessoa_fisica,
   			substr(obter_nome_pf(a.cd_pessoa_fisica),1,60),
   			obter_classif_agenda_consulta(b.ie_classif_agenda),
			obter_nome_convenio(b.cd_convenio),
			substr(obter_nome_pf(b.cd_pessoa_fisica),1,60),
			nr_atendimento,
			cd_setor_atendimento,
			substr(obter_nome_agenda(a.cd_agenda),1,255),
			b.ie_status_agenda
  		into STRICT	cd_medico_w,
   			nm_medico_w,
   			ds_classificacao_w,
			ds_convenio_w,
			nm_pessoa_fisica_w,
			nr_atendimento_w,
			cd_setor_atendimento_w,
			ds_sala_w,
			ie_status_agenda_w
  		from	agenda a,
   			agenda_consulta b
  		where	a.cd_agenda = b.cd_agenda
  		and	b.nr_sequencia = nr_seq_agenda_p;
 	end if;

	if (coalesce(ie_opcao_p,'CM') = 'CM') then
  		ds_retorno_w := cd_medico_w;
 	elsif (coalesce(ie_opcao_p,'CM') = 'NM') then
  		ds_retorno_w := nm_medico_w;
 	elsif (coalesce(ie_opcao_p,'CM') = 'CL') then
  		ds_retorno_w := ds_classificacao_w;
	elsif (coalesce(ie_opcao_p,'CM') = 'CV') then
		ds_retorno_w := ds_convenio_w;
	elsif (coalesce(ie_opcao_p,'CM') = 'CP') then
		ds_retorno_w := cd_pessoa_fisica_w;
	elsif (coalesce(ie_opcao_p,'CM') = 'NP') then
		ds_retorno_w := nm_pessoa_fisica_w;
	elsif (coalesce(ie_opcao_p,'CM') = 'MD') then
		ds_retorno_w := nr_minuto_duracao_w;		
	elsif (coalesce(ie_opcao_p,'CM') = 'NR') then
		ds_retorno_w := nr_atendimento_w;	
	elsif (coalesce(ie_opcao_p,'CM') = 'CS') then
		ds_retorno_w := cd_setor_atendimento_w;			
	elsif (coalesce(ie_opcao_p,'CM') = 'DA') then
		ds_retorno_w := to_char(hr_inicio_w,'dd/mm/yyyy hh24:mi:ss');
	elsif (coalesce(ie_opcao_p,'CM') = 'SA') then
		ds_retorno_w := ie_status_agenda_w;
	elsif (coalesce(ie_opcao_p,'CM') = 'RL') then
		ds_retorno_w := ie_reserva_leito_w;
	elsif (coalesce(ie_opcao_p,'CM') = 'SL') then
		ds_retorno_w := ds_sala_w;
 	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_agendas ( ie_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_opcao_p text) FROM PUBLIC;
