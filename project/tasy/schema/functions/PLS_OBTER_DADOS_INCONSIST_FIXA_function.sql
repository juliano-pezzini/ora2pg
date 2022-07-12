-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_inconsist_fixa ( nr_seq_inconsistencia_p pls_inconsistencia_inc_seg.nr_sequencia%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p:
	CD - código da inconsistência
	DS - descrição da inconsistência
*/
ds_retorno_w		varchar(255) := '';
cd_inconsistencia_w	pls_inconsistencia_inc_seg.cd_inconsistencia%type;
ds_inconsistencia_w	pls_inconsistencia_inc_seg.ds_inconsistencia%type;


BEGIN

if (nr_seq_inconsistencia_p IS NOT NULL AND nr_seq_inconsistencia_p::text <> '') then
	select	cd_inconsistencia,
		substr(ds_inconsistencia,1,255)
	into STRICT	cd_inconsistencia_w,
		ds_inconsistencia_w
	from	pls_inconsistencia_inc_seg
	where	nr_sequencia = nr_seq_inconsistencia_p;

	if (ie_opcao_p = 'CD') then
		ds_retorno_w := cd_inconsistencia_w;
	elsif (ie_opcao_p = 'DS') then
		ds_retorno_w := ds_inconsistencia_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_inconsist_fixa ( nr_seq_inconsistencia_p pls_inconsistencia_inc_seg.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;
