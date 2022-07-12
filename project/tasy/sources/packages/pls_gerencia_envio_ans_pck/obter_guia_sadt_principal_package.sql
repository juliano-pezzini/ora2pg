-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerencia_envio_ans_pck.obter_guia_sadt_principal ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_guia_p pls_conta.cd_guia%type, cd_guia_referencia_p pls_conta.cd_guia_referencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_tipo_anted_p pls_tipo_atendimento.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type) RETURNS varchar AS $body$
DECLARE


ie_internado_w		pls_tipo_atendimento.ie_internado%type := 'N';
nr_seq_conta_w		pls_conta.nr_sequencia%type;
cd_guia_princ_w		pls_conta.cd_guia%type := null;


BEGIN
if (nr_seq_tipo_anted_p IS NOT NULL AND nr_seq_tipo_anted_p::text <> '') then
	select	ie_internado
	into STRICT	ie_internado_w
	from	pls_tipo_atendimento
	where	nr_sequencia = nr_seq_tipo_anted_p;
end if;

--SADT

if (ie_tipo_guia_p = '4') and (ie_internado_w <> 'S') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_conta_w
	from	pls_conta
	where	cd_guia_ok = cd_guia_referencia_p
	and	nr_seq_segurado = nr_seq_segurado_p
	and	ie_tipo_guia = '4'
	and	nr_sequencia <> nr_seq_conta_p;

	if (nr_seq_conta_w IS NOT NULL AND nr_seq_conta_w::text <> '') then
		select	cd_guia
		into STRICT	cd_guia_princ_w
		from	pls_conta
		where	nr_sequencia = nr_seq_conta_w;

		if (cd_guia_p = cd_guia_princ_w) then
			cd_guia_princ_w := null;
		end if;
	end if;
end if;

return cd_guia_princ_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerencia_envio_ans_pck.obter_guia_sadt_principal ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_guia_p pls_conta.cd_guia%type, cd_guia_referencia_p pls_conta.cd_guia_referencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_tipo_anted_p pls_tipo_atendimento.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type) FROM PUBLIC;