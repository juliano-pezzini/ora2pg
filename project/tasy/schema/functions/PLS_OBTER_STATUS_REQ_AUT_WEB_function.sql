-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_status_req_aut_web ( nr_seq_requisicao_p bigint, nr_seq_guia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_estagio_w		smallint;
ds_estagio_w		varchar(255);
ie_status_w		varchar(3);
dt_solicitacao_w	varchar(25);



BEGIN

select	ie_estagio,
	obter_valor_dominio(3431,ie_estagio)
into STRICT	ie_estagio_w,
	ds_estagio_w
from 	pls_requisicao
where	nr_sequencia = nr_seq_requisicao_p;

if (ie_estagio_w = 4 ) then
	select	max(ie_status)
	into STRICT	ie_status_w
	from	pls_auditoria
	where 	nr_seq_requisicao = nr_seq_requisicao_p;

	select 	coalesce(max(to_char(dt_atualizacao, 'dd/mm/yyyy hh24:mi:ss')),0)
	into STRICT	dt_solicitacao_w
	from 	ptu_pedido_autorizacao
	where 	nr_seq_requisicao = nr_seq_requisicao_p;

	if (dt_solicitacao_w <> '0' and ie_status_w = 'AJ') then
		ds_estagio_w := 'Intercâmbio aguardando unimed de origem desde '||dt_solicitacao_w;
	elsif (ie_status_w = 'AJ') then
		ds_estagio_w := 'Aguardando justificativa do médico';
	end if;
elsif (ie_estagio_w = 7 ) then
	ds_estagio_w := 'Entre em contato com a operadora';
end if;

ds_retorno_w	:= ds_estagio_w;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_status_req_aut_web ( nr_seq_requisicao_p bigint, nr_seq_guia_p bigint) FROM PUBLIC;

