-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION spa_obter_nota_fiscal_regra ( nr_seq_spa_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint;
nr_seq_movimento_w	bigint;
cd_classificacao_w	integer;
nr_interno_conta_w	bigint;
nr_seq_nf_w		bigint;
nr_titulo_w		bigint;
nr_seq_protocolo_w	bigint;
nr_seq_nf_atual_w	bigint;
nr_nota_titulo_w	varchar(255);

C01 CURSOR FOR
	SELECT	cd_classificacao,
		nr_interno_conta,
		nr_seq_nf,
		nr_titulo,
		nr_seq_protocolo
	from	spa_movimento
	where	nr_seq_spa = nr_seq_spa_p
	and	cd_classificacao <> 1;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	nota_fiscal
	where	nr_interno_conta = nr_interno_conta_w
	and	ie_situacao = '1'
	
union

	SELECT	nr_seq_nf_saida
	from	titulo_receber
	where	nr_interno_conta = nr_interno_conta_w
	order by 1 desc;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	nota_fiscal
	where	nr_seq_protocolo = nr_seq_protocolo_w
	and	ie_situacao = '1'
	
union

	SELECT	nr_seq_nf_saida
	from	titulo_receber
	where	nr_seq_protocolo = nr_seq_protocolo_w
	order by 1 desc;


BEGIN

if (coalesce(nr_seq_spa_p,0) > 0) then

	open C01;
	loop
	fetch C01 into
		cd_classificacao_w,
		nr_interno_conta_w,
		nr_seq_nf_w,
		nr_titulo_w,
		nr_seq_protocolo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (cd_classificacao_w = 2) then

			open C02;
			loop
			fetch C02 into
				nr_seq_nf_atual_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				nr_seq_nf_atual_w	:= nr_seq_nf_atual_w;
				end;
			end loop;
			close C02;

		elsif (cd_classificacao_w = 3) then

			nr_seq_nf_atual_w	:= nr_seq_nf_w;

		elsif (cd_classificacao_w = 4) then

			select	max(nr_nota_fiscal)
			into STRICT	nr_nota_titulo_w
			from	titulo_receber
			where	nr_titulo = nr_titulo_w;

			select	max(nr_sequencia)
			into STRICT	nr_seq_nf_atual_w
			from	nota_fiscal
			where	nr_nota_fiscal = nr_nota_titulo_w;

		elsif (cd_classificacao_w = 5) then

			open C03;
			loop
			fetch C03 into
				nr_seq_nf_atual_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				nr_seq_nf_atual_w	:= nr_seq_nf_atual_w;
				end;
			end loop;
			close C03;

		end if;

		if (coalesce(nr_seq_nf_atual_w,0) <> 0) and
			((coalesce(nr_seq_nf_w,0) = 0) or (coalesce(nr_seq_nf_atual_w,0) < coalesce(nr_seq_nf_w,0))) then
			nr_seq_nf_w	:= nr_seq_nf_atual_w;
		end if;

		end;
	end loop;
	close C01;

	nr_retorno_w	:= nr_seq_nf_w;

end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION spa_obter_nota_fiscal_regra ( nr_seq_spa_p bigint) FROM PUBLIC;
