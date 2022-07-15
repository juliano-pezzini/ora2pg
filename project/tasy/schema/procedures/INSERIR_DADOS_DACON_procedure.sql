-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_dados_dacon (nr_seq_dacon_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_referencia_w	timestamp;
nr_seq_nota_fiscal_w	bigint;

C01 CURSOR FOR
	SELECT 	n.nr_sequencia
	from	nota_fiscal n,
		operacao_nota o
	where	n.cd_operacao_nf = o.cd_operacao_nf
	and	o.ie_servico = 'S' -- nota de serviço
	and	o.ie_operacao_fiscal = 'S' --saida
	and	n.ie_situacao = 1 -- ativa
	and	(n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '')   -- nota calculada
	and	to_char(n.dt_emissao,'mm/yyyy') = to_char(dt_referencia_w,'mm/yyyy');



BEGIN

select 	dt_referencia
into STRICT	dt_referencia_w
from	dacon
where	nr_sequencia = nr_seq_dacon_p;

open c01;
	loop
	fetch c01 into
		nr_seq_nota_fiscal_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		insert
		into dacon_nota_fiscal(nr_sequencia,
					 dt_atualizacao,
					 nm_usuario,
					 dt_atualizacao_nrec,
					 nm_usuario_nrec,
					 nr_seq_nota_fiscal,
					 nr_seq_dacon)
		values (nextval('dacon_nota_fiscal_seq'),
					 clock_timestamp(),
					 nm_usuario_p,
					 clock_timestamp(),
					 nm_usuario_p,
					 nr_seq_nota_fiscal_w,
					 nr_seq_dacon_p);


		commit;
	end loop;
	close C01;
commit;

update dacon set dt_geracao = clock_timestamp()
where nr_sequencia = nr_seq_dacon_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_dados_dacon (nr_seq_dacon_p bigint, nm_usuario_p text) FROM PUBLIC;

