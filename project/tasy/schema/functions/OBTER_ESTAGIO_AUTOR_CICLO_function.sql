-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estagio_autor_ciclo ( nr_seq_atendimento_p bigint, nr_seq_paciente_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
IE_OPÇÃO:
E - Sequência do estágio
I - ie_interno
DE - Descrição do estágio
DI - Descrição do interno
*/
ds_retorno_w			varchar(255) := '1';
nr_ciclo_w			smallint;
ds_dia_ciclo_w			varchar(5);
nr_seq_estagio_autor_w		bigint;
ds_estagio_w			varchar(60);
ie_interno_w			varchar(2);
ie_opcao_w			varchar(2);


BEGIN

ie_opcao_w	:= ie_opcao_p;

select	max(nr_ciclo),
	max(ds_dia_ciclo)
into STRICT	nr_ciclo_w,
	ds_dia_ciclo_w
from	paciente_atendimento
where	nr_seq_atendimento = nr_seq_atendimento_p;

begin
select	max(a.nr_seq_estagio),
	max(b.ie_interno),
	max(b.ds_estagio)
into STRICT	nr_seq_estagio_autor_w,
	ie_interno_w,
	ds_estagio_w
from	autorizacao_convenio a,
	estagio_autorizacao b
where	a.nr_ciclo 		= nr_ciclo_w
and	((a.ds_dia_ciclo 		= ds_dia_ciclo_w) or (coalesce(a.ds_dia_ciclo, 'X') 	= 'X'))
and	a.nr_seq_paciente_setor 	= nr_seq_paciente_p
and	a.nr_seq_estagio		= b.nr_sequencia;
exception
when others then
	ie_opcao_w := '';
end;

if (ie_opcao_w = 'E') then
	begin
	ds_retorno_w := nr_seq_estagio_autor_w;
	end;
elsif (ie_opcao_w = 'I') then
	begin
	ds_retorno_w := ie_interno_w;
	end;
elsif (ie_opcao_w = 'DE') then
	begin
	ds_retorno_w := ds_estagio_w;
	end;
elsif (ie_opcao_w = 'DI') then
	begin
	ds_retorno_w := obter_valor_dominio(1378,ie_interno_w);
	end;
end if;

return coalesce(ds_retorno_w,'1');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estagio_autor_ciclo ( nr_seq_atendimento_p bigint, nr_seq_paciente_p bigint, ie_opcao_p text) FROM PUBLIC;
