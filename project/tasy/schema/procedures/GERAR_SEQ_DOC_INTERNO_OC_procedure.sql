-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_seq_doc_interno_oc ( nr_ordem_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
					 
nr_seq_interno_w				bigint;
cd_estabelecimento_w			smallint;
ie_seq_interna_w				varchar(1);
dt_aprovacao_w				timestamp;

BEGIN
 
select	cd_estabelecimento, 
	dt_aprovacao 
into STRICT	cd_estabelecimento_w, 
	dt_aprovacao_w 
from	ordem_compra 
where	nr_ordem_compra = nr_ordem_compra_p;
 
select	coalesce(max(ie_seq_interna),'N') 
into STRICT	ie_seq_interna_w 
from	parametro_compras 
where	cd_estabelecimento = cd_estabelecimento_w;
 
if (ie_seq_interna_w = 'Z') then 
 
	select	coalesce(max(nr_seq_interno),0) + 1 
	into STRICT	nr_seq_interno_w 
	from	ordem_compra 
	where	PKG_DATE_UTILS.START_OF(dt_aprovacao,'yy') = PKG_DATE_UTILS.START_OF(clock_timestamp(),'yy');
 
	update	ordem_compra 
	set	nr_seq_interno = nr_seq_interno_w 
	where	nr_ordem_compra = nr_ordem_compra_p 
	and	coalesce(nr_seq_interno::text, '') = '';
end if;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_seq_doc_interno_oc ( nr_ordem_compra_p bigint, nm_usuario_p text) FROM PUBLIC;
