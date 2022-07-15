-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dmed_dependente_titular ( nr_seq_titular_p bigint, cd_pessoa_fisica_p text, nr_seq_titular_pp bigint, nr_seq_dmed_p text, nm_usuario_p text, cd_estabelecimento_p text) AS $body$
DECLARE



vl_total_w			double precision;
nr_seq_titular_w			bigint;
cd_pessoa_fisica_w		varchar(14);
dt_ano_calendario_w		varchar(20);
ie_relacao_dependencia_w		varchar(2);
nr_cpf_w				varchar(14);
nr_sequencia_w			bigint;
nr_sequencia_ww			bigint;


C01 CURSOR FOR
	SELECT   c.nr_cpf,
		 c.cd_pessoa_fisica,
		 sum(d.vl_item) vl_mensalidade,
		 CASE WHEN g.ie_grau_parentesco='4' THEN  '03' WHEN g.ie_grau_parentesco='3' THEN  '04' WHEN g.ie_grau_parentesco='5' THEN  '06' WHEN g.ie_grau_parentesco='6' THEN  '06'  ELSE '04' END  ie_relacao
	FROM pls_segurado tit, pls_plano p, pls_mensalidade_segurado e, pls_mensalidade_seg_item d, pessoa_fisica c, pls_segurado a
LEFT OUTER JOIN grau_parentesco g ON (a.nr_seq_parentesco = g.nr_sequencia)
WHERE a.cd_pessoa_fisica = c.cd_pessoa_fisica and a.nr_sequencia = e.nr_seq_segurado and a.nr_seq_plano = p.nr_sequencia and e.nr_Sequencia = d.nr_seq_mensalidade_seg and a.nr_seq_titular = tit.nr_sequencia  and obter_Se_titulo_pago(e.nr_seq_mensalidade, dt_ano_calendario_w) = 'S' and p.ie_tipo_contratacao in ('I','CA') and tit.cd_pessoa_fisica = cd_pessoa_fisica_p and d.ie_tipo_item in (	SELECT ie_tipo_item
				from   dmed_regra_tipo_item) and (to_char(e.dt_mesano_referencia,'yyyy') = dt_ano_calendario_w
	or	 to_char(e.dt_mesano_referencia,'yyyy') = (dt_ano_calendario_w - 1)) and (to_char(a.dt_contratacao,'yyyy'))::numeric  <= (dt_ano_calendario_w)::numeric and ((a.cd_estabelecimento = coalesce( cd_estabelecimento_p ,a.cd_estabelecimento))
	or   	 ((coalesce(a.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = ''))) group by c.cd_pessoa_fisica, c.nr_cpf,
		 CASE WHEN g.ie_grau_parentesco='4' THEN  '03' WHEN g.ie_grau_parentesco='3' THEN  '04' WHEN g.ie_grau_parentesco='5' THEN  '06' WHEN g.ie_grau_parentesco='6' THEN  '06'  ELSE '04' END
	having 	 sum(d.vl_item) > 0
	order by c.nr_cpf;


BEGIN
	select 	to_char(dt_ano_calendario)
	into STRICT	dt_ano_calendario_w
	from	dmed
	where	nr_sequencia = nr_seq_dmed_p;

	open C01;
	loop
	fetch C01 into
		nr_cpf_w,
		cd_pessoa_fisica_w,
		vl_total_w,
		ie_relacao_dependencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	nextval('dmed_ops_depend_titular_seq')
		into STRICT	nr_sequencia_w
		;

		Insert into dmed_ops_depend_titular(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_pessoa_fisica,
							ie_relacao_dependencia,
							vl_pago_ano,
							nr_seq_dmed_titular,
							nr_seq_segurado)
					values (
							nr_sequencia_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_pessoa_fisica_w,
							ie_relacao_dependencia_w,
							vl_total_w,
							nr_seq_titular_p,
							null);

	CALL gerar_dmed_reembolso_depend(	nr_sequencia_w,
					cd_pessoa_fisica_w,
					nr_seq_titular_p,
					nr_seq_dmed_p,
					nm_usuario_p,
					cd_estabelecimento_p);

		end;
	end loop;
	close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dmed_dependente_titular ( nr_seq_titular_p bigint, cd_pessoa_fisica_p text, nr_seq_titular_pp bigint, nr_seq_dmed_p text, nm_usuario_p text, cd_estabelecimento_p text) FROM PUBLIC;

