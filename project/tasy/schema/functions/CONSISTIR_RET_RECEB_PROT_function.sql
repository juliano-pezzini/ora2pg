-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_ret_receb_prot (nr_seq_retorno_p bigint, nr_seq_receb_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*ie_opcao_p 
R	Data de referência do protocolo 
L	Data do lote dos protocolos 
*/
 
 
ds_retorno_w		varchar(10);
dt_referencia_w		timestamp;
dt_recebimento_w	timestamp;
count_w			bigint;
			

BEGIN 
 
select	max(dt_recebimento) 
into STRICT	dt_recebimento_w 
from	convenio_receb 
where	nr_sequencia	= nr_seq_receb_p;
 
if (ie_opcao_p = 'L') then 
	select	min(a.dt_mesano_referencia) 
	into STRICT	dt_referencia_w 
	from	lote_protocolo a, 
		protocolo_convenio b, 
		conta_paciente c, 
		convenio_retorno_item d 
	where	a.nr_sequencia		= b.nr_seq_lote_protocolo 
	and	b.nr_seq_protocolo	= c.nr_seq_protocolo 
	and	c.nr_interno_conta	= d.nr_interno_conta 
	and	d.nr_seq_retorno	= nr_seq_retorno_p;
end if;
 
if (ie_opcao_p = 'R') or (coalesce(dt_referencia_w::text, '') = '') then 
	 
	select	min(b.dt_mesano_referencia) 
	into STRICT	dt_referencia_w 
	from	protocolo_convenio b, 
		conta_paciente c, 
		convenio_retorno_item d 
	where	b.nr_seq_protocolo	= c.nr_seq_protocolo 
	and	c.nr_interno_conta	= d.nr_interno_conta 
	and	d.nr_seq_retorno	= nr_seq_retorno_p;
	 
end if;
 
ds_retorno_w	:= 'N';
if (trunc(dt_recebimento_w,'month') < trunc(dt_referencia_w,'month')) then 
	ds_retorno_w	:= 'S';
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_ret_receb_prot (nr_seq_retorno_p bigint, nr_seq_receb_p bigint, ie_opcao_p text) FROM PUBLIC;
