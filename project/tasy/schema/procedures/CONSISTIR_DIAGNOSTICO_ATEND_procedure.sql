-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_diagnostico_atend (cd_cid_p text, nr_atendimento_p bigint) AS $body$
DECLARE

					 
ie_sexo_cid_w		varchar(1);
ie_sexo_pf_w		varchar(1);
cd_pessoa_fisica_w	varchar(10);
dt_nascimento_w		timestamp;
qt_idade_w		integer;
ie_idade_ok_w		varchar(1);
					

BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_cid_p IS NOT NULL AND cd_cid_p::text <> '') then 
	 
	/* consistir sexo cid x sexo paciente */
 
	 
		/* obter sexo cid */
 
		select	coalesce(max(ie_sexo),'A') 
		into STRICT	ie_sexo_cid_w 
		from	cid_doenca 
		where	cd_doenca_cid = cd_cid_p;
 
		/* obter dados atendimento */
 
		select	a.cd_pessoa_fisica, 
			b.dt_nascimento, 
			obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'A'), 
			coalesce(b.ie_sexo,'I') 
		into STRICT	cd_pessoa_fisica_w, 
			dt_nascimento_w, 
			qt_idade_w, 
			ie_sexo_pf_w 
		from	pessoa_fisica b, 
			atendimento_paciente a 
		where	b.cd_pessoa_fisica = a.cd_pessoa_fisica 
		and	a.nr_atendimento = nr_atendimento_p;
			 
		/* validar sexo cid x sexo paciente */
 
		if (ie_sexo_cid_w <> 'A') and (ie_sexo_pf_w <> 'I') and (ie_sexo_cid_w <> ie_sexo_pf_w) then 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(195249);
		end if;
		 
		 
	/* consistir faixa etária cid x idade paciente */
 
		 
		if (dt_nascimento_w IS NOT NULL AND dt_nascimento_w::text <> '') then 
		 
			/* consistir regra funcionamento setor */
 
			select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  
			into STRICT	ie_idade_ok_w 
			from	cid_doenca 
			where	cd_doenca_cid = cd_cid_p 
			and	((qt_idade_w < coalesce(qt_idade_min,qt_idade_w)) or (qt_idade_w > coalesce(qt_idade_max,qt_idade_w)));
				 
			if (ie_idade_ok_w = 'N') then 
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(195250);
			end if;
 
		end if;
		 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_diagnostico_atend (cd_cid_p text, nr_atendimento_p bigint) FROM PUBLIC;
