-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ev_intern_diagnostico ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_evento_w			bigint;
cd_estabelecimento_w		smallint;
cd_pessoa_fisica_w		varchar(10);
qt_idade_w			bigint;
cd_doenca_w			varchar(20);
ie_tipo_atendimento_W		smallint;
qt_existe_w			smallint;
ie_carater_inter_sus_w		varchar(10);
cd_medico_resp_w		varchar(10);
ie_sexo_w			varchar(5);
ie_clinica_w			integer;

	 
C01 CURSOR FOR	 
	SELECT	a.nr_seq_evento 
	FROM regra_envio_sms a
LEFT OUTER JOIN regra_envio_sms_atend b ON (a.nr_sequencia = b.nr_seq_regra)
WHERE a.ie_evento_disp = 'ID' and cd_estabelecimento	= cd_estabelecimento_w and qt_idade_w between coalesce(a.qt_idade_min,0) and coalesce(a.qt_idade_max,9999) and coalesce(a.ie_sexo,ie_sexo_w) = ie_sexo_w and ((coalesce(cd_doenca::text, '') = '') or (cd_doenca_w = cd_doenca)) and coalesce(a.cd_medico,coalesce(cd_medico_resp_w,'0')) = coalesce(cd_medico_resp_w,'0') and coalesce(b.ie_carater_inter_sus,coalesce(ie_carater_inter_sus_w,0)) = coalesce(ie_carater_inter_sus_w,'0') and coalesce(b.ie_tipo_atendimento,coalesce(ie_tipo_atendimento_w,0)) = coalesce(ie_tipo_atendimento_w,'0') and coalesce(b.ie_clinica,coalesce(ie_clinica_w,0)) = coalesce(ie_clinica_w,'0') and coalesce(a.ie_situacao,'A') = 'A';		
	 
 

BEGIN 
 
 
select	cd_pessoa_fisica, 
	cd_estabelecimento, 
	substr(Obter_cod_Diagnostico_atend(nr_atendimento),1,20), 
	ie_tipo_atendimento, 
	ie_carater_inter_sus, 
	cd_medico_resp, 
	Obter_Sexo_PF(cd_pessoa_fisica,'C'), 
	ie_clinica 
into STRICT	cd_pessoa_fisica_w, 
	cd_estabelecimento_w, 
	cd_doenca_w, 
	ie_tipo_atendimento_w, 
	ie_carater_inter_sus_w, 
	cd_medico_resp_w, 
	ie_sexo_w, 
	ie_clinica_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
qt_idade_w	:= coalesce(obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A'),0);
 
select	count(*) 
into STRICT	qt_existe_w 
from 	DIAGNOSTICO_MEDICO 
where 	nr_atendimento = nr_atendimento_p;
 
 
  
if (ie_tipo_atendimento_w = 1) and (qt_existe_w = 1) then 
	begin 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		CALL gerar_evento_paciente(nr_seq_evento_w,nr_atendimento_p,cd_pessoa_fisica_w,null,nm_usuario_p,null);
		end;
	end loop;
	close C01;
	 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ev_intern_diagnostico ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
