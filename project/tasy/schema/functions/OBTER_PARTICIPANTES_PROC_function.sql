-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_participantes_proc (nr_seq_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


nm_participante_w	varchar(2000);
ds_retorno_w		varchar(2000);
nm_partic_aux_w		varchar(150);

c01 CURSOR FOR
	SELECT	substr(obter_nome_pf(cd_pessoa_fisica),1,60) || '(' || substr(obter_valor_dominio(15, ie_funcao),1,60) || ') '
	from	procedimento_participante
	where	nr_sequencia	= nr_seq_procedimento_p;


BEGIN

open c01;
loop
fetch c01 into
	nm_partic_aux_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	nm_participante_w	:= nm_participante_w || ' - ' || nm_partic_aux_w;
	end;
end loop;
close c01;

ds_retorno_w	:= substr(nm_participante_w,4,2000);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_participantes_proc (nr_seq_procedimento_p bigint) FROM PUBLIC;
