-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_peso_altura_ciclos_onc ( nr_seq_paciente_p bigint, qt_peso_p bigint, qt_altura_p bigint, nm_usuario_p text) AS $body$
DECLARE

				

ie_status_pac_w 	varchar(80);

BEGIN

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') and
	((qt_peso_p > 0) or (qt_altura_p > 0))then
	
	select 	max(obter_status_paciente_qt(nr_seq_atendimento,dt_inicio_adm,dt_fim_adm,nr_seq_local,ie_exige_liberacao,dt_chegada,'C'))
	into STRICT	ie_status_pac_w
	from	paciente_atendimento
	where  	coalesce(dt_suspensao::text, '') = ''
	and    	nr_seq_paciente = nr_seq_paciente_p
	and    	coalesce(nr_prescricao::text, '') = '';
	
	if (ie_status_pac_w <> '83') then
	
		Update 	paciente_atendimento
		set    	qt_peso = CASE WHEN coalesce(qt_peso_p,0)=0 THEN qt_peso  ELSE qt_peso_p END ,
				qt_altura = CASE WHEN coalesce(qt_altura_p,0)=0 THEN qt_altura  ELSE qt_altura_p END ,
				dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p
		where  	coalesce(dt_suspensao::text, '') = ''
		and    	nr_seq_paciente = nr_seq_paciente_p
		and    	coalesce(nr_prescricao::text, '') = '';
	
	end if;

end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_peso_altura_ciclos_onc ( nr_seq_paciente_p bigint, qt_peso_p bigint, qt_altura_p bigint, nm_usuario_p text) FROM PUBLIC;
