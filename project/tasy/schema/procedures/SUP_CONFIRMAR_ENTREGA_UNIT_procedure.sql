-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_confirmar_entrega_unit ( nr_seq_unitarizacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
--SOLIC_UNITARIZACAO 
nr_solic_unitarizacao_w	solic_unitarizacao.nr_sequencia%type;
cd_local_origem_w	solic_unitarizacao.cd_local_estoque_origem%type;
cd_local_destino_w	solic_unitarizacao.cd_local_estoque_destino%type;
	
--PESSOA_FISICA 
cd_pessoa_entrega_w	pessoa_fisica.cd_pessoa_fisica%type;

BEGIN
cd_pessoa_entrega_w := substr(Obter_Pessoa_Fisica_Usuario(nm_usuario_p, 'C'),1,10);
 
select	nr_solic_unitarizacao 
into STRICT	nr_solic_unitarizacao_w 
from	unitarizacao 
where	nr_sequencia = nr_seq_unitarizacao_p;
 
select	cd_local_estoque_origem, 
	cd_local_estoque_destino 
into STRICT	cd_local_origem_w, 
	cd_local_destino_w 
from	solic_unitarizacao 
where	nr_sequencia = nr_solic_unitarizacao_w;
 
update	unitarizacao 
set	dt_entrega = clock_timestamp(), 
	cd_pessoa_entrega = cd_pessoa_entrega_w 
where	nr_sequencia = nr_seq_unitarizacao_p;
 
if (cd_local_origem_w <> cd_local_destino_w) then 
	CALL gerar_movto_estoque_trans_unit(nr_seq_unitarizacao_p, null, '1', 'T', nm_usuario_p);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_confirmar_entrega_unit ( nr_seq_unitarizacao_p bigint, nm_usuario_p text) FROM PUBLIC;

