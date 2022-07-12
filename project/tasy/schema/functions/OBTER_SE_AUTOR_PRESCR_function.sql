-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_autor_prescr (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


/*Function retorna N se existir uma autorização para a prescrição que ainda não esta autorizada */

ds_retorno_w	varchar(1);


BEGIN

ds_retorno_w	:= 'S';

begin
	select	'N'
	into STRICT	ds_retorno_w
	from	autorizacao_convenio a,
		estagio_autorizacao b
	where	a.nr_seq_estagio	= b.nr_sequencia
	and	a.nr_prescricao	= nr_prescricao_p
	and	b.ie_interno	<> '10'  LIMIT 1;
exception
when others then
	ds_retorno_w	:= 'S';
end;

return 	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_autor_prescr (nr_prescricao_p bigint) FROM PUBLIC;
