-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_regra_desfazer_susp ( nr_seq_contrato_p bigint, nr_seq_forma_cobranca_p bigint, cd_pessoa_fisica_p text, ie_situacao_titulo_p titulo_receber.ie_situacao%type, cd_cgc_p text, cd_estabelecimento_p text, nr_seq_motivo_susp_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(10) := 'N';

C01 CURSOR FOR
	SELECT	a.ie_atualizar_susp_atend
	from	pls_regra_desfazer_susp a
	where	((a.nr_seq_contrato = nr_seq_contrato_p) or (coalesce(a.nr_seq_contrato::text, '') = ''))
	and	((a.nr_seq_forma_cobranca = nr_seq_forma_cobranca_p) or (coalesce(a.nr_seq_forma_cobranca::text, '') = ''))
	and (coalesce(a.cd_pessoa_fisica_pag,coalesce(cd_pessoa_fisica_p,'X')) = coalesce(cd_pessoa_fisica_p,'X')
	or (coalesce(a.cd_cgc_pag,coalesce(cd_cgc_p,'X')) = coalesce(cd_cgc_p,'X')))
	and (ie_consid_baixa_perda	= 'S' and ie_situacao_titulo_p = '6' or ie_situacao_titulo_p <> '6')
	and	a.cd_estabelecimento = cd_estabelecimento_p
	and	((a.nr_seq_motivo_susp = nr_seq_motivo_susp_p) or (coalesce(a.nr_seq_motivo_susp::text, '') = ''))
	order by
		coalesce(a.nr_seq_contrato,0),
		coalesce(a.nr_seq_forma_cobranca,' '),
		coalesce(a.cd_pessoa_fisica_pag,'X'),
		coalesce(a.cd_cgc_pag,'X'),
		coalesce(a.nr_seq_motivo_susp,0);


BEGIN
select	coalesce(max(ie_atualizar_susp_atend),'N')
into STRICT	ie_retorno_w
from	pls_parametros_cr
where	cd_estabelecimento = cd_estabelecimento_p;

open C01;
loop
fetch C01 into
	ie_retorno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_regra_desfazer_susp ( nr_seq_contrato_p bigint, nr_seq_forma_cobranca_p bigint, cd_pessoa_fisica_p text, ie_situacao_titulo_p titulo_receber.ie_situacao%type, cd_cgc_p text, cd_estabelecimento_p text, nr_seq_motivo_susp_p bigint) FROM PUBLIC;
