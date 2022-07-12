-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
	/* 
	* Enviar Comunicação para o evento 
	*/
 


CREATE OR REPLACE PROCEDURE shift_integracao_pck.enviar_ci (nr_prescricao_p bigint) AS $body$
DECLARE

 
	c01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms 
	where	cd_estabelecimento		= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1) 
	and		upper(ie_evento_disp)	= 'FSHIFT' 
	and (obter_classif_regra(nr_sequencia,coalesce(obter_classificacao_pf(cd_pessoa_fisica),0)) = 'S') 
	and		coalesce(ie_situacao,'A') = 'A';

	nr_atendimento_w	atendimento_paciente.nr_atendimento%type;
	cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;

	
BEGIN 
	 
	if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then 
	 
		select	max(cd_pessoa_fisica), 
				max(nr_atendimento) 
		into STRICT	cd_pessoa_fisica_w, 
				nr_atendimento_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
 
		for r_c01_w in c01 loop 
			begin 
			CALL gerar_evento_paciente(	r_c01_w.nr_seq_evento, 
									nr_atendimento_w, 
									cd_pessoa_fisica_w, 
									null, 
									'TASYLAB');
			end;
		end loop;
	end if;
 
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE shift_integracao_pck.enviar_ci (nr_prescricao_p bigint) FROM PUBLIC;