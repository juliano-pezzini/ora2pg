-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_ocor_glosa ( nr_seq_motivo_p tiss_motivo_glosa.nr_sequencia%type, ie_glosa_p pls_ocorrencia.ie_glosa%type, ie_regra_combinada_p pls_ocorrencia.ie_regra_combinada%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ie_glosa_w		varchar(1) := 'N';
qt_ocor_w		integer;
ie_ocorrencia_w		pls_controle_estab.ie_ocorrencia%type := pls_obter_se_controle_estab('GO');


BEGIN

if (ie_ocorrencia_w = 'S') then

	select	count(1)
	into STRICT	qt_ocor_w
	from	pls_ocorrencia
	where	nr_seq_motivo_glosa = nr_seq_motivo_p
	and	ie_situacao = 'A'
	and (ie_glosa = ie_glosa_p or coalesce(ie_glosa_p::text, '') = '')
	and (ie_regra_combinada = ie_regra_combinada_p or coalesce(ie_regra_combinada_p::text, '') = '')
	and	cd_estabelecimento = cd_estabelecimento_p;

	if (qt_ocor_w > 0) then
		ie_glosa_w := 'S';
	end if;
else
	select	count(1)
	into STRICT	qt_ocor_w
	from	pls_ocorrencia
	where	nr_seq_motivo_glosa = nr_seq_motivo_p
	and	ie_situacao = 'A'
	and (ie_glosa = ie_glosa_p or coalesce(ie_glosa_p::text, '') = '')
	and (ie_regra_combinada = ie_regra_combinada_p or coalesce(ie_regra_combinada_p::text, '') = '');

	if (qt_ocor_w > 0) then
		ie_glosa_w := 'S';
	end if;
end if;

return	ie_glosa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_ocor_glosa ( nr_seq_motivo_p tiss_motivo_glosa.nr_sequencia%type, ie_glosa_p pls_ocorrencia.ie_glosa%type, ie_regra_combinada_p pls_ocorrencia.ie_regra_combinada%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
