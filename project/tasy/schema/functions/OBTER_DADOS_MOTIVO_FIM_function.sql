-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_motivo_fim (nr_seq_motivo_fim_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
D - descrição
*/
ds_retorno_w		varchar(255);
ds_motivo_fim_w		varchar(255);
ie_tipo_tratamento_w	varchar(15);


BEGIN


select 	max(ds_motivo_fim),
	max(ie_tipo_tratamento)
into STRICT	ds_motivo_fim_w,
	ie_tipo_tratamento_w
from 	motivo_fim
where 	nr_sequencia = nr_seq_motivo_fim_p;

if (ie_opcao_p = 'D') then
	ds_retorno_w := ds_motivo_fim_w;
elsif (ie_opcao_p = 'T') then
	ds_retorno_w := ie_tipo_tratamento_w;
end if;



return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_motivo_fim (nr_seq_motivo_fim_p bigint, ie_opcao_p text) FROM PUBLIC;
