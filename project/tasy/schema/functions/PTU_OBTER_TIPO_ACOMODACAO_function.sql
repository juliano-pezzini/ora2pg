-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_tipo_acomodacao ( nr_seq_pacote_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w            	varchar(100);
ie_tipo_acomodacao_w    	varchar(1);


BEGIN
select  max(ie_tipo_acomodacao)
into STRICT    ie_tipo_acomodacao_w
from    ptu_pacote_reg
where  	nr_seq_pacote	= nr_seq_pacote_p
and 	nr_sequencia	= nr_sequencia_p;

if (ie_tipo_acomodacao_w = 'A')  then
	ds_retorno_w	:= 'Coletiva';
elsif (ie_tipo_acomodacao_w = 'B')  then
        ds_retorno_w	:= 'Individual';
elsif (ie_tipo_acomodacao_w = 'C')  then
        ds_retorno_w	:= 'Não se aplica';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_tipo_acomodacao ( nr_seq_pacote_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

