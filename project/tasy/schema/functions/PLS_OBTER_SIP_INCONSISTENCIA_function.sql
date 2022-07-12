-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_sip_inconsistencia ( nr_seq_inconsistencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



/* ie_opcao_p
	C - cód inconsistência
	D - Descrição da Inconsistência
	U - Descrição Ação do Usuário

*/
ds_retorno_w			varchar(1000);
cd_inconsistencia_w		smallint;
ds_inconsistencia_w		varchar(255);
ds_acao_usuario_w		varchar(1000);



BEGIN
if ( ie_opcao_p = 'C' ) then
	select 	cd_inconsistencia
	into STRICT	cd_inconsistencia_w
	from 	sip_inconsistencia
	where	nr_sequencia = nr_seq_inconsistencia_p;
	ds_retorno_w := cd_inconsistencia_w;
elsif ( ie_opcao_p = 'D' ) then
	select 	ds_inconsistencia
	into STRICT 	ds_inconsistencia_w
	from 	sip_inconsistencia
	where	nr_sequencia = nr_seq_inconsistencia_p;
	ds_retorno_w := ds_inconsistencia_w;
elsif ( ie_opcao_p = 'U' ) then
	select 	substr(ds_acao_usuario,1,1000)
	into STRICT	ds_acao_usuario_w
	from 	sip_inconsistencia
	where	nr_sequencia = nr_seq_inconsistencia_p;
	ds_retorno_w := ds_acao_usuario_w;
end if;



return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_sip_inconsistencia ( nr_seq_inconsistencia_p bigint, ie_opcao_p text) FROM PUBLIC;
