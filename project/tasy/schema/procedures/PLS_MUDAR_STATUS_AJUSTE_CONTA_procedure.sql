-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_mudar_status_ajuste_conta (nr_seq_ajuste_conta_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

 
nr_seq_ajuste_fatura_w		integer;
qt_conta_aberta_w		integer;
nr_seq_analise_w		pls_analise_conta.nr_sequencia%type;
ie_status_w			pls_analise_conta.ie_status%type;
ds_retorno_w			varchar(255);
ie_status_refat_w		pls_ajuste_fatura_conta.ie_status%type;


BEGIN 
 
begin 
	select	somente_numero(PLS_OBTER_DADOS_AJUSTE_CONTA(nr_sequencia,'SEQA')), 
		ie_status 
	into STRICT	nr_seq_analise_w, 
		ie_status_refat_w 
	from	pls_ajuste_fatura_conta 
	where	nr_sequencia	= nr_seq_ajuste_conta_p;
exception 
when others then 
	nr_seq_analise_w := null;
end;
 
if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') and (nr_seq_analise_w != 0) then 
	select	ie_status 
	into STRICT	ie_status_w 
	from	pls_analise_conta 
	where	nr_sequencia	= nr_seq_analise_w;
	 
	if (ie_status_w != 'T') and (ie_status_refat_w = 'N')then 
		ds_retorno_w	:= 'Análise da conta ainda pendente favor verificar ! ';
	end if;
end if;
 
if (coalesce(ds_retorno_w::text, '') = '') then 
	update	pls_ajuste_fatura_conta 
	set	ie_status		= CASE WHEN ie_status='N' THEN 'A'  ELSE 'N' END , 
		dt_conclusao_ajuste	= CASE WHEN ie_status='N' THEN  clock_timestamp()  ELSE null END , 
		nm_usuario_concl	= CASE WHEN ie_status='N' THEN  nm_usuario_p  ELSE null END  
	where	nr_sequencia		= nr_seq_ajuste_conta_p;
 
	select	max(x.nr_seq_ajuste_fatura) 
	into STRICT	nr_seq_ajuste_fatura_w 
	from	pls_ajuste_fatura_conta x 
	where	x.nr_sequencia 	= nr_seq_ajuste_conta_p;
 
	select	count(1) 
	into STRICT	qt_conta_aberta_w 
	from	pls_ajuste_fatura_conta a 
	where	a.nr_seq_ajuste_fatura	= nr_seq_ajuste_fatura_w 
	and	a.ie_status		<> 'A';
 
	update	pls_ajuste_fatura 
	set	ie_status		= CASE WHEN qt_conta_aberta_w=0 THEN  'A'  ELSE 'N' END , 
		dt_conclusao_ajuste	= CASE WHEN qt_conta_aberta_w=0 THEN  clock_timestamp()  ELSE null END , 
		nm_usuario_concl	= CASE WHEN qt_conta_aberta_w=0 THEN  nm_usuario_p  ELSE null END  
	where	nr_sequencia		= nr_seq_ajuste_fatura_w;
end if;
 
ds_retorno_p := ds_retorno_w;
 
commit;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mudar_status_ajuste_conta (nr_seq_ajuste_conta_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
