-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_requisitos_projeto (nr_seq_analise_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_ordem_serv_w	bigint;
nr_seq_proj_w	bigint;
dt_lib_analise_w	timestamp;

C01 CURSOR FOR
	SELECT	b.nr_seq_pr
	from	des_requisito a,
			des_requisito_item b
	where	a.nr_sequencia = b.nr_seq_requisito
	and 	coalesce(a.dt_aprovacao::text, '') = ''
	and		a.nr_seq_projeto = nr_seq_proj_w
	and		not exists (SELECT	1
						from	man_ordem_serv_impacto c,
								man_ordem_serv_imp_pr d
						where	c.nr_sequencia = nr_seq_impacto
						and		c.nr_seq_ordem_serv = nr_seq_ordem_serv_w
						and		b.nr_seq_pr = d.nr_product_requirement
						and		coalesce(c.dt_aprovacao::text, '') = ''
						and		not exists (select	1
											from	man_ordem_serv_aprov_ccb e
											where	e.nr_seq_impacto = c.nr_sequencia
											and ie_status('P')
											)
						);

BEGIN

select	max(nr_seq_ordem_serv)
into STRICT	nr_seq_ordem_serv_w
from	man_ordem_serv_impacto
where	nr_sequencia = nr_seq_analise_p;

select	max(nr_sequencia)
into STRICT	nr_seq_proj_w
from	proj_projeto
where	nr_seq_ordem_serv = nr_seq_ordem_serv_w;

if (nr_seq_proj_w IS NOT NULL AND nr_seq_proj_w::text <> '') then

	select	max(dt_liberacao)
	into STRICT	dt_lib_analise_w
	from	man_ordem_serv_impacto
	where	nr_sequencia = nr_seq_analise_p;

	if (dt_lib_analise_w IS NOT NULL AND dt_lib_analise_w::text <> '') then
		CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(1023033);
	end if;

	FOR R_C01 in C01 LOOP
		insert into man_ordem_serv_imp_pr(
			nr_sequencia,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_usuario,
			dt_atualizacao,
			nr_product_requirement,
			nr_seq_impacto)
		values (
			nextval('man_ordem_serv_imp_pr_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			R_C01.nr_seq_pr,
			nr_seq_analise_p);
	END LOOP;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_requisitos_projeto (nr_seq_analise_p bigint, nm_usuario_p text) FROM PUBLIC;
