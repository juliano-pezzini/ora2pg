-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_motivo_atraso ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
G - Grupo
D_Descrição
*/
ds_grupo_atraso_w	varchar(255);
ds_retorno_w		varchar(255);
ds_motivo_w		varchar(100);


BEGIN

select	max(ds_grupo_atraso),
	max(ds_motivo)
into STRICT	ds_grupo_atraso_w,
	ds_motivo_w
FROM cir_motivo_atraso b
LEFT OUTER JOIN grupo_atraso_cirurgia a ON (b.nr_seq_grupo = a.nr_sequencia)
WHERE b.nr_sequencia = nr_sequencia_p;

if (ie_opcao_p = 'G') then
	ds_retorno_w	:= ds_grupo_atraso_w;
elsif (ie_opcao_p = 'D') then
	ds_retorno_w	:= ds_motivo_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_motivo_atraso ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
