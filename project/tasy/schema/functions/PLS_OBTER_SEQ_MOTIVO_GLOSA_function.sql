-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_motivo_glosa ( cd_motivo_glosa_p text) RETURNS integer AS $body$
DECLARE


nr_seq_retorno_w		bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_retorno_w
from	tiss_motivo_glosa
where	cd_motivo_tiss	= cd_motivo_glosa_p;

/*Diego 13/10/2011 - Tratamento realizado para o caso de haver mais de uma glosa com o mesmo código preferir sempre a glosa que é tratada pelo plano.*/

if (coalesce(nr_seq_retorno_w,0) = 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_retorno_w
	from	tiss_motivo_glosa
	where	cd_motivo_tiss	= cd_motivo_glosa_p;
end if;

return	nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_motivo_glosa ( cd_motivo_glosa_p text) FROM PUBLIC;

