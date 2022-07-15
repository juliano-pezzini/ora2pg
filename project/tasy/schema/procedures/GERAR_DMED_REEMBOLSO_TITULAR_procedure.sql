-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dmed_reembolso_titular ( nr_seq_titular_p bigint, cd_pessoa_fisica_p text, nr_seq_dmed_p text, nm_usuario_p text, cd_estabelecimento_p text) AS $body$
DECLARE


vl_total_w		double precision;
nr_seq_titular_w		bigint;
cd_pessoa_fisica_w	varchar(10);
dt_ano_calendario_w	varchar(255);
cd_cgc_w		varchar(14);
cd_cpf_w			varchar(20);

C01 CURSOR FOR

	SELECT	a.nr_seq_titular,
		sum(b.vl_total) vl_total,
		obter_cpf_pessoa_fisica(b.cd_pessoa_fisica),
		b.cd_pessoa_fisica,
		b.cd_cgc
	from	pls_protocolo_conta d,
		pls_conta b,
		pls_segurado a
	where	a.nr_sequencia = d.nr_seq_segurado
	and	b.nr_seq_protocolo = d.nr_sequencia
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	coalesce(a.nr_seq_titular::text, '') = ''
	and	b.vl_total > 0
	and	obter_se_reembolso_pago(d.nr_sequencia, to_date(dt_ano_calendario_w,'yyyy')) = 'S'
	and 	(to_char(d.dt_mes_competencia,'yyyy') = dt_ano_calendario_w
	or	to_char(d.dt_mes_competencia,'yyyy') = (dt_ano_calendario_w - 1))
	and	d.ie_tipo_protocolo = 'R'
	and  	((a.cd_estabelecimento = coalesce( cd_estabelecimento_p ,a.cd_estabelecimento))
	or   	((coalesce(a.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = '')))
	group by a.nr_seq_titular, obter_cpf_pessoa_fisica(b.cd_pessoa_fisica), b.cd_cgc, b.cd_pessoa_fisica
	order by obter_cpf_pessoa_fisica(b.cd_pessoa_fisica), b.cd_cgc, b.cd_pessoa_fisica;


BEGIN

	select 	to_char(dt_ano_calendario)
	into STRICT	dt_ano_calendario_w
	from	dmed
	where	nr_sequencia = nr_seq_dmed_p;

open C01;
loop
fetch C01 into
	nr_seq_titular_w,
	vl_total_w,
	cd_cpf_w,
	cd_pessoa_fisica_w,
	cd_cgc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	Insert into dmed_ops_reembolso(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_cgc,
		cd_pessoa_fisica,
		vl_reembolso,
		nr_seq_titular,
		nr_seq_dependente)
	values (	nextval('dmed_ops_reembolso_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_cgc_w,
		cd_pessoa_fisica_w,
		vl_total_w,
		nr_seq_titular_p,
		null);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dmed_reembolso_titular ( nr_seq_titular_p bigint, cd_pessoa_fisica_p text, nr_seq_dmed_p text, nm_usuario_p text, cd_estabelecimento_p text) FROM PUBLIC;

