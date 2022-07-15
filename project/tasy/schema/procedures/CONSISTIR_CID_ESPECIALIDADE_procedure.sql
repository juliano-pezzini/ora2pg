-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_cid_especialidade ( cd_agenda_p bigint, cd_cid_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
cd_especialidade_w	integer;
qt_existe_regra_w	bigint;
qt_existe_regra_cid_w	bigint;
		

BEGIN 
 
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (cd_cid_p IS NOT NULL AND cd_cid_p::text <> '') then 
	begin 
	 
	/* Obter a especialidade da agenda */
 
	select	coalesce(max(cd_especialidade),0) 
	into STRICT	cd_especialidade_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;
	 
	/* Verificar se existe alguma regra para a especialidade da agenda */
 
	select	count(*) 
	into STRICT	qt_existe_regra_w 
	from	regra_agecons_cid_espec 
	where	cd_especialidade	= cd_especialidade_w;
 
	if (qt_existe_regra_w > 0) then 
		begin 
 
		/* Verifica se existe que permite utilizar o cid informado no agendamento com a especialidade da agenda */
 
		select	count(*) 
		into STRICT	qt_existe_regra_cid_w 
		from	regra_agecons_cid_espec 
		where	cd_especialidade	= cd_especialidade_w 
		and	cd_doenca_cid		= cd_cid_p;
	 
		/* Se não existir o sistema emitirá a mensagem ao usuário */
 
		if (qt_existe_regra_cid_w = 0) then 
			ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(278994,null);
		end if;
		end;
	end if;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_cid_especialidade ( cd_agenda_p bigint, cd_cid_p text, ds_erro_p INOUT text) FROM PUBLIC;

