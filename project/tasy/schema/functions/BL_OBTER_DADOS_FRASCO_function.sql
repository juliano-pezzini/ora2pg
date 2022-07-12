-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bl_obter_dados_frasco ( nr_seq_frasco_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/* 
ie_opcao_p 
F - Código do frasco 
D - Data da coleta 
V - Volume 
Q - Qtd de dias 
I - Data inutilização 
DMI - Descrição Motivo inutilização 
*/
 
			 
ds_retorno_w		varchar(255);
cd_frasco_w		varchar(20);
dt_coleta_w		varchar(255);
qt_volume_w		bigint;
qt_dias_w		bigint;
dt_inutilizacao_w	varchar(255);
ds_motivo_inutil_w	varchar(80);
			

BEGIN 
if (nr_seq_frasco_p IS NOT NULL AND nr_seq_frasco_p::text <> '') then 
 
	select	a.cd_frasco, 
		to_char(a.dt_coleta,'dd/mm/yyyy hh24:mi:ss'), 
		a.qt_volume, 
		trunc(clock_timestamp() - a.dt_coleta) qt_dias, 
		to_char(a.dt_inutilizacao,'dd/mm/yyyy hh24:mi:ss'), 
		ds_motivo_inutil 
	into STRICT	cd_frasco_w, 
		dt_coleta_w, 
		qt_volume_w, 
		qt_dias_w, 
		dt_inutilizacao_w, 
		ds_motivo_inutil_w 
	from	bl_frasco_v a 
	where	a.nr_sequencia = nr_seq_frasco_p;
 
	if (ie_opcao_p = 'F') then 
		ds_retorno_w := cd_frasco_w;
	elsif (ie_opcao_p = 'D') then 
		ds_retorno_w := dt_coleta_w;
	elsif (ie_opcao_p = 'V') then 
		ds_retorno_w := qt_volume_w;
	elsif (ie_opcao_p = 'Q') then 
		ds_retorno_w := qt_dias_w;
	elsif (ie_opcao_p = 'I') then 
		ds_retorno_w := dt_inutilizacao_w;
	elsif (ie_opcao_p = 'DMI') then 
		ds_retorno_w := ds_motivo_inutil_w;
	end if;
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bl_obter_dados_frasco ( nr_seq_frasco_p bigint, ie_opcao_p text) FROM PUBLIC;
