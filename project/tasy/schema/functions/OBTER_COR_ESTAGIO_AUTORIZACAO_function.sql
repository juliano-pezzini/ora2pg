-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_estagio_autorizacao ( nr_seq_estagio_p bigint, cd_empresa_p text) RETURNS varchar AS $body$
DECLARE


ds_cor_w	varchar(10);
ds_cor_fundo_w	varchar(10);

BEGIN
if (nr_seq_estagio_p IS NOT NULL AND nr_seq_estagio_p::text <> '') and (cd_empresa_p IS NOT NULL AND cd_empresa_p::text <> '') then

	select  coalesce(ds_cor,'clWhite') ds_cor
	into STRICT	ds_cor_fundo_w
	from    estagio_autorizacao
	where   cd_empresa = cd_empresa_p
	and     nr_sequencia = nr_seq_estagio_p
	and     ie_situacao = 'A'
	order by  ds_estagio;


	ds_cor_w := ds_cor_fundo_w;
end if;

return ds_cor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_estagio_autorizacao ( nr_seq_estagio_p bigint, cd_empresa_p text) FROM PUBLIC;

