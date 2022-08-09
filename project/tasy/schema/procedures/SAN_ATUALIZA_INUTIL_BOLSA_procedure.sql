-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_atualiza_inutil_bolsa ( nr_seq_producao_p text, nr_seq_inutil_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
			 
nr_seq_doacao_w		bigint;			
nr_seq_producao_w	varchar(10);

			 
C01 CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	san_producao a 
	where	a.nr_seq_doacao = nr_seq_doacao_w 
	and	coalesce(a.nr_seq_inutil::text, '') = '' 
	and	coalesce(a.nr_seq_emp_saida::text, '') = '' 
	and	((coalesce(a.nr_seq_transfusao::text, '') = '') or exists (	SELECT	1 
							from	san_transfusao b 
							where	a.nr_seq_transfusao = b.nr_sequencia 
							and	coalesce(b.dt_fim_transfusao::text, '') = '')) 
	and	coalesce(a.nr_seq_emp_ent::text, '') = '';						
	 
C02 CURSOR FOR 
	SELECT distinct	nr_seq_doacao 
	from	san_producao 
	where obter_se_contido(nr_sequencia, nr_seq_producao_p) = 'S';

BEGIN
 
open C02;
loop 
fetch C02 into	 
	nr_seq_doacao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_producao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		/*update	san_producao 
		set	nr_seq_inutil = nr_seq_inutil_p 
		where	nr_sequencia = nr_seq_producao_w;*/
 
		CALL SAN_ATUALIZA_INUTIL_LOCAL(nr_seq_producao_w,nr_seq_inutil_p,cd_estabelecimento_p);
		 
		end;
	end loop;
	close C01;
	end;
end loop;
close C02;
 
 
 
 
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_atualiza_inutil_bolsa ( nr_seq_producao_p text, nr_seq_inutil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
