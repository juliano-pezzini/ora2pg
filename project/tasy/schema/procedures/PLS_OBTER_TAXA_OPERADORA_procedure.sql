-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_taxa_operadora ( ie_cobranca_pagamento_p text, qt_dia_proced_receb_p bigint, nr_seq_congenere_p bigint, cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, dt_referencia_p timestamp, nm_usuario_p text, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, pr_taxa_p INOUT bigint, ie_taxa_p INOUT text) AS $body$
DECLARE


pr_taxa_w			double precision;
pr_taxa_util_w			double precision;
pr_taxa_ww			double precision;
nr_seq_grupo_coop_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_plano_w			bigint;
ie_seguro_obito_w			varchar(1);
ie_beneficio_obito_w		varchar(1);
ie_pcmso_w			varchar(10);
nr_sequencia_w			bigint;
ie_tipo_regra_w			varchar(3);
ie_tipo_segurado_w			pls_segurado.ie_tipo_segurado%type;
nr_seq_grupo_rec_w		bigint;

C01 CURSOR FOR
	SELECT	a.pr_taxa
	from	pls_regra_intercambio	a
	where	trunc(coalesce(dt_referencia_p,clock_timestamp()),'dd') between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp() + interval '1 days')
	and	coalesce(a.qt_dias_envio_conta,0)	>= qt_dia_proced_receb_p
	and	((pls_obter_tipo_intercambio(nr_seq_congenere_p,cd_estabelecimento_p) = coalesce(a.ie_tipo_intercambio,'A')) or (coalesce(a.ie_tipo_intercambio,'A') = 'A'))
	and	a.nr_seq_intercambio	= nr_seq_intercambio_w
	and (a.nr_seq_grupo_coop_seg = nr_seq_grupo_coop_w or coalesce(a.nr_seq_grupo_coop_seg::text, '') = '')
	and     ((coalesce(a.nr_seq_grupo_servico::text, '') = '') or (nr_seq_grupo_servico in ( SELECT  g.nr_seq_grupo
                                                                                from    pls_preco_servico       g
                                                                                where   g.cd_procedimento       = cd_procedimento_p
                                                                                and     g.ie_origem_proced      = ie_origem_proced_p)))
	and (coalesce(a.nr_seq_grupo_rec, nr_seq_grupo_rec_w) = nr_seq_grupo_rec_w)
	order by dt_inicio_vigencia,
		coalesce(nr_seq_intercambio,0),
		coalesce(ie_tipo_intercambio,0),
		coalesce(qt_dias_envio_taxa,0),
		coalesce(a.nr_seq_grupo_servico,0),
		coalesce(a.nr_seq_grupo_rec, 0);

C02 CURSOR FOR
	SELECT	a.pr_taxa,
		a.ie_beneficio_obito
	from	pls_regra_intercambio	a
	where	1 = 1
	and	trunc(coalesce(dt_referencia_p,clock_timestamp()),'dd') between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and	coalesce(a.qt_dias_envio_taxa,365)	>= qt_dia_proced_receb_p
	and	((pls_obter_tipo_intercambio(nr_seq_congenere_p,cd_estabelecimento_p) = coalesce(a.ie_tipo_intercambio,'A')) or (coalesce(a.ie_tipo_intercambio,'A') = 'A'))
	and	coalesce(a.nr_seq_congenere_sup,coalesce(a.nr_seq_congenere,nr_seq_congenere_p))		= nr_seq_congenere_p
	and	coalesce(a.nr_seq_plano,nr_seq_plano_w) = nr_seq_plano_w
	and	ie_cobranca_pagamento	= ie_cobranca_pagamento_p
	and (coalesce(ie_pcmso,'N')		= ie_pcmso_w)
	and     ((coalesce(a.nr_seq_grupo_servico::text, '') = '') or (nr_seq_grupo_servico in ( SELECT  g.nr_seq_grupo
                                                                                from    pls_preco_servico       g
                                                                                where   g.cd_procedimento       = cd_procedimento_p
                                                                                and     g.ie_origem_proced      = ie_origem_proced_p)))
	and (a.nr_seq_grupo_coop_seg = nr_seq_grupo_coop_w or coalesce(a.nr_seq_grupo_coop_seg::text, '') = '')
	and (coalesce(a.nr_seq_grupo_rec, nr_seq_grupo_rec_w) = nr_seq_grupo_rec_w)
	and (coalesce(a.nr_seq_grupo_congenere::text, '') = '' or
		exists (select	1
			from	pls_cooperativa_grupo	x
			where	x.nr_seq_grupo = a.nr_seq_grupo_congenere
			and	x.nr_seq_congenere = nr_seq_congenere_p))
	and (coalesce(a.ie_tipo_regra::text, '') = '' or a.ie_tipo_regra = ie_tipo_regra_w)
	order by coalesce(a.ie_tipo_intercambio,'A'),
		coalesce(nr_seq_grupo_coop_seg,0),
		CASE WHEN ie_pcmso='N' THEN -1  ELSE 1 END ,
		coalesce(nr_seq_plano,0),
		coalesce(nr_seq_congenere,0),
		coalesce(nr_seq_grupo_congenere,0),
		coalesce(ie_cobranca_pagamento,0),
		dt_inicio_vigencia,
		coalesce(qt_dias_envio_taxa,999),
		coalesce(a.nr_seq_grupo_servico,0),
		coalesce(a.nr_seq_grupo_rec, 0);


