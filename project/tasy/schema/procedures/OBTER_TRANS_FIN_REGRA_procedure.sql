-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_trans_fin_regra ( ie_evento_p text, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_convenio_p bigint, cd_banco_p bigint, IE_TIPO_TITULO_P text, nr_seq_conta_banco_p bigint, nr_seq_carteira_cobr_p bigint, nr_seq_classe_p bigint, nr_seq_trans_financ_p INOUT bigint) AS $body$
DECLARE


nr_seq_trans_financ_w	bigint;
nr_seq_regra_w		bigint;
ie_tipo_convenio_w	bigint;
ie_pessoa_w		varchar(255);

c01 CURSOR FOR
SELECT	a.nr_seq_trans_financ,
	a.nr_sequencia
from	regra_trans_financ a
where	a.ie_evento						= ie_evento_p
and	a.cd_estabelecimento					= cd_estabelecimento_p
and	a.ie_situacao						= 'A'
and	coalesce(a.cd_pessoa_fisica,coalesce(cd_pessoa_fisica_p,0))		= coalesce(cd_pessoa_fisica_p,0)
and	coalesce(a.cd_cgc,coalesce(cd_cgc_p,0))				= coalesce(cd_cgc_p,0)
and	coalesce(a.cd_convenio,coalesce(cd_convenio_p,0))			= coalesce(cd_convenio_p,0)
and	coalesce(a.ie_tipo_convenio, ie_tipo_convenio_w)			= ie_tipo_convenio_w
and	coalesce(a.cd_banco,coalesce(cd_banco_p,0))				= coalesce(cd_banco_p,0)
and	coalesce(a.nr_seq_conta_banco,coalesce(nr_seq_conta_banco_p,0))		= coalesce(nr_seq_conta_banco_p,0)
and	coalesce(a.nr_seq_carteira_cobr,coalesce(nr_seq_carteira_cobr_p,0))	= coalesce(nr_seq_carteira_cobr_p,0)
and	coalesce(a.ie_tipo_titulo_pagar, coalesce(ie_tipo_titulo_p, 'X'))			= coalesce(ie_tipo_titulo_p, 'X')
and	coalesce(a.nr_seq_classe, coalesce(nr_seq_classe_p,0))			= coalesce(nr_seq_classe_p,0)
and	((coalesce(a.ie_pessoa, 'A')	= 'A') or (coalesce(a.ie_pessoa, 'A') 	= ie_pessoa_w))
order 	by coalesce(a.cd_pessoa_fisica,0),
	coalesce(a.cd_cgc,0),
	coalesce(a.cd_convenio,0),
	coalesce(a.nr_seq_carteira_cobr,0),
	coalesce(a.nr_seq_conta_banco,0),
	coalesce(a.cd_banco,0),
	coalesce(a.ie_tipo_convenio,0),
	coalesce(a.ie_pessoa,0),
	coalesce(a.nr_seq_classe,0);


BEGIN

nr_seq_trans_financ_w	:= null;

select	coalesce(max(ie_tipo_convenio),0)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio	= cd_convenio_p;

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	ie_pessoa_w	:= 'F';
else
	ie_pessoa_w	:= 'J';
end if;

open c01;
loop
	fetch c01 into
		nr_seq_trans_financ_w,
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

end loop;
close c01;

nr_seq_trans_financ_p			:= nr_seq_trans_financ_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_trans_fin_regra ( ie_evento_p text, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, cd_convenio_p bigint, cd_banco_p bigint, IE_TIPO_TITULO_P text, nr_seq_conta_banco_p bigint, nr_seq_carteira_cobr_p bigint, nr_seq_classe_p bigint, nr_seq_trans_financ_p INOUT bigint) FROM PUBLIC;
