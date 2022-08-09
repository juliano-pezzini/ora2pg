-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_ocorrencia_ordem_compra ( nr_ordem_compra_p bigint, nr_seq_reg_ocorr_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
DECLARE

 
ie_sistema_origem_w		varchar(15);						
						 

BEGIN 
 
insert into ordem_compra_registro_ocor( 
	nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	nr_ordem_compra, 
	nr_seq_reg_ocorr, 
	ds_justificativa) 
values (	nextval('ordem_compra_registro_ocor_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	nr_ordem_compra_p, 
	nr_seq_reg_ocorr_p, 
	ds_justificativa_p);
 
 
select	max(ie_sistema_origem) 
into STRICT	ie_sistema_origem_w 
from	ordem_compra 
where	nr_ordem_compra = nr_ordem_compra_p;
 
if (ie_sistema_origem_w IS NOT NULL AND ie_sistema_origem_w::text <> '') then 
	 
	update	ordem_compra 
	set	ie_necessita_enviar_int	= 'S', 
		nm_usuario_altera_int	= nm_usuario_p 
	where	nr_ordem_compra		= nr_ordem_compra_p;
 
end if;
	 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_ocorrencia_ordem_compra ( nr_ordem_compra_p bigint, nr_seq_reg_ocorr_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
