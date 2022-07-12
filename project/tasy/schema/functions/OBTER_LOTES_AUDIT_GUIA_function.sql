-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lotes_audit_guia (cd_autorizacao_p text, nr_seq_lote_hist_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000) := ' ';
nr_seq_lote_audit_w	bigint;

c01 CURSOR FOR
	SELECT	distinct y.nr_seq_lote_audit
      from	lote_audit_hist y,
            lote_audit_hist_guia x
     where	x.nr_seq_lote_hist	= y.nr_sequencia
       and	coalesce(x.cd_autorizacao,'Não Informada') = coalesce(cd_autorizacao_p,'Não Informada')
       and	x.nr_interno_conta	= nr_seq_lote_hist_p
       order by y.nr_seq_lote_audit;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_lote_audit_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (ds_retorno_w = ' ') then
		ds_retorno_w := nr_seq_lote_audit_w;
	else
		ds_retorno_w := ds_retorno_w || ', ' || nr_seq_lote_audit_w;
	end if;

end loop;
close c01;

return	substr(ds_retorno_w,1,3999);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lotes_audit_guia (cd_autorizacao_p text, nr_seq_lote_hist_p bigint) FROM PUBLIC;
