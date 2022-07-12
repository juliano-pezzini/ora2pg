-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tratamento_fatura ( nr_seq_tipo_fatura_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


cd_tipo_tratamento_w	varchar(5)	:= '';
ds_tipo_tratamento_w	varchar(255) 	:= '';


BEGIN

select	max(to_char(cd_tipo_tratamento)),
	max(ds_tipo_tratamento)
into STRICT	cd_tipo_tratamento_w,
	ds_tipo_tratamento_w
from	fatur_tipo_fatura
where	nr_sequencia = nr_seq_tipo_fatura_p;

if (ie_opcao_p = 'C') then
    return cd_tipo_tratamento_w;
else
    return ds_tipo_tratamento_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tratamento_fatura ( nr_seq_tipo_fatura_p bigint, ie_opcao_p text) FROM PUBLIC;

