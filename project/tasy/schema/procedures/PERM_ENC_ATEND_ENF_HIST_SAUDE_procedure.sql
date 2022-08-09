-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE perm_enc_atend_enf_hist_saude (nr_atendimento_p bigint) AS $body$
DECLARE

 
ie_hist_saude_w varchar(1);


BEGIN 
 
select	coalesce(max('S'),'N') 
into STRICT	ie_hist_saude_w 
from	paciente_alergia 
where	nr_atendimento	= nr_atendimento_p 
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
 
if (ie_hist_saude_w = 'N') then 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_hist_saude_w 
	from	paciente_habito_vicio 
	where	nr_atendimento	= nr_atendimento_p	 
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
end if;	
 
if (ie_hist_saude_w = 'N') then 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_hist_saude_w 
	from	paciente_medic_uso 
	where	nr_atendimento	= nr_atendimento_p 
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
end if;	
 
if (ie_hist_saude_w = 'N') then 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_hist_saude_w 
	from	paciente_antec_clinico 
	where	nr_atendimento	= nr_atendimento_p 
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
end if;	
 
 
if (ie_hist_saude_w = 'N') then 
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(266325);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE perm_enc_atend_enf_hist_saude (nr_atendimento_p bigint) FROM PUBLIC;
