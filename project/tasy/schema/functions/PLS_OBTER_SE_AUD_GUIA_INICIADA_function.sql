-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_aud_guia_iniciada ( nr_seq_guia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
qt_auditoria_assumida_w		integer;
qt_parecer_w			integer;
ie_estagio_w			integer;


BEGIN

select	ie_estagio
into STRICT	ie_estagio_w
from	pls_guia_plano
where	nr_sequencia = nr_seq_guia_p;

if (ie_estagio_w = 1) then
	select	count(*)
	into STRICT	qt_auditoria_assumida_w
	from	pls_auditoria a,
		pls_auditoria_grupo b
	where	a.nr_seq_guia	= nr_seq_guia_p
	and	a.nr_sequencia	= b.nr_seq_auditoria
	and	(nm_usuario_exec IS NOT NULL AND nm_usuario_exec::text <> '');

	select	count(*)
	into STRICT	qt_parecer_w
	from	pls_guia_plano_historico
	where	nr_seq_guia = nr_seq_guia_p
	and	(nr_seq_item IS NOT NULL AND nr_seq_item::text <> '');

	if (qt_auditoria_assumida_w > 0) or (qt_parecer_w > 0) then
		ds_retorno_w := 'S';
	end if;
else
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_aud_guia_iniciada ( nr_seq_guia_p bigint) FROM PUBLIC;
