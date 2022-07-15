-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_diagnostico_alta_externo ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
cd_doenca_cid_w			varchar(10);
cd_medico_resp_w		varchar(10);
ie_forma_geracao_medico_w	varchar(5);
cd_medico_atend_w		varchar(10);
dt_diagnostico_w		timestamp;
qt_diagnostico_w		bigint;
ie_tipo_atendimento_w		smallint;


BEGIN 
 
if (cd_setor_atendimento_p > 0) then 
	 
	select 	max(cd_doenca_cid), 
		max(cd_medico_resp), 
		max(ie_forma_geracao_medico), 
		clock_timestamp() 
	into STRICT	cd_doenca_cid_w, 
		cd_medico_resp_w, 
		ie_forma_geracao_medico_w, 
		dt_diagnostico_w 
	from	regra_alta_auto_cid 
	where 	cd_setor_atendimento =	cd_setor_atendimento_p 
	and	obter_se_atend_agenda_pac(nr_atendimento_p, cd_agenda) = 'S' 
	and	((Obter_Convenio_Atendimento(nr_atendimento_p) = cd_convenio) or (coalesce(cd_convenio::text, '') = ''));	
	 
	if (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> '') then 
			 
		select 	max(cd_medico_resp), 
			max(ie_tipo_atendimento) 
		into STRICT	cd_medico_atend_w, 
			ie_tipo_atendimento_w 
		from 	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_p;
			 
		select 	count(*) 
		into STRICT	qt_diagnostico_w 
		from 	diagnostico_medico 
		where 	nr_atendimento = nr_atendimento_p;
							 
		if (qt_diagnostico_w = 0) then 
		 
			--Richart Tratei para caso a forma de geracao do medico for 'F' e a variavel cd_medico_resp_w estiver NULL pega o medico do atendimento 
			--pelo motivo em que na regra o médico não é obrigatório informar sendo que na tabela é obrigatório - OS: 508048		 
			insert into diagnostico_medico( 
				nr_atendimento, 
				dt_diagnostico, 
				ie_tipo_diagnostico, 
				cd_medico, 
				dt_atualizacao, 
				nm_usuario, 
				ie_tipo_atendimento 
				) 
			values ( 
				nr_atendimento_p, 
				dt_diagnostico_w, 
				2, 
				CASE WHEN ie_forma_geracao_medico_w='F' THEN coalesce(cd_medico_resp_w,cd_medico_atend_w)  ELSE cd_medico_atend_w END , 
				clock_timestamp(), 
				nm_usuario_p, 
				ie_tipo_atendimento_w 
				);
 
			insert into diagnostico_doenca( 
				nr_atendimento, 
				dt_diagnostico, 
				cd_doenca, 
				dt_atualizacao, 
				nm_usuario, 
				ie_classificacao_doenca 
				) 
			values ( 
				nr_atendimento_p, 
				dt_diagnostico_w, 
				cd_doenca_cid_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				'P' 
				);
				 
		end if;		
				 
	end if;		
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_diagnostico_alta_externo ( nr_atendimento_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

