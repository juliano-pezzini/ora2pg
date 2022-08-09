-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desconciliar_banco ( nr_seq_concil_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE

/* 
ie_opcao_p	'T': desfaz todo o processo de conciliação selecionado 
		'C': desfaz apenas a conciliaçao selecionada 
*/
 
 
nr_seq_conciliacao_w	bigint;
nr_sequencia_w		bigint;
ie_tipo_concil_w	varchar(1);

c01 CURSOR FOR 
SELECT	nr_sequencia, 
	'M' ie_tipo_concil 
from	movto_trans_financ 
where	nr_seq_concil	= nr_seq_concil_p 

union
 
SELECT	nr_sequencia, 
	'E' ie_tipo_concil 
from	banco_extrato_lanc 
where	nr_seq_concil	= nr_seq_concil_p;

c02 CURSOR FOR 
SELECT	a.nr_sequencia, 
	'M' ie_tipo_concil 
from	movto_trans_financ a, 
	concil_banc_movto b 
where	a.nr_seq_concil		= b.nr_sequencia 
and	b.nr_seq_conciliacao	= nr_seq_conciliacao_w 

union
 
SELECT	a.nr_sequencia, 
	'E' ie_tipo_concil 
from	banco_extrato_lanc a, 
	concil_banc_movto b 
where	a.nr_seq_concil		= b.nr_sequencia 
and	b.nr_seq_conciliacao	= nr_seq_conciliacao_w;

 

BEGIN 
 
select	max(nr_seq_conciliacao) 
into STRICT	nr_seq_conciliacao_w 
from	concil_banc_movto 
where	nr_sequencia	= nr_seq_concil_p;
 
 
if (ie_opcao_p = 'C') then 	/* Desconciliar apenas a conciliação selecionada */
 
 
	open c01;
	loop 
	fetch c01 into 
		nr_sequencia_w, 
		ie_tipo_concil_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		CALL desconciliar_item(nr_sequencia_w, ie_tipo_concil_w, nm_usuario_p);
 
	end loop;
	close c01;
 
	delete	from concil_banc_movto 
	where	nr_sequencia	= nr_seq_concil_p;
 
else					/* desconciliar todos os itens da conciliação */
 
	open c02;
	loop 
	fetch c02 into 
		nr_sequencia_w, 
		ie_tipo_concil_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
 
		CALL desconciliar_item(nr_sequencia_w, ie_tipo_concil_w, nm_usuario_p);
 
	end loop;
	close c02;
 
	delete	from concil_banc_movto 
	where	nr_seq_conciliacao	= nr_seq_conciliacao_w;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desconciliar_banco ( nr_seq_concil_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
