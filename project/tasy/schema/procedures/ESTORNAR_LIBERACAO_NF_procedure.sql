-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_liberacao_nf ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_estabelecimento_w	smallint;
ie_estorna_aprov_solic_w	varchar(1);
nr_seq_aprovacao_w	bigint;

c01 CURSOR FOR
SELECT	distinct nr_seq_aprovacao
from	nota_fiscal_item
where	nr_sequencia	= nr_sequencia_p;


BEGIN

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	nota_fiscal
where	nr_sequencia	= nr_sequencia_p;

update	nota_fiscal
set	dt_liberacao	 = NULL,
	nm_usuario_lib	= '',
	dt_aprovacao	 = NULL,
	nm_usuario_aprov	= ''	
where	nr_sequencia	= nr_sequencia_p;

open C01;
loop
fetch C01 into	
	nr_seq_aprovacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	delete
	from	processo_aprov_compra
	where	nr_sequencia 	= nr_seq_aprovacao_w;
	
	end;
end loop;
close C01;

update	nota_fiscal_item
set	nr_seq_aprovacao	 = NULL,
	dt_aprovacao	 = NULL,
	nm_usuario_aprov	= '',
    dt_reprovacao  = NULL
where	nr_sequencia	= nr_sequencia_p;

CALL gerar_historico_nota_fiscal(
			nr_Sequencia_p,
			nm_usuario_p,
			'44',
			wheb_mensagem_pck.get_texto(313406,'DT_REF_W='|| to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss') ||';NM_USUARIO_P='|| NM_USUARIO_P));
			/*'Foi estornado a liberacao da nota fiscal no dia ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') || ' pelo usuario ' || nm_usuario_p || '.');*/

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_liberacao_nf ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
