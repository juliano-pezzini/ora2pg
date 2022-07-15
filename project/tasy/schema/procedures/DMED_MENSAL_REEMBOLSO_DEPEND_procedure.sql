-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dmed_mensal_reembolso_depend (nr_seq_dmed_p bigint, dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_cpf_p text, ie_idade_p text, ie_estrangeiro_p text) AS $body$
DECLARE


vl_total_w		double precision;
nr_seq_titular_w		bigint;
nr_titulo_w		bigint;
cd_pessoa_fisica_w	varchar(10);
dt_ano_calendario_w	varchar(5);
cd_cgc_w		varchar(14);
cd_cpf_w			varchar(14);
dt_liquidacao_w		timestamp;
contador_w		bigint;
qt_registros_w		bigint;
qt_registros_ww		bigint;
ie_cpf_w		varchar(2) := ie_cpf_p;
nr_cpf_w		varchar(11);
idade_w			bigint;
dt_nascimento_w		timestamp;

c01 CURSOR FOR

	SELECT	p.nr_titulo,
		p.vl_titulo vl_total,
		p.dt_liquidacao,
		a.cd_pessoa_fisica
	from	titulo_pagar p,
		pls_protocolo_conta d,
		pls_conta b,
		pls_segurado a,
		pls_plano t
	where	d.nr_sequencia = p.nr_seq_reembolso
	and	d.nr_seq_segurado = a.nr_sequencia
	and	d.nr_sequencia = b.nr_seq_protocolo
	and	a.nr_seq_plano = t.nr_sequencia
	and	(a.nr_seq_titular IS NOT NULL AND a.nr_seq_titular::text <> '')
	and	b.vl_total > 0
	and	p.ie_situacao <> 'C'
	and	d.ie_tipo_protocolo = 'R'
	and	 t.ie_tipo_contratacao in ('I','CA')
--	and 	trunc(d.dt_mes_competencia,'mm') = trunc(dt_referencia_p,'mm')
	and  	((a.cd_estabelecimento = coalesce(cd_estabelecimento_p ,a.cd_estabelecimento))
	or   	((coalesce(a.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = '')))
	and	pkg_date_utils.start_of(p.dt_liquidacao,'MONTH',0) <= pkg_date_utils.start_of(dt_referencia_p,'MONTH',0)
	and	pkg_date_utils.start_of(p.dt_liquidacao,'YEAR',0) = pkg_date_utils.start_of(dt_referencia_p,'YEAR',0)
	order by p.dt_liquidacao, p.nr_titulo, b.vl_total;


BEGIN

select 	coalesce(max(nr_idade),16)
into STRICT 	idade_w
from 	dmed_regra_geral;

open C01;
loop
fetch C01 into
	nr_titulo_w,
	vl_total_w,
	dt_liquidacao_w,
	cd_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	count(*)
	into STRICT	qt_registros_w
	from	dmed_titulos_mensal
	where	nr_documento = nr_titulo_w;

	select	count(*)
	into STRICT	qt_registros_ww
	from	titulo_pagar p
	where	nr_titulo = nr_titulo_w
	and	pkg_date_utils.start_of(p.dt_liquidacao,'YEAR',0) = pkg_date_utils.start_of(dt_referencia_p,'YEAR',0);

	select	nr_cpf,
		dt_nascimento
	into STRICT	nr_cpf_w,
		dt_nascimento_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	if 	(	(qt_registros_w = 0) and (qt_registros_ww > 0) and
			((ie_cpf_w = 'CC') and ((nr_cpf_w IS NOT NULL AND nr_cpf_w::text <> '') or (pkg_date_utils.add_month(dt_nascimento_w, 18 * 12,0) >= Fim_Mes(dt_referencia_p)))) or
			((ie_cpf_w = 'SC') and (coalesce(nr_cpf_w::text, '') = '')) or (ie_cpf_w = 'AM')	) then

		insert into dmed_titulos_mensal(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_dmed_mensal,
						nr_documento,
						ie_tipo_documento,
						cd_pessoa_titular,
						cd_pessoa_beneficiario,
						vl_pago,
						dt_liquidacao,
						ie_prestadora_ops)
					values (	nextval('dmed_titulos_mensal_seq'),
						clock_timestamp(),
						'Tasy',
						clock_timestamp(),
						'Tasy',
						nr_seq_dmed_p,
						nr_titulo_w,
						'RE',
						cd_pessoa_fisica_w,
						cd_pessoa_fisica_w,
						vl_total_w,
						dt_liquidacao_w,
						'O');

		contador_w := contador_w + 1;

		if (contador_w mod 100 = 0) then
			commit;
		end if;
	end if;

	end;

end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dmed_mensal_reembolso_depend (nr_seq_dmed_p bigint, dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_cpf_p text, ie_idade_p text, ie_estrangeiro_p text) FROM PUBLIC;

