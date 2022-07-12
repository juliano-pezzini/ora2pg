-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_envelopamento ( nr_prescricao_p bigint, nr_sequencia_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(255);


BEGIN

begin

if (upper(ie_opcao_p) = 'N') then

	select	substr(obter_nome_usuario(a.nm_usuario_nrec),1,255)
	into STRICT	ds_retorno_w
	from	envelope_laudo_item a
	where	a.nr_prescricao	= nr_prescricao_p
	and	a.nr_seq_prescr	= nr_sequencia_prescricao_p;

elsif (upper(ie_opcao_p) = 'D') then

	select	to_char(dt_atualizacao_nrec,'dd/mm/yyyy hh24:mi:ss')
	into STRICT	ds_retorno_w
	from	envelope_laudo_item a
	where	a.nr_prescricao	= nr_prescricao_p
	and	a.nr_seq_prescr	= nr_sequencia_prescricao_p;

end if;

exception
when others then
	ds_retorno_w	:=	null;
end;



return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_envelopamento ( nr_prescricao_p bigint, nr_sequencia_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;

