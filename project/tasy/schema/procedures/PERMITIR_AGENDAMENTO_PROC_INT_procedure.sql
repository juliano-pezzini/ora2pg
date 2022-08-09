-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE permitir_agendamento_proc_int (nr_seq_proc_interno_p bigint, cd_agenda_p bigint, cd_medico_p text, cd_convenio_p bigint) AS $body$
DECLARE


ie_permite_w varchar(1);
ie_existe_w varchar(1);


BEGIN


select	coalesce(max('S'),'N')
into STRICT	ie_existe_w
from	proc_interno_agenda a
where	a.nr_seq_proc_interno  	= nr_seq_proc_interno_p
and		a.cd_agenda		= cd_agenda_p;



if (ie_existe_w = 'S') then
	select	coalesce(max(a.ie_permite),'S')
	into STRICT	ie_permite_w
	from	proc_interno_agenda a
	where	a.nr_seq_proc_interno  	= nr_seq_proc_interno_p
	and		a.cd_agenda				= cd_agenda_p
	and		coalesce(a.cd_medico, coalesce(cd_medico_p,'0')) = coalesce(cd_medico_p,'0')
	and		coalesce(a.cd_convenio, coalesce(cd_convenio_p,'0')) = coalesce(cd_convenio_p,'0');
end if;

if (ie_permite_w = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(997171);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE permitir_agendamento_proc_int (nr_seq_proc_interno_p bigint, cd_agenda_p bigint, cd_medico_p text, cd_convenio_p bigint) FROM PUBLIC;
