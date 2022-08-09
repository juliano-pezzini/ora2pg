-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_intercambio ( nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
cd_unimed_destino_w		varchar(10);
nr_seq_envio_w			integer;
				

BEGIN 
 
/* Obter dados do envio */
 
select	cd_unimed_destino 
into STRICT	cd_unimed_destino_w 
from	ptu_intercambio 
where	nr_sequencia	= nr_sequencia_p;
 
delete from ptu_intercambio_plano	a 
where	exists (SELECT 1 from ptu_intercambio_empresa b where b.nr_seq_intercambio = nr_sequencia_p and b.nr_sequencia = a.nr_seq_empresa);
	 
delete from ptu_intercambio_benef	a 
where	exists (SELECT 1 from ptu_intercambio_empresa b where b.nr_seq_intercambio = nr_sequencia_p and b.nr_sequencia = a.nr_seq_empresa);	
	 
delete from ptu_intercambio_empresa 
where	nr_seq_intercambio	= nr_sequencia_p;
 
/* Gerar R102 - EMPRESA CONTRATANTE */
 
CALL ptu_gerar_intercambio_empresa(nr_sequencia_p, nm_usuario_p,cd_estabelecimento_p);
 
select	max(coalesce(nr_seq_envio,0)) + 1 
into STRICT	nr_seq_envio_w 
from	ptu_intercambio 
where	cd_unimed_destino	= cd_unimed_destino_w;
 
if (nr_seq_envio_w	> 9999) then 
	nr_seq_envio_w	:= 1;
end if;
 
update	ptu_intercambio 
set	nr_seq_envio	= nr_seq_envio_w 
where	nr_sequencia	= nr_sequencia_p;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_intercambio ( nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
