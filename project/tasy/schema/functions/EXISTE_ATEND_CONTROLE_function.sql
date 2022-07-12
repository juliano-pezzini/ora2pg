-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION existe_atend_controle (nr_atendimento_p bigint, nr_seq_episodio_p bigint) RETURNS varchar AS $body$
DECLARE



ie_retorno_w varchar(1) := 'N';

BEGIN

if (coalesce(pkg_i18n.get_user_locale,'pt_BR') not in ('de_DE', 'de_AT')) then
    return 'N';
end if;

if (coalesce(nr_atendimento_p,0) <> 0) or (coalesce(nr_seq_episodio_p,0) <> 0) then
	select coalesce(max('S'),'N')
	into STRICT ie_retorno_w
	from atend_paciente_controle
	where 1 = 1
	and (((nr_atendimento = nr_atendimento_p) and (ie_status_atendimento in ('I', 'C'))) or
	     ((nr_seq_episodio = nr_seq_episodio_p) and (ie_status_episodio in ('I','C'))));
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION existe_atend_controle (nr_atendimento_p bigint, nr_seq_episodio_p bigint) FROM PUBLIC;

