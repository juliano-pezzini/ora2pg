-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_inserir_reinf_2070 ( nm_usuario_p text, nr_seq_superior_p bigint, nr_titulo_p bigint) AS $body$
DECLARE


dt_inicial_w		fis_reinf_r2020.dt_competencia%type;
dt_final_w		fis_reinf_r2020.dt_competencia%type;
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
cd_cnpj_w		pessoa_juridica.cd_cgc%type;
cd_cnpj_pagador_w	estabelecimento.cd_cgc%type;
dt_pagamento_w		titulo_pagar_baixa.dt_real_pagamento%type;
vl_rendimento_w		titulo_pagar_baixa.vl_baixa%type;
vl_tributo_w		titulo_pagar_imposto.vl_imposto%type;
pr_reducao_base_w	tributo_conta_pagar.pr_reducao_base%type;
cd_tributo_w		tributo.cd_tributo%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;


BEGIN

select 	pkg_date_utils.start_of(a.dt_apuracao, 'MONTH', 0) dt_inicial,
	pkg_date_utils.end_of(a.dt_apuracao, 'MONTH', 0) dt_final,
	a.cd_estabelecimento cd_estabelecimento
into STRICT	dt_inicial_w,
	dt_final_w,
	cd_estabelecimento_w
from	fis_reinf_r2070 a
where 	a.nr_sequencia = nr_seq_superior_p;


select	p.cd_pessoa_fisica,
		p.cd_cgc,
		obter_cgc_estabelecimento(coalesce(p.cd_estab_financeiro, p.cd_estabelecimento)) cd_cnpj_pagador,
		b.dt_real_pagamento dt_pagamento,
		b.vl_baixa vl_rendimento,
		i.vl_imposto vl_tributo,
		c.pr_reducao_base
into STRICT
	cd_pessoa_fisica_w,
			cd_cnpj_w,
			cd_cnpj_pagador_w,
			dt_pagamento_w,
			vl_rendimento_w,
			vl_tributo_w,
			pr_reducao_base_w
	FROM tributo t, titulo_pagar_imposto i, titulo_pagar_baixa b, titulo_pagar p
LEFT OUTER JOIN tributo_conta_pagar c ON (p.cd_estabelecimento = c.cd_estabelecimento)
WHERE p.nr_titulo = b.nr_titulo and p.nr_titulo = i.nr_titulo and i.cd_tributo = t.cd_tributo and t.cd_tributo = c.cd_tributo  and p.ie_situacao <> 'C' and ((p.cd_estabelecimento = cd_estabelecimento_w) or (p.cd_estab_financeiro = cd_estabelecimento_w)) and b.dt_real_pagamento between dt_inicial_w and dt_final_w and t.cd_tributo = cd_tributo_w and p.nr_titulo  = nr_titulo_p and not exists (	SELECT 	1
				from 	fis_reinf_titulos_r2070 d
				where	d.nr_titulo = p.nr_titulo
				and	p.nr_titulo = d.nr_titulo) and not exists (	select 	1
				from 	titulo_pagar_baixa x
				where	x.nr_titulo = p.nr_titulo
				and	x.nr_seq_baixa_origem = b.nr_sequencia);

	if (dt_pagamento_w IS NOT NULL AND dt_pagamento_w::text <> '') then
	insert into fis_reinf_titulos_r2070(
				nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				cd_pessoa_fisica,
				cd_cnpj,
				nr_titulo,
				dt_pagamento,
				vl_rendimento,
				vl_tributo,
				cd_cnpj_pagador,
				pr_reducao_base,
				nr_seq_superior)

			values (	nextval('fis_reinf_titulos_r2070_seq'),
				cd_estabelecimento_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_pessoa_fisica_w,
				cd_cnpj_w,
				nr_titulo_p,
				dt_pagamento_w,
				vl_rendimento_w,
				vl_tributo_w,
				cd_cnpj_pagador_w,
				pr_reducao_base_w,
				nr_seq_superior_p);
	commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_inserir_reinf_2070 ( nm_usuario_p text, nr_seq_superior_p bigint, nr_titulo_p bigint) FROM PUBLIC;
