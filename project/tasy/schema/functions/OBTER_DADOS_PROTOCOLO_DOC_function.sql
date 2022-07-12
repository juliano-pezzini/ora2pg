-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_protocolo_doc (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(60):= '';
dt_envio_w		timestamp;
nm_usuario_envio_w	varchar(15);
cd_setor_destino_w	integer;
nr_sequencia_w		bigint;

/* 	DE - Data Envio
	UE - Usuário Envio
	SD - Setor Destino
	SE - Sequência
*/
BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	begin
	select 	max(coalesce(a.cd_setor_destino,0)),
		max(coalesce(a.nm_usuario_envio,'')),
		max(coalesce(a.dt_envio,clock_timestamp())),
		max(coalesce(a.nr_sequencia,0))
	into STRICT	cd_setor_destino_w,
		nm_usuario_envio_w,
		dt_envio_w,
		nr_sequencia_w
	from   	protocolo_documento a,
		protocolo_doc_item b
	where  	a.nr_sequencia = b.nr_sequencia
	and    	b.nr_documento = nr_atendimento_p;
	exception
		when others then
			cd_setor_destino_w	:= null;
			dt_envio_w		:= null;
			nm_usuario_envio_w	:= null;
		end;

	if (coalesce(ie_opcao_p,'DE') = 'DE') then
		ds_retorno_w:= to_char(dt_envio_w,'dd/mm/yyyy');
	elsif (coalesce(ie_opcao_p,'DE') = 'UE') then
		ds_retorno_w:= nm_usuario_envio_w;
	elsif (coalesce(ie_opcao_p,'DE') = 'SD') then
		ds_retorno_w:= cd_setor_destino_w;
	elsif (coalesce(ie_opcao_p,'DE') = 'SE') then
		ds_retorno_w:= nr_sequencia_w;
	end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_protocolo_doc (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
