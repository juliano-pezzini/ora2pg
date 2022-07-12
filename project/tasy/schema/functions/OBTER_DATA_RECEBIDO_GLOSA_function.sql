-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_recebido_glosa (nr_seq_hist_guia_p bigint) RETURNS timestamp AS $body$
DECLARE

			 
dt_retorno_w		timestamp;
nr_interno_conta_w	bigint;
cd_autorizacao_w	varchar(20);

 

BEGIN 
 
dt_retorno_w	:= null;
 
select	max(nr_interno_conta), 
	max(cd_autorizacao) 
into STRICT	nr_interno_conta_w, 
	cd_autorizacao_w 
from	lote_audit_hist_guia 
where	nr_sequencia	= nr_seq_hist_guia_p;
 
if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then 
	 
	select	max(a.dt_recebimento) 
	into STRICT	dt_retorno_w 
	from	titulo_receber_liq a, 
		titulo_receber b, 
		convenio_retorno_item c, 
		convenio_retorno d 
	where	d.nr_sequencia		= c.nr_seq_retorno 
	and	c.nr_titulo		= b.nr_titulo 
	and	b.nr_titulo		= a.nr_titulo 
	and	a.nr_seq_ret_item	= c.nr_sequencia 
	and	c.nr_interno_conta	= nr_interno_conta_w 
	and	c.cd_autorizacao	= cd_autorizacao_w	 
	and	d.ie_status_retorno	= 'F';	
	 
end if;
 
return	dt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_recebido_glosa (nr_seq_hist_guia_p bigint) FROM PUBLIC;

