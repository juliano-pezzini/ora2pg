-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executar_evento_agenda_atend ( nr_atendimento_p bigint, ie_evento_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_evolucao_clinica_p text default null, NR_SEQ_TIPO_ATEND_p text default null, nr_seq_agenda_p text default null, cd_tipo_agenda_p text default null) AS $body$
DECLARE


nr_seq_agenda_w			bigint;
cd_agenda_w				bigint;
cd_tipo_agenda_w		bigint;
ie_agenda_w				varchar(5);
ie_clinica_w			bigint;


BEGIN

if (nr_seq_agenda_p > 0 AND cd_tipo_agenda_p > 0) then

	if (cd_tipo_agenda_p in (3, 5)) then
		
		select 	max(cd_agenda)
		into STRICT	cd_agenda_w
		from	agenda_consulta
		where 	nr_sequencia = nr_seq_agenda_p;
	
	elsif (cd_tipo_agenda_p in (1, 2) and coalesce(cd_agenda_w::text, '') = '') then
		
		select  max(cd_agenda)
		into STRICT	cd_agenda_w
		from    agenda_paciente
		where   nr_sequencia = nr_seq_agenda_p;
	
	end if;
	
end if;

nr_seq_agenda_w  	:= coalesce(nr_seq_agenda_p, obter_agenda_atendimento(nr_atendimento_p, 'S'));
cd_agenda_w		 	:= coalesce(cd_agenda_w, obter_agenda_atendimento(nr_atendimento_p, 'C'));
cd_tipo_agenda_w 	:= coalesce(cd_tipo_agenda_p, obter_tipo_agenda(cd_agenda_w));
ie_clinica_w		:= Obter_Clinica_Atend(nr_atendimento_p,'C');


if (cd_tipo_agenda_w = 1) then
	ie_agenda_w := 'CI';
elsif (cd_tipo_agenda_w = 2) then
	ie_agenda_w := 'E';
elsif (cd_tipo_agenda_w = 3) then
	ie_agenda_w := 'C';
elsif (cd_tipo_agenda_w = 5) then
	ie_agenda_w := 'S';
end if;	

if (obter_se_existe_evento_agenda(cd_estabelecimento_p, ie_evento_p, ie_agenda_w ,ie_evolucao_clinica_p,ie_clinica_w) = 'S' ) then
	CALL executar_evento_agenda(ie_evento_p, ie_agenda_w, nr_seq_agenda_w, cd_estabelecimento_p, nm_usuario_p,ie_evolucao_clinica_p ,NR_SEQ_TIPO_ATEND_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executar_evento_agenda_atend ( nr_atendimento_p bigint, ie_evento_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_evolucao_clinica_p text default null, NR_SEQ_TIPO_ATEND_p text default null, nr_seq_agenda_p text default null, cd_tipo_agenda_p text default null) FROM PUBLIC;