BEGIN
/* Francisco - 30/08/2013 - OS 637684
Por default colocar o tipo de regra como cooperativa
*/
ie_tipo_regra_w	:= 'CO';

begin
	select	nr_seq_intercambio,
		--nr_seq_plano,
		pls_obter_produto_benef(nr_sequencia,dt_referencia_p),
		coalesce(ie_pcmso,'N'),
		nr_seq_grupo_coop,
		ie_tipo_segurado
	into STRICT	nr_seq_intercambio_w,
		nr_seq_plano_w,
		ie_pcmso_w,
		nr_seq_grupo_coop_w,
		ie_tipo_segurado_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	nr_seq_intercambio_w	:= null;
	nr_seq_plano_w		:= null;
	ie_pcmso_w		:= 'N';
	nr_seq_grupo_coop_w	:= null;
end;

/* Francisco - 30/08/2013 - OS 637684
Se for beneficiário assumido de OPS congênere, buscar regra de lá
*/
if (ie_tipo_segurado_w = 'C') then
	ie_tipo_regra_w	:= 'CE';
end if;

begin
select	coalesce(ie_seguro_obito,'N')
into STRICT	ie_seguro_obito_w
from	pls_plano
where	nr_sequencia = nr_seq_plano_w;
exception
when others then
	ie_seguro_obito_w := 'N';
end;

begin
	select  coalesce(a.nr_seq_grupo_rec, '0')
	into STRICT	nr_seq_grupo_rec_w
	from    procedimento a
	where   a.cd_procedimento       = cd_procedimento_p
	and     a.ie_origem_proced      = ie_origem_proced_p;
exception
	when others then
	nr_seq_grupo_rec_w := '0';
end;

/*aaschlote 04/01/2011 - OS 278997 - Verificar primeiramente se o beneficiário possui contrato de intercâmbio, caso possuir, o sistema deve pegar de lá*/

if (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
	open C01;
	loop
	fetch C01 into
		pr_taxa_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
end if;

/* Se não encontrou taxa de intercâmbio no contrato, verificar nas regras gerais da cooperativa. */

if (coalesce(pr_taxa_w,0) = 0) then
	open C02;
	loop
	fetch C02 into
		pr_taxa_ww,
		ie_beneficio_obito_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		pr_taxa_w	:= null;
		if (ie_seguro_obito_w = 'B') then
			if (coalesce(ie_beneficio_obito_w,'N') = 'S') then
				pr_taxa_w := pr_taxa_ww;
			end if;
		else
			pr_taxa_w := pr_taxa_ww;
		end if;

		if (pr_taxa_w IS NOT NULL AND pr_taxa_w::text <> '') then
			pr_taxa_util_w := pr_taxa_w;
		end if;
	end loop;
	close C02;
end if;

ie_taxa_p	:= 'N';
pr_taxa_p	:= coalesce(pr_taxa_util_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_taxa_operadora ( ie_cobranca_pagamento_p text, qt_dia_proced_receb_p bigint, nr_seq_congenere_p bigint, cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, dt_referencia_p timestamp, nm_usuario_p text, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, pr_taxa_p INOUT bigint, ie_taxa_p INOUT text) FROM PUBLIC;

