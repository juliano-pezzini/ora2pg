-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_exame_agenda ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ds_exame_w	procedimento.ds_procedimento%TYPE;


BEGIN
if	(((coalesce(cd_procedimento_p,0) > 0) and (coalesce(ie_origem_proced_p,0) > 0)) or (coalesce(nr_seq_proc_interno_p,0) > 0)) then

	/* obter descrição interna */

	if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') and (nr_seq_proc_interno_p > 0) then
		select	substr(max(ds_proc_exame),1,255)
		into STRICT	ds_exame_w
		from	proc_interno
		where	nr_sequencia = nr_seq_proc_interno_p;
	else
		/* obter descrição padrão */

		select	substr(obter_descricao_procedimento(cd_procedimento_p, ie_origem_proced_p),1,255)
		into STRICT	ds_exame_w
		;
	end if;

	/* validar exame */

	if (ds_exame_w = wheb_mensagem_pck.get_texto(300654)) then
		ds_exame_w := null;
	end if;
end if;

return ds_exame_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_exame_agenda ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint) FROM PUBLIC;
