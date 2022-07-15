-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_cancelar_tit_rec_nf ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

		 
cd_estabelecimento_w	smallint;
ie_canc_titulo_nota_w	varchar(1);
nr_titulo_w		bigint;

C02 CURSOR FOR 
SELECT	nr_titulo 
from	titulo_receber 
where	nr_seq_nf_saida = nr_sequencia_p 
and	ie_situacao	<> '3';


BEGIN 
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	nota_fiscal 
where	nr_sequencia = nr_sequencia_p;
 
select	coalesce(max(ie_canc_titulo_nota),'B') 
into STRICT	ie_canc_titulo_nota_w 
from	parametro_contas_receber 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
if (ie_canc_titulo_nota_w = 'A') then 
	open c02;
	loop 
	fetch c02 into 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		CALL cancelar_titulo_receber(nr_titulo_w,nm_usuario_p,'N',clock_timestamp());
	end loop;
	close c02;
else 
	CALL cancelar_titulo_receber_nfs(nr_sequencia_p, nm_usuario_p, cd_estabelecimento_w);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_cancelar_tit_rec_nf ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

